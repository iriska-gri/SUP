from fastapi import (
    APIRouter,
    WebSocket,
    Depends,
)
from aioredis.client import Redis

from services.depends import AD

from services.reestr import ReestrService
from orm.redis import RedisWorker
from orm.models import *
# from conf.log import logger
from orm.schema import *
from routes.reestr import ReestrProjectActs
from orm.schema import *
from routes.chats import *
from services.wsservice import *
from conf.sessions import get_redis_pool
router = APIRouter(    
    prefix='/supogramm',
    tags=['WS'],
)
# message.get('data')


@router.websocket("")
async def websocketwork(websocket: WebSocket, user=Depends(AD.protect_ws)):    
    
    class Actions:

        async def get_chat_project_persons(chat,user):
            # level = {1:Project, 2:Task,3:Work,4:Assignment}
            # print(chat)
            parentid=0
            if chat['level']==4:
                parentid= await Project.objects.get(project_task__task_work__work_assignment__id=chat['parent'])
                parentid=parentid.id
                # parent = await REdSetter.updateKeyReturnChecker(REdSetterSettings('work',chat['parent'],'work'))
            if chat['level']==3:
                parentid=await Project.objects.get(project_task__task_work__id=chat['parent'])
                parentid=parentid.id
            if chat['level']==2:
                parentid=await Project.objects.get(project_task__id=chat['parent'])
                parentid=parentid.id
            if chat['level']==1:
                parentid=chat['parent']
            
            proj = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',parentid,'project'))
            # print(proj)  
            allpersons = await asyncio.gather(*[REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',x['user']['id'],'getuser')) for x in proj['users']])
                        #    REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',proj['rp']['id'],'getuser')),
                        #    REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',proj['secretary']['id'],'getuser')),
                        #    REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',proj['coordinator']['id'],'getuser'))   ,
                        #    REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',proj['director']['id'],'getuser')) ) 
            # chat = await Chat.objects.get(id=data)
            print("chatpers")
            # print(allpersons)
            print("--------RETURN--------------")

            return {f"user:{user['id']}":json.dumps({"action": "chat_project_users","payload":allpersons}, indent=4, sort_keys=True, default=str)}
        
        
        async def get_chat_persons(chat,user):            
            persons = await Rs_Worker.redis_key_key_array_getter(RedisSettings(code=f"data:chatroom/{chat}",key="users"))           
            allpersons = await asyncio.gather(*[REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',x['id'],'getuser')) for x in persons])
            return {f"user:{user['id']}":json.dumps({"action": "chat_users","payload":allpersons}, indent=4, sort_keys=True, default=str)}
        # async def renew(data,user):
        #     payload = await get_my_chatList(user['id'])
        #     unreaded = await get_unreaded(user['id'])
        #     payload={'chatlist':chatlist, 'unreaded':unreaded}
         
        #     return {f"user:{user['id']}":json.dumps({"action": "build","payload":payload}, indent=4, sort_keys=True, default=str)}
        
        # async def readnotmychat(data,user):
        #     print(data)
        #     payload={}
        #     chat = await Chat.objects.get_or_none(parent = data['parent'], level=data['level'])
        #     if chat is not None:
        #         payload = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',chat.id,"mychatlist",{'func':'get_my_chatList'}))
           
        #     return {f"user:{user['id']}":json.dumps({"action": "notmychat","payload":payload}, indent=4, sort_keys=True, default=str)}


        async def updatechatusers(data,user):
            # print(data)
            changedusers = await updateusers(data, user)
            # f"user:{user['id']}":json.dumps({"mess": "Чат не создан, ошибка какая-то","payload":'renew'}, indent=4, sort_keys=True, default=str),
            # print(changedusers)
            # changedusers
            payload = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',data['id'],"mychatlist",{'func':'get_my_chatList'}),True)
            response={}
            for x in changedusers['added']:
                response[f"user:{x}"]=json.dumps({"action":  "renew","payload":payload}, indent=4, sort_keys=True, default=str)

            response[f"chat:{data['id']}"]=json.dumps({"action": "renew","payload":payload}, indent=4, sort_keys=True, default=str)
         
            return response

        async def makechat(data, user): 
            try:       
                r =await createchat(data, user)   
                
                response={}
                for x in data['users']:
                    response[f"user:{x}"]=json.dumps({"action": "renew","payload":r}, indent=4, sort_keys=True, default=str)   
                response[f"user:{user['id']}"]=json.dumps({"action": "renew","payload":r}, indent=4, sort_keys=True, default=str)                  
                return response
            except Exception:

                response={f"user:{user['id']}":json.dumps({"mess": "Чат не создан, ошибка какая-то","payload":'renew'}, indent=4, sort_keys=True, default=str)}
                return response


        async def sendmessage(data,user):
            payload = await sendtochat(data, user)
            
            

            return {f"user:{user['id']}":json.dumps({"mess": "message","payload":'payload'}, indent=4, sort_keys=True, default=str),
                    f"chat:{data['id']}":json.dumps({"action": "newmessageincome","payload":payload}, indent=4, sort_keys=True, default=str),
            }

        async def leavechat(data,user):
           
            await delchato(data,user)
            mes = f"{user['sn']} {user['givenName']} покинул(а) чат"
            return {f"user:{user['id']}":json.dumps({"mess": "message","payload":'payload'}, indent=4, sort_keys=True, default=str),
                    f"user:{user['id']}":json.dumps({"action": "renew","payload":'payload'}, indent=4, sort_keys=True, default=str),
                    f"chat:{data['id']}":json.dumps({"action": "systemmessage","payload":mes}, indent=4, sort_keys=True, default=str),
            }

        async def adduser(data,user):
            useradded = await addinguser(data,user)
            mes = f"{useradded.sn} {useradded.givenName} в чате"
            return {f"user:{user['id']}":json.dumps({"mess": "message","payload":'Новый пользователь добавлен в чат'}, indent=4, sort_keys=True, default=str),
                    f"user:{data['user']}":json.dumps({"action": "renew","payload":'payload'}, indent=4, sort_keys=True, default=str),
                    f"chat:{data['chat']}":json.dumps({"action": "systemmessage","payload":mes}, indent=4, sort_keys=True, default=str),
            }
        
        async def ireadIt(data, user):
            
            unreaded = await ireadedIt(data['chat'],user)
            
            return {f"user:{user['id']}":json.dumps({"action": "newunreaded","payload": unreaded}, indent=4, sort_keys=True, default=str)}

        async def getprevious(data, user):
            res = await getprev(data,user)        
            return {f"user:{user['id']}":json.dumps({"action": "takeprev","payload": {'res':res, 'chat':data['chat']}}, indent=4, sort_keys=True, default=str)}
            
        async def delmessage(data, user):
            await delmessager(data,user)
            return {f"user:{user['id']}":json.dumps({"mess": data,"payload":'payload'}, indent=4, sort_keys=True, default=str),
                    f"chat:{data['chat']}":json.dumps({"action": "messagedeleted","payload":data}, indent=4, sort_keys=True, default=str),
                    }
    if not user:
        return
    chatlist =await get_my_chatList(user['id'])
    unreaded = await get_unreaded(user['id'])
    payload={'chatlist':chatlist, 'unreaded':unreaded}
   
    save_info = {
        f"user:{user['id']}": {
           
            "give_info": ["list_chat"]
        }
    }
  
    channels = (f"user:{user['id']}",) + tuple([f"chat:{x['id']}" for x in payload['chatlist']])
    
    
    await websocket.send_text(dumper({"payload": payload, "action": "buildchat"}))
    async def consumer(data, conn: Redis):
        data = json.loads(data)              
        resp =  await getattr(Actions, data['action'])(data['payload'], user)    
        return resp    
        
    
    await RedisWorker.create_channels(websocket, consumer, channels=channels, save_info=save_info)

