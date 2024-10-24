import json
from orm.models import *
from services.wsservice import *
from orm.schema import *
from conf.sessions import get_redis_pool
from aioredis.client import PubSub, Redis
import asyncio
# cюда гену
class ChatFuncs:
   
    async def get_my_chatList(settings):
   
        chat = await Chat.objects.select_related(['users']).get(id=settings.id)
       
        chat = querytoPydantic(Chatschema, chat)
        mesg = await ChatMessage.objects.select_related(['sender']).filter(chat=settings.id).order_by("-id").limit(10).all()
        tenmes = []
        for x in mesg:
            tenmes.append(querytoPydantic(LastChatMessage, x))
        tenmes.reverse()
        chat['lastmessage']=tenmes
  
        return chat

    async def updatechatsnapshot(settings):
        redis= await get_redis_pool()
       
        message, users = await asyncio.gather(redis.hget(f"{settings.code}/{settings.id}", 'lastmessage'), redis.hget(f"{settings.code}/{settings.id}", 'users'))
   
        
       
      
        
        users=json.loads(users)
     
        for x in users:
            
            if x['id']!=settings.other['mes']['sender']['id']:
                unreaded = await redis.hget(f"data:user/{x['id']}", 'unreadedmessages')
                
               
                unreaded = json.loads(unreaded) if unreaded not in ["null",None] else []
                
                unreaded.append(settings.other['mes'])
               
                await redis.hset(f"data:user/{x['id']}", 'unreadedmessages',json.dumps(unreaded, indent=4, sort_keys=True, default=str))
        
        message = json.loads(message)
        message.append(settings.other['mes'])
        if len(message)>10:
            message.pop(0)
        await redis.close()
        return message
    
    async def leavechat(settings):
        redis= await get_redis_pool()
        users = await redis.hget(f"{settings.code}/{settings.id}", 'users')
        await redis.close()
        users = json.loads(users)
        
        users.pop(next((i for i, x in enumerate(users) if x["id"] == settings.other['user']['id']), None))
        
        return users
    
    async def addchat(settings):
        redis= await get_redis_pool()
        users = await redis.hget(f"{settings.code}/{settings.id}", 'users')
        await redis.close()
        users = json.loads(users)
        users.append(querytoPydantic(ChatUserschema, settings.other['user']))
        return users
    
    async def ireadIt(settings):
        redis= await get_redis_pool()
        print(f"{settings.code}/{settings.id}")
        old = await redis.hget(f"{settings.code}/{settings.id}", 'unreadedmessages')
        await redis.close()
        old= json.loads(old)
        i=0
        while i< len(old):
            if old[i]['chat']['id']== settings.other['chatroom']:
                old.pop(i)
            else:
                i+=1

        
        return old 

    async def updateunreaded(settings):
        redis= await get_redis_pool()
        try:
            msgs = await redis.hget(f"{settings.code}/{settings.id}", 'unreadedmessages')
            msgs = json.loads(msgs)
        except Exception:
            msgs=[]
        
        indx = next((i for i, x in enumerate(msgs) if x["id"] == settings.other['messid']), None)
        if indx is not None:
            msgs.pop()
        return msgs

    async def updatechatusers(settings):
        # print("dfsssssssddddddddddddddddddddddddddddd")      
        # print(settings.other['users'])
        # redis= await get_redis_pool()
        # msgs = await redis.hset(f"{settings.code}/{settings.id}", settings.other['key'], json.dumps(settings.other['users'], indent=4, sort_keys=True, default=str))

        return settings.other['users']