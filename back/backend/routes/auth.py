import email
from urllib import request
from fastapi import (
    APIRouter,
    status,
    Depends,     

)
from typing import Union
from conf.sessions import get_redis_pool_gen
from fastapi_jwt_auth import AuthJWT
from orm.schema import UserRegister,UserMultiUpload, UserLogin, User, Codeconfirm
from services.depends import AD
from services.auth import AuthService, secret_key
from aioredis.client import PubSub, Redis
from services.redis_key import *
import asyncio
router = APIRouter()

# *Auth


@router.post("/auth/conf", tags=['Авторизация и пароли'])
    
async def create_key(user_data: Codeconfirm, redis: Redis=Depends(get_redis_pool_gen)):
    """Первичная отправка лотуса и создание ключа\n
       Принимает объекты:\n
                         {"action":"create", "email":"str"} - для получения кода (временно возвращает) \n
                         
                        
    """
    return await AuthService.codegeneration(user_data, redis)
    

# @router.post("/auth/restore", tags=['Авторизация и пароли'])
# async def restore_pwd(user_data: Restore_U ,auth_service: AuthService = Depends(AuthService),redis: Redis=Depends(get_redis_pool_gen)):
#     """Восстановление пароля должно произойти за 5 минут после его запроса"""
#     return await auth_service.restore(user_data,redis)

@router.post("/auth/register", status_code=status.HTTP_201_CREATED, tags=['Авторизация и пароли'])
async def registerme(user_data: UserRegister, lotus_key:str, auth_service: AuthService = Depends(AuthService), redis: Redis=Depends(get_redis_pool_gen)):
    """ Регистрация пользователя """

    return await auth_service.create(user_data,lotus_key, redis)

# @router.post("/auth/register/multiupload", status_code=status.HTTP_201_CREATED, tags=['Авторизация и пароли'])
# async def multiuploaduser(users:list[UserMultiUpload], auth_service: AuthService = Depends(AuthService)):
#     print("yo")
#     return await auth_service.multicreate(users)

@router.post('/auth/login', tags=['Авторизация и пароли'])
async def login(user_data: UserLogin, lotus_key:Union[str,None]=None, auth_service: AuthService =  Depends(AuthService), Authorize: AuthJWT = Depends(),redis: Redis=Depends(get_redis_pool_gen)):
    """ Вход на сайт и регистрация.\n
    lotus_key и email можно не отправлять, если пользователь уже заргистрирован. \n
    Если с карточки подтверждения пользовательского лотуса = поля становятся обязательными.
    
    """
    
    return await auth_service.auth(user_data, lotus_key, Authorize, redis)


@router.post('/auth/refresh', tags=['Авторизация и пароли'])
async def refresh(Authorize: AuthJWT = Depends(),):
    """ Обновление токена """    
    
    Authorize.jwt_refresh_token_required()    
    current_user = Authorize.get_jwt_subject()
    
    user= await User.objects.select_related(["otdel", "rank"]).filter(username=current_user).get()
    new_access_token = AuthService.create_access(Authorize, user)

    return {"access_token": new_access_token}

@router.get('/auth/logout', tags=['Авторизация и пароли'])
async def logout(Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()
    Authorize.unset_jwt_cookies()
    return {"msg":"Successfully logout"}

# # *User

@router.get("/user/{id_user}", tags=['Пользователь'])
async def get_user(id_user: int, username:str = Depends(AD.protect)):
    user = await REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',id_user,'getuser'))

    return user
    

@router.get("/users", tags=['Пользователь'])
async def get_users( username:str = Depends(AD.protect)):
    users = await User.objects.all()
    return [user.dict(exclude={"password", }) for user in users]

@router.delete("/user/del/{id_user}", tags=['Пользователь'])
async def del_user(id_user: int, username:str = Depends(AD.protect)):
    return await User.objects.delete(id=id_user)