import json

from fastapi import (
    APIRouter,
    WebSocket,
    Depends,
)
from aioredis.client import Redis

from services.depends import AD
import os
from services.reestr import ReestrService
from orm.redis import RedisWorker
from orm.models import *
# from conf.log import logger
from orm.schema import *
from services.rediskeyhelper.work.query import Workquery
from services.rediskeyhelper.task.query import Taskquery
from services.rediskeyhelper.project.query import Projectquery

from routes.project import *
from routes.tasks import *
from routes.works import *
from services.wsservice import *

router = APIRouter(    
    prefix='',
    tags=['WS'],
)

async def get_chatdata_chatchannel(id):
    payload,chatchannel={},()
    chat = await Chat.objects.get_or_none(level=2, parent=id)
    if chat is not None:
        chatchannel = (f'chat:{chat.id}',)
        payload= await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',chat.id,"mychatlist",{'func':'get_my_chatList'}))
    return [payload, chatchannel]





@router.websocket("/project/{projectid}/task/{id}")
async def websocketwork(projectid:int, id:int ,websocket: WebSocket, user=Depends(AD.protect_ws)):
    
    if not user:
        return
    
    payload = await get_task(projectid, id)
    payload['datachat'], chatchannel = await get_chatdata_chatchannel(id)
    
    save_info = {
        f"user:{user['id']}": {
            "channel": f"task:{id}",
            "give_info": ["list_task"]
        }
    }
   
    await websocket.send_text(json.dumps({"payload": payload, "action": "build"}, default=str))
    

    async def consumer(data, conn: Redis):
        
        data = json.loads(data)
        
        resp =  await getattr(Actions,data['action'])(data['payload'], user, projectid, id)
   

        
        return resp
    channels=  (f"user:{user['id']}", f"task:{id}",)+ chatchannel
    await RedisWorker.create_channels(websocket, consumer, channels=channels, save_info=save_info)



class Actions:
    # async def confirmation(data,user,projectid, id):
    #     print(data) 
    #     # work = await Work.objects.get(id=data['id'])
    #     # work.status=data['status']
    #     # work.comment.append(data['commentadd'])
    #     # await work.update()
    #     await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data["id"],'task_works'),True)
    #     # !Автообновление статуса работы (отправить на проверку)
       
    #     payload = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',data["id"],'project_tasks'),True)

    #     return {
    #         f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
    #         f"work:{data['id']}": dumper({"action": "rebuild","payload": 'payload'}),
    #         f"work:{id}": dumper({"action": "rebuild","payload": payload})
    #     }

    async def updatetask(data, user,projectid ,id): 
        
        data= exclude_keys(data,['works','parent'])
      
        await update_task_from_proj(data,user)

        res =  await get_task(projectid,id)
        return {
            f"user:{user['id']}": json.dumps({"mess": "Проект обновлен успешно"}, indent=4, sort_keys=True, default=str),
            f"task:{id}": json.dumps({"action": "rebuild","payload":res}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'res'}, indent=4, sort_keys=True, default=str)
        }
    async def editwork(data,user,projectid ,id):
        data= exclude_keys(data,['work_assignment','parent'])       
        await edit_work_from_project(data,projectid ,id,user)       
        # payload =  await get_task(projectid, id)
       
        return {
            f"user:{user['id']}": json.dumps({"mess": "Работа изменена успешно"}, indent=4, sort_keys=True, default=str),
            f"task:{id}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }
    async def delwork(data,user,projectid ,id):
        await del_work_from_project(data)
        await historyDataCreator(user, data, 3,3,projectid,id,data['id'])
        return {
            f"user:{user['id']}": json.dumps({"mess": "Работа удалена успешно"}, indent=4, sort_keys=True, default=str),
            f"task:{id}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def creatework(data,user,projectid ,taskid):       
        await create_work_from_project(data, projectid ,taskid, user)
        # payload = await get_task(projectid, id)
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',taskid,'project_tasks'),True)
        # ! возможно, потом переделать на частичное, а не полное обновление проекта
        return {
            f"user:{user['id']}": json.dumps({"mess": "Работа создана успешно"}, indent=4, sort_keys=True, default=str),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def delasygmnt(data,user,projectid ,id):
        await del_assignment_from_task(data,projectid ,id, user)
        # payload = await get_task(projectid,id)

        return {
            f"user:{user['id']}": json.dumps({"mess": "Поручение удалено успешно"}, indent=4, sort_keys=True, default=str),
            f"task:{id}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"work:{data['parent']['id']}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def editasygmnt(data,user,projectid ,id):
        await edit_assignment_from_task(data,projectid ,id, user)
        # payload =  await get_task(projectid,id)
       
        return {
            f"user:{user['id']}": json.dumps({"mess": "Поручение изменено успешно"}, indent=4, sort_keys=True, default=str),
            f"task:{id}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"work:{data['parent']['id']}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def createasygmnt(data,user,projectid ,taskid):
        await create_assignment_from_task(data,projectid ,taskid, user)
        # payload =  await get_task(projectid,id)

        return {
            f"user:{user['id']}": json.dumps({"mess": "Создано новое поручение"}, indent=4, sort_keys=True, default=str),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"work:{data['parent']}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def fileuploaded(data,user,projectid,id):  
            # !ОБновление данных на канале работы о загруженных файлах
        wf=await FileListGetter.files_in_task(id)       
        return {
            f"user:{user['id']}": dumper({"mess": "Загрузка завершена"}),
            f"task:{id}": dumper({"action": "filerenew","payload":wf}),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }
    
    async def deletefile(data,user,projectid,id):
        
        fp = Path(__file__).parent.parent.parent
        os.remove(fp.joinpath(data['filepath'][1:]))
        await Projectfile.objects.delete(id=data['id'])    
        await historyDataCreator(user,{"filedel": data['filepath'][1:]},1,6,projectid,id)
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',id,'project_tasks'),True)
        return {
            f"user:{user['id']}": dumper({"mess": "Файл удален"}),
            f"task:{id}": dumper({"action": "filedeleted","payload":{"id":data['id']}}),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    
    async def updateFile(data, user ,projectid,id): 
                    
            res = await Projectfile.objects.get(id=data['id'])
            
            
            await res.update(**data)
            await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',id,'project_tasks'),True)
            
            return {
                f"user:{user['id']}": dumper({"mess": "Доступ к файлу обновлен"}),
                f"task:{id}": dumper({"action": "fileupdated","payload":querytoPydantic(FileGetterUpdated,res)}),
                f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
            }

    async def rebuild(data,user,projectid,id):
        
        print("обновляю")    
        payload = await get_task(projectid, id)
        payload['datachat'], chatchannel = await get_chatdata_chatchannel(id)  
        
        channels=  ( f"task:{id}",)+ chatchannel
        val = dumper({"action": "build","payload":payload})
        resp = {}
        for x in channels:
            resp[x]= val        
        
        return resp

        
    async def confirmation(data,user,projectid,id):
       
        work = await Work.objects.get(id=data['id'])
        work.status=data['status']
        work.lastchanged = datetime.now()
        # w=work.status.select_related()
        
        # work.comment.append(data['commentadd'])
        await work.update()
        
        a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data["id"],'task_work'),True)
        a['comment']=data['commentadd'] if len(data['commentadd'])>0 else None
        await historyDataCreator(user, a, 3,4,projectid,id,data["id"])
        if len(data['comment_up'])>0:
            a['comment']=data['comment_up'] 
            await historyDataCreator(user, a, 3,7,projectid,id,data["id"])
        
       

        return {
            f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
            f"task:{id}": dumper({"action": "rebuild","payload": 'payload'}),
            f"work:{data['id']}": dumper({"action": "rebuild","payload": 'payload'}),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }
    async def taskstatus(data,user,projectid,id):
        base_corotunes,corotunes=[],[]
        

        returner = {
            f"user:{user['id']}":dumper({"mess": "Статус изменен"}),
            f"project:{projectid}":dumper({"action": "rebuild","payload": 'payload'})
        }
        base_corotunes.append(Taskquery.task_status_update(user,id,data['status']))
   

        await asyncio.gather(*base_corotunes)
        await asyncio.gather(*corotunes)  
        payload = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',id,'project_tasks'),True)  
        ob=payload
        ob['comment']=data['comment'] if 'comment' in data.keys() else None
        ob['ididit']=data['ididit'] if 'ididit' in data.keys() else None
        await historyDataCreator(user, ob, 2,data['h_action'],projectid,id)
        # returner[f"user:{user['id']}"]= dumper({"mess": "Статус изменен"})
        returner[f"task:{id}"]=dumper({"action": "rebuild","payload": payload})
        returner[f"project:{projectid}"]= json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        return returner