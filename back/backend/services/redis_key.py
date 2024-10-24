
from conf.sessions import get_redis_pool
from aioredis.client import PubSub, Redis
from services.rediskeyhelper.chat import ChatFuncs
from services.rediskeyhelper.project.query import Projectquery as PQ
from services.rediskeyhelper.users.query import Userquery as UQ
from services.rediskeyhelper.task.query import Taskquery as TQ
from services.rediskeyhelper.work.query import Workquery as WQ
from services.rediskeyhelper.assignment.query import AssignmentQuery as AQ
from services.wsservice import *
from services.project.depends import *
from services.base import QueryHelper as QH
import asyncio
from asyncio import tasks, gather
from orm.models import *

class REdSetterSettings:
    def __init__(self, code, id, function, other=None) -> None:
        self.code = code
        self.id=id
        self.function=function
        self.other=other

async def ProjectTaskFieldsQuery(id):
    tsks = await Task.objects.select_related(['status','task_work','task_work__status']).filter(parent=id).all()
    task=[]
    for t in  tsks: 
        task.append(querytoPydantic(Task4ProjectGet, t))        
    return task 



class REdSetter(object):
    @classmethod
    async def key_del(cls,key):
        redis = await get_redis_pool()
        await redis.delete(key)
        await redis.close()
    
    
    @classmethod
    async def arr_key_del(cls,key,arrids):

        """
        Удаление массива ключей из REDIS

        """
        redis = await get_redis_pool()
        
        # await table.objects.filter(id__in=arrids).delete()
        a = [redis.delete(f"{key}{x}") for x in arrids]
        await gather(*a)
        await redis.close()


    @classmethod
    def encodeJson(self,dct):
        for [key,val] in dct.items():                
                dct[key]=json.dumps(val, indent=4, sort_keys=True, default=str)        
        return dct
    @classmethod
    def decodeJson(self,dct):
        for [key,val] in dct.items():                
                dct[key]=json.loads(val)        
        return dct
   
  
    
    
    @classmethod
    async def updateKeyReturnChecker(cls,settings,upd=False):
        """Возвращает ключ редис или обновляет его  в БД и возвращает

        Args:
            settings = Объект с настроечками
            upd (bool, optional): принудительное обновление. Defaults to False.

        Returns:
            _type_: json Запроса
        """      
        self=REdSetter()
        self.redis= await get_redis_pool()
        
        
        a = await self.redis.hgetall(f"{settings.code}/{settings.id}")
        
        if  a is None or len(a)==0 or upd:          
            a= await getattr(self,settings.function)(settings)              
            await  self.redis.hset(f"{settings.code}/{settings.id}",mapping= self.encodeJson(a))
            a = await self.redis.hgetall(f"{settings.code}/{settings.id}")
        await self.redis.close()
        return self.decodeJson(a)

    
    @classmethod
    async def project(self,settings):  
        """получить голый проект"""           
        nudeproj = await PQ.ProjectBaseFieldsQuery(settings.id)         
        return nudeproj
    
    
    @classmethod
    async def getuser(self,settings):  
        """забрать пользователя"""                    
        return await UQ.getuser(settings.id)
    
    async def project_tasks(self,settings):
        """Задача проекта"""
        return await TQ.project_tasks(settings.id)
    
    async def task_work(self,settings):
        """работа"""       
        return await WQ.task_work(settings.id) 
    



    
    @classmethod
    async def work_assignment(self, settings):
        """поручения в работе"""
        return await AQ.assignment(settings.id)
    
    @classmethod
    async def projectMainFieldsUpdater(self, settings):
        return await PQ.ProjectBaseFieldsQuery(settings.id) 
    
    
    
    @classmethod
    async def projectTasksBase(self, settings):
        return {'project_task':await ProjectTaskFieldsQuery(settings.id) }


    



# работа

    # @classmethod
    # async def work(self,settings):
    #     """карточка работы"""
    #     return await WQ.work(settings.id)
        




    @classmethod
    async def updateOneKeyReturnChecker(cls,settings,upd=False):
        """Возвращает ключ редис или обновляет его  в БД и возвращает

        Args:
            settings = Объект с настроечками
            upd (bool, optional): принудительное обновление. Defaults to False.

        Returns:
            _type_: json Запроса
        """      
        self=REdSetter()
        self.redis= await get_redis_pool()
        
        a = await self.redis.hget(f"{settings.code}/{settings.id}", settings.other['key'])
        
        if a is None or len(a)==0 or upd:          
            a= await getattr(self,settings.function)(settings)              
            await  self.redis.hset(f"{settings.code}/{settings.id}", settings.other['key'],  json.dumps(a, indent=4, sort_keys=True, default=str))
            a = await self.redis.hget(f"{settings.code}/{settings.id}", settings.other['key'])
        await self.redis.close()
        return json.loads(a)

    
    @classmethod
    async def mychatlist(self,settings):
       
        a= await getattr(ChatFuncs, settings.other['func'])(settings)       
        return  a
        



class RedisSettings:
    def __init__(self, code, data=None, key=None) -> None:
        self.code = code   
        self.data=data
        self.key=key





class Rs_Worker(object):
    @classmethod
    async def key_del(cls,key):
        redis = await get_redis_pool()
        await redis.delete(key)
        await redis.close()
    @classmethod
    def encodeJson(self,dct):
        for [key,val] in dct.items():                
                dct[key]=json.dumps(val, indent=4, sort_keys=True, default=str)        
        return dct
    @classmethod
    def decodeJson(self,dct):
        for [key,val] in dct.items():                
                dct[key]=json.loads(val)        
        return dct
    @classmethod
    
    
    async def redis_key_setter(cls,settings):
        """Возаращает данные ключа редис или обновляет его и возвращает

        Args:
            settings (_type_): Объект с настроечками (в том числе данные)
          

        Returns:
             _type_: json Запроса
             
        """
        self=Rs_Worker()
        self.redis= await get_redis_pool()                                        
        await  self.redis.hset(settings.code, mapping= self.encodeJson(settings.data))
        a = await self.redis.hgetall(settings.code)
        await self.redis.close()
        return self.decodeJson(a)
    
    
    @classmethod
    async def redis_key_key_setter(cls, settings):
        """ обновляет ключ ключа  и возвращает

        Args:
            settings (_type_): Объект с настроечками (в том числе данные)
          

        Returns:
             _type_: json Запроса
             
        """
        self=Rs_Worker()
        self.redis= await get_redis_pool()                                        
        await  self.redis.hset(settings.code, settings.key, json.dumps(settings.data, indent=4, sort_keys=True, default=str))
        a = await self.redis.hgetall(settings.code)
        await self.redis.close()
        return self.decodeJson(a)

    @classmethod
    async def redis_key_key_array_getter(cls, settings):
        """ обновляет ключ ключа  и возвращает

        Args:
            settings (_type_): Объект с настроечками (в том числе данные)
          

        Returns:
             _type_: json Запроса
             
        """
        self=Rs_Worker()
        self.redis= await get_redis_pool()                                   
        a = await self.redis.hget(settings.code, settings.key)
        
        await self.redis.close()
        return json.loads(a)
