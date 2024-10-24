# from typing import Type
from datetime import timedelta,date,datetime
import email
from passlib.hash import bcrypt
import string
import random
from fastapi_jwt_auth import AuthJWT
from conf.sessions import get_redis_pool
from aioredis.client import PubSub, Redis
from conf.exeptions import UnauthError, UserBaseError, UsernameError, CodeConfirmationError,BadAccountError,ADError,UserMailError
# from conf.log import logger
from orm.models import User
from orm.schema import UserRegister,UserMultiUpload, UserLogin, claim_user, Codeconfirm
from .base import BaseService
import requests
import json
import re, sys, os, secrets
from dotenv import load_dotenv
from services.redis_key import *

def secret_key(size=6, chars=string.ascii_uppercase + string.digits)->str:
    return ''.join(random.choice(chars) for _ in range(size))



class AuthService(BaseService):
    
    @classmethod
    def hash_password(cls, password: str) -> str:
        return bcrypt.hash(password)

    @classmethod
    def verify_password(cls, plain_password: str, hashed_password: str) -> bool:
        return bcrypt.verify(plain_password, hashed_password)

    @classmethod
    def create_access(cls, Authorize: AuthJWT, user: User) -> str:
      
        return 'Bearer ' + Authorize.create_access_token(subject=user.username, user_claims= {"user": user.dict(include=claim_user)}, expires_time=timedelta(seconds=600))


    async def getADinfo(self, sAMAccountName)->dict:
        resp =requests.post('http://10.252.44.13:8005/', data=sAMAccountName)   
        # ! Стукалка в AD По Аккаунту
        pass
   
               

    async def create(self, into_schema: UserRegister, lotus_key:str, redis:Redis) -> dict:
           
        if await redis.exists(f"await_lotus_{into_schema.email}"):            
           
            if await redis.get(f"await_lotus_{into_schema.email}")== lotus_key:      
                     
                us = await User.objects.create(**await self.create_fk(into_schema.dict(), ("otdel", "rank", "position","department","organization")))                
                # await UserHistory.objects.create(user=us,who_did_it=us, type_action=True)
                
                return us
            raise UsernameError()

        raise CodeConfirmationError("Код подтверждения истек")
    
    
    
    
    async def codeLotusConfirm(self, user_data, user, lotus_key, redis:Redis):
        
        if await redis.exists(f"await_lotus_{user_data.email}"):
            if await redis.get(f"await_lotus_{user_data.email}")==lotus_key:           
            
                user.email = user_data.email
                await user.update()
                await redis.delete(f"await_lotus_{user_data.email}")
                return user
            else:                    
                raise CodeConfirmationError("Проверочный код введен неверно")                            
        else:                
            raise CodeConfirmationError("Код подтверждения истек")
        


    def UserCreatorPrep(self, user_data):
        # user_data={'sn': 'Ореховая',
        # 'title': 'Консультант',
        # 'physicalDeliveryOfficeName': 'Рахмановскийй пер., 4 стр. 1, каб 903',
        # 'telephoneNumber': '8(99)0000',
        # 'givenName': 'Наталья Дмитриевна',
        # 'organization': 'Центральный аппарат ФНС Росси',
        # 'otdel': '03 Отдел по стандартизации процессов НА КН',
        # 'department': {'description': ['22 Управление по крупнейшим налогоплательщикам'],
        # 'l': [], 'st': [], 'street': [], 'postalCode': []}, 'sAMAccountName': '0000-09-660'}
        newdict: UserRegister = {"sn": user_data["sn"],
                "position":{"name": user_data["title"]},
                "physicalDeliveryOfficeName":user_data["physicalDeliveryOfficeName"],
                "telephoneNumber":user_data["telephoneNumber"] if len(user_data["telephoneNumber"])>3 else None,
                "givenName": user_data["givenName"],
                "organization":{'name': user_data["organization"]},
                "otdel":{
                        "name": user_data["otdel"] if "otdel" in user_data.keys() else None},
                "department":{"name":user_data["department"]['description'][0] if 'department' in user_data.keys() else None,
                                'postal_code':user_data["department"]['postalCode'] if 'department' in user_data.keys() and len(user_data["department"]['postalCode'])>2 else None,
                                'city': user_data["department"]['l'] if 'department' in user_data.keys() and len(user_data["department"]['l'])>2  else None,
                                'region':user_data["department"]['st'] if 'department' in user_data.keys() and len(user_data["department"]['st'])>3 else None,
                                'street':user_data["department"]['street'] if 'department' in user_data.keys() and len(user_data["department"]['street'])>2 else None,
                
                },
                "rank":{"name":None},     
                "username":user_data["sAMAccountName"]
                }
                
        
        # print(newdict)
        return newdict
        
    
    async def auth(self, user_data: UserLogin, lotus_key:str, Authorize: AuthJWT, redis:Redis):
         # !Тут стукаемся в AD и забираем новые данные. Обновляем пользователя. если  что-то пойдет не так, выкидываем ему ошибки. 
        load_dotenv()
        
        user: User = await User.objects.select_related(["otdel", "rank","position","organization","department"]).filter(username=user_data.username).get_or_none()
        
        if os.environ["DEBUG"]!="True":            
            resp= requests.post('http://10.252.44.13:8005/getAD', json.dumps({'user': user_data.username, 'password':user_data.password, 'usercheck': user_data.username}))
            res = resp.json()
            # if True:
            if resp.status_code==200:
            # Авторизовались. Пробуем, есть ли юзер в бД
                # user: User = await User.objects.select_related(["otdel", "rank","position","organization","department"]).filter(username=user_data.username).get_or_none()
                
                if not user:
                    # если нету, создаем  
                                    
                    await User.objects.create(**await self.create_fk(self.UserCreatorPrep(res), ("organization","department","otdel", "rank", "position",)))
                    raise UserBaseError()
                else:                                     
                    await User.objects.filter(id=user.id).update(**await self.create_fk(self.UserCreatorPrep(res), ("organization","department","otdel", "rank", "position",), updating=True))
                    user: User = await User.objects.select_related(["otdel", "rank","position","organization","department"]).filter(username=user_data.username).get_or_none()
                    
                    if user_data.email and lotus_key:
                        user = await self.codeLotusConfirm(user_data, user,lotus_key,redis)
                    
                    
                    elif user.email is None:
                        raise UserMailError()
                
                
                    
            else:
                raise ADError(res['detail'])
        else:
            
            
            if not user:
                await User.objects.create(**await self.create_fk(self.UserCreatorPrep('res'), ("otdel", "rank", "position","department","organization")))
                raise UserBaseError()
            
          
            if user.email is None and user_data.email and lotus_key:    
                print("CONFIRM")                       
                user = await self.codeLotusConfirm(user_data, user,lotus_key,redis)
            
            if user.email is None:
                raise UserMailError()
        
        # Создали/обновили ключ пользователя в редисе при входе его в систему
        # ! надо проверить на обновление хз как
        await Rs_Worker.redis_key_setter(RedisSettings(f'users:user/{user.id}', querytoPydantic(UserFullInfo, user)))         
       
        
        access_token = self.create_access(Authorize, user)
        refresh_token = Authorize.create_refresh_token(subject=user.username)

        Authorize.set_refresh_cookies(refresh_token)
        # raise ADError("res['detail']")
        return {"access_token": access_token, 'refresh_token': refresh_token }
        
    
    @staticmethod
    async def codegeneration(user_data:dict, redis):
        
        if user_data.action in ["create"]:
            import string
            
            exist = await User.objects.filter(email=user_data.email).exists()
            if (not exist and user_data.action=="create"):
                secret = secret_key(chars=string.digits)        
                await redis.set(f"await_lotus_{user_data.email}", secret)
                await redis.expire(f"await_lotus_{user_data.email}", 300)      
                
                return {'secret': secret}

            elif (exist and user_data.action=="create"):
                text="Этот адрес Лотус уже есть в системе." 
        
            raise CodeConfirmationError(text)
            
      