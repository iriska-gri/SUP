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
import ormar
import json
from routes.project import *
from routes.tasks import *
from routes.works import *
from services.wsservice import *
import os
from services.rediskeyhelper.assignment.query import AssignmentQuery
from services.rediskeyhelper.work.query import Workquery
from services.rediskeyhelper.task.query import Taskquery
from services.rediskeyhelper.project.query import Projectquery
router = APIRouter(    
    prefix='',
    tags=['WS'],
)

async def get_chatdata_chatchannel(dataassignm, id):
   
    asgnments = [x['id'] for x in dataassignm]
    
    chats = await Chat.objects.filter(ormar.or_(ormar.and_(level =4, parent__in=asgnments),ormar.and_(level=3, parent=id))).fields(['id']).all()
    
    datachat = [REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',x.id,"mychatlist",{'func':'get_my_chatList'}))   for x in chats]
    
    payload= await asyncio.gather(*datachat)
    chatchannel = tuple([f'chat:{x.id}' for x in chats]) 
  
    return [payload, chatchannel]


@router.websocket("/project/{projectid}/task/{taskid}/work/{id}")
async def websocketwork(id:int ,projectid:int ,taskid:int, websocket: WebSocket, user=Depends(AD.protect_ws)):
    
    if not user:
        return
    
    payload = await get_work(projectid,taskid,id)   
    
    payload['datachat'], chatchannel = await get_chatdata_chatchannel(payload['work']["work_assignment"], id) 
    channels=(f"user:{user['id']}", f"work:{id}",) + chatchannel
    
    save_info = {
        f"user:{user['id']}": {
            "channel": f"work:{id}",
            "give_info": ["list_project"]
        }
    }
   
    await websocket.send_text(json.dumps({"payload": payload, "action": "build"}, default=str))
    

    async def consumer(data, conn: Redis):
        
        data = json.loads(data)
        print(data['action'])
        resp =  await getattr(Actions,data['action'])(data['payload'], user, projectid,taskid,id)
   

        
        return resp
        
    await RedisWorker.create_channels(websocket, consumer, channels=channels, save_info=save_info)


class Actions:
    async def rebuild(data,user,projectid,taskid,id):
        print(id)
        print("обновляю")          
        payload = await get_work(projectid,taskid,id)   
        payload['datachat'], chatchannel = await get_chatdata_chatchannel(payload['work']["work_assignment"], id) 
        channels=(f"user:{user['id']}", f"work:{id}",) + chatchannel
        val = dumper({"action": "build","payload":payload})
        resp = {}
        for x in channels:
            resp[x]= val
        
        
        return resp

    async def updateFile(data, user ,projectid,taskid,id): 
        print("updateFile")     
        res = await Projectfile.objects.get(id=data['id'])
        
        
        await res.update(**data)
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',id,'task_work'),True)
        
        return {
            f"user:{user['id']}": dumper({"mess": "Доступ к файлу обновлен"}),
            f"work:{id}": dumper({"action": "fileupdated","payload":querytoPydantic(FileGetterUpdated,res)}),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def deletefile(data,user,projectid,taskid,id):
        print("deletefile")
        print(data)
        fp = Path(__file__).parent.parent.parent
        os.remove(fp.joinpath(data['filepath'][1:]))
        await Projectfile.objects.delete(id=data['id'])    
        await historyDataCreator(user,{"filedel": data['filepath'][1:]},4,6,projectid,taskid,id)
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',id,'task_work'),True)
        return {
            f"user:{user['id']}": dumper({"mess": "Файл удален"}),
            f"work:{id}": dumper({"action": "filedeleted","payload":{"id":data['id']}}),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)

        }

    async def fileuploaded(data,user,projectid,taskid,id):  
            # !ОБновление данных на канале работы о загруженных файлах
       
        wf=await FileListGetter.files_in_work(id)       
        return {
            f"user:{user['id']}": dumper({"mess": "Загрузка завершена"}),
            f"work:{id}": dumper({"action": "filerenew","payload":wf}),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
            f"project:{projectid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }

    async def assignmentstatus(data,user,projectid,taskid,id):
        print("assignmentstatus----------")
        base_corotunes,corotunes=[],[]        
        payload={'bigbuild':False}        
        base_corotunes.append(AssignmentQuery.assignment_status_update(data['id'], data['status']))
        

        # if data['work_status_update']:                        
        #     base_corotunes.append(Workquery.work_status_update(user, id,2))
        #     corotunes.append(REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',id,'task_work'),True))            
        #     payload['bigbuild']=True
          
        #     if data['task_status_update']:              
        #         base_corotunes.append(Taskquery.task_status_update(taskid,2))
        #         corotunes.append(REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',taskid,'project_tasks'),True))
                
        #         if data['project_status_update']:                    
        #             base_corotunes.append(Projectquery.project_status_update(projectid,4))
        #             corotunes.append(REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',projectid,'project'),True))


        await asyncio.gather(*base_corotunes)
        # await asyncio.gather(*corotunes)
        
        payload['assignment']=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',data["id"],'work_assignment'),True)
        ob=payload['assignment']        
        ob['comment']=data['comment'] if 'comment' in data.keys() else None
        ob['ididit']=data['ididit'] if 'ididit' in data.keys() else None
        await historyDataCreator(user, ob, 4,data['h_action'],projectid,taskid,id,data['id'])
        return {
            f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
            f"work:{id}": dumper({"action": "assupdate","payload": payload}),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
           
            }



    async def workstatus(data,user,projectid,taskid,id):
        base_corotunes,corotunes=[],[]
        print('workstatus--------------')
       
        returner = {
            f"user:{user['id']}":dumper({"mess": "Статус изменен"}),
            f"task:{taskid}":dumper({"action": "rebuild","payload": 'payload'})
        }
        base_corotunes.append(Workquery.work_status_update(user,id,data['status']))
        # returner[f"task:{taskid}"]= dumper({"action": "rebuild","payload": 'payload'})
        # if data['task_status_update']:
        # if True:             
            # base_corotunes.append(Taskquery.task_status_update(taskid,2))
        corotunes.append(REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',taskid,'project_tasks'),True))
            # 
            # if data['project_status_update']:  
                # !Отправить returner на обновление проекта                  
                    # base_corotunes.append(Projectquery.project_status_update(projectid,4))
        corotunes.append(REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',projectid,'project'),True))

        await asyncio.gather(*base_corotunes)
        await asyncio.gather(*corotunes) 
        
       
        
        payload = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',id,'task_work'),True)  
        ob=payload
        ob['comment']=data['comment'] if 'comment' in data.keys() else None
        ob['ididit']=data['ididit'] if 'ididit' in data.keys() else None
        await historyDataCreator(user, ob, 4,data['h_action'],projectid,taskid,id)
      
        # await historyDataCreator(user, payload, 3,7,projectid,taskid,id)
        # returner[f"user:{user['id']}"]= dumper({"mess": "Статус изменен"})
        returner[f"work:{id}"]=dumper({"action": "rebuild","payload": 'payload'})
        returner[f"task:{taskid}"]= json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        returner[f"project:{projectid}"]= json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        return returner

        
    async def confirmation(data,user,projectid,taskid,id):
        
        assgmnt = await Assignment.objects.get(id=data['id'])
        assgmnt.status=data['status']
        assgmnt.lastchanged = datetime.now()
        # assgmnt.comment.append(data['commentadd'])
        await assgmnt.update()
        a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',data["id"],'work_assignment'),True)
        a['comment']=data['commentadd'] if len(data['commentadd'])>0 else None

        await historyDataCreator(user, a, 4,4,projectid,taskid,id,data['id'])
        if len(data['comment_up'])>0:
            a['comment']=data['comment_up'] 
            await historyDataCreator(user, a, 4,7,projectid,taskid,id,data['id'])
        # !Автообновление статуса работы (отправить на проверку)
        # if data['work_status_update']['res']:           
        #     await changeWorkStatus(assgmnt.parent.id, 4,data['work_status_update']['project'])
       

        return {
            f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
            f"work:{id}": dumper({"action": "rebuild","payload": 'payload'}),
            f"task:{taskid}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
          
        }
    
    async def createasygmnt(data,user,projectid,taskid,id):
        
        nassgmnt = await Assignment.objects.create(**foreignkeytoint(data,['responsible']), status=1,author=user['id'])
        
        # await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',nassgmnt.id,'work_assignment'),True)       
        # await Rs_Worker.redis_key_key_setter(RedisSettings(f'data:work/{data["parent"]}', data= await AssignmentQuery.assignments_in_work(id),key="work_assignment"))
        a,b=await asyncio.gather(
            REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',nassgmnt.id,'work_assignment'),True),
            Rs_Worker.redis_key_key_setter(RedisSettings(f'data:work/{data["parent"]}', data= await AssignmentQuery.assignments_in_work(id),key="work_assignment"))
        )

        
        await historyDataCreator(user,a,4,1,projectid,taskid,id,nassgmnt.id)
        return {
            f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
            f"work:{id}": dumper({"action": "rebuild","payload": 'payload'}),
            f"task:{taskid}": dumper({"action": "rebuild","payload": 'payload'})
        }

    async def delasygmnt(data,user,projectid,taskid,id):
        print(data,"!/////////////////////////////////////")
        a =await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',data["id"],'work_assignment'))   
        await historyDataCreator(user,{"name":a['name']},4,3,projectid,taskid,id,data["id"])
        await asyncio.gather(Assignment.objects.delete(id=data['id']), REdSetter.key_del(f'data:assignment/{data["id"]}'))

        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',id,'task_work'),True)   
        cht = await Chat.objects.get_or_none(parent=data['id'], level=4)
        
        response = { f"user:{user['id']}": dumper({"mess": "Поручение удалено"}),
            f"work:{id}": dumper({"action": "rebuild","payload": 'payload'}),
            f"task:{taskid}": dumper({"action": "rebuild","payload": 'payload'})
        }
        if cht is not None:
            await REdSetter.key_del(f'data:chatroom/{cht.id}')
            await ChatMessage.objects.delete(chat=cht.id, each=True)
            
            
            response[f"chat:{cht.id}"] = json.dumps({"action": "renew","payload":'payload'}, indent=4, sort_keys=True, default=str)
            await cht.delete()
        return response


    async def editasygmnt(data,user,projectid,taskid,id):
        
        data = foreignkeytoint(data,['responsible','author','status'])   
        print("-------------------")
        print(data)
        print("../////////////////...........")
        ass = await Assignment.objects.get(id = data['id'])
        await ass.update(**data)
    
        a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',data["id"],'work_assignment'),True)
        
        await historyDataCreator(user,a,4,2,projectid,taskid,id,data["id"])
        # !Кидает на полное обновление, что нам не надо. Переделать на частичное (отправлять результат выше и обработать на фронте)
        return {
            f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
            f"work:{id}": dumper({"action": "rebuild","payload": 'payload'}),
            f"task:{taskid}": dumper({"action": "rebuild","payload": 'payload'})
        }

    # async def workstatusconfirm(data,user, projectid,taskid,id):
    #     print(data)
    #     newval = await changeWorkStatus(id, data['status'])
    #     # print(newval)
    #     # await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',id,'work_assignment'),True)
    #     await Rs_Worker.redis_key_key_setter(RedisSettings(f'data:work/{id}', data= await Workquery.getstatus(data['status']),key="status"))
      
    #     return {
    #         f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
    #         f"work:{id}": dumper({"action": "rebuild","payload": 'payload'})
    #     }







