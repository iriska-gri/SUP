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
# message.get('data')


@router.websocket("/")
async def websocketwork(websocket: WebSocket, user=Depends(AD.protect_ws)):    
    if not user:
        return
    async def consumer(message):
        return {
            f"user:{user['id']}": message,
            "main": "hello"
        }        
    await RedisWorker.create_channels(websocket, consumer, channels=(f"user:{user['id']}", "main"))


