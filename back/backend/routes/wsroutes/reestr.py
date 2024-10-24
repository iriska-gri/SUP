import json

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

from routes.project import *
from services.wsservice import *

router = APIRouter(    
    prefix='',
    tags=['WS'],
)



@router.websocket("/reestr/{typen}")
async def reestr(websocket: WebSocket, typen:str, user=Depends(AD.protect_ws)):
    
    if not user:       
        return
    
    payload = await ReestrService.give_list_reestr(user['id'], typen, is_superuser=user["superuser"])    
    
    save_info = {
        f"user:{user['id']}": {
            "channel": f"reestr:{typen}",
            "give_info": [f"list_{typen}"]
        }
    }    
    await websocket.send_text(json.dumps({"payload": payload, "action": "build"}, default=str))


    async def consumer(data,conn: Redis):       
        data = json.loads(data)                          
        return await getattr(ReestrProjectActs, data["action"])(data,user,typen)           
             
            
        # if data["action"] == "tasks":
            
        #     tasks = await ReestrService.give_list_tasks(user_id, data["project_id"], user["superuser"])

        #     return {
        #         f"user:{user_id}": json.dumps({"action": "buildTasks", "tasks": tasks}, default=str)
        #     }
        
    await RedisWorker.create_channels(websocket, consumer=consumer, channels=(f"user:{user['id']}", "reestr:project"), save_info=save_info)


