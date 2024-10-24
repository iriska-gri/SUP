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
import os
from services.redis_key import *
from routes.project import *
from routes.tasks import *
from routes.works import *
from services.wsservice import *
from services.project.depends import PD

router = APIRouter(    
    prefix='',
    tags=['WS'],
)
# message.get('data')
async def get_chatdata_chatchannel(id):
    payload,chatchannel={},()
    chat = await Chat.objects.get_or_none(level=1, parent=id)
    if chat is not None:
        chatchannel = (f'chat:{chat.id}',)
        payload= await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',chat.id,"mychatlist",{'func':'get_my_chatList'}))
    return [payload, chatchannel]


@router.websocket("/project/{id}")
async def websocketwork(id:int ,websocket: WebSocket, user=Depends(AD.protect_ws)):
    
    if not user:
        return
    
    payload = await get_project(id)
    # print(payload)
    payload['datachat'], chatchannel = await get_chatdata_chatchannel(id)
    
    save_info = {
        f"user:{user['id']}": {
            "channel": f"project:{id}",
            "give_info": ["list_project"]
        }
    }
   
    await websocket.send_text(dumper({"payload": payload, "action": "build"}))
    

    async def consumer(data, conn: Redis):
        
        data = json.loads(data)
        
            # dictfunc[key]= noteupdate(val)
            # a= getattr(self, f"Content{met}")(self,data, req)   
                 
        resp =  await getattr(Actions,data['action'])(data['payload'], user, id)
                # if id == 0:
            
        #     data = json.loads(data)
        #     newpr = ProjectCreate(**data).dict(exclude={'users','id'})
        #     newpr["lastchanged"] = datetime.now()
        #     list_channels ={"reestr:projects", f"project:{id}"}
        #     list_given = {"list_project"}

        #     pr = await Project.objects.create(**newpr)
        #     for usert in data["users"]:  
        #         await pr.users.add(User(id = usert["id"], __pk_only__ = True))

        #     message_data = {
        #         "list_project": {"payload": pr.dict()},
        #         "dsafsdf": {"msg2": "notok"}
        #     }

        #     result = {}

        #     users_send = {*set(map(lambda x: x["id"], data["users"])), data["rp"]["id"], data["author"]["id"]}
          
        #     for usersend in users_send:
               
        #         info_send_user = await conn.get(f"user:{usersend}")   
        #         # print(await conn.pubsub_channels(pattern='*')  )             
        #         if not info_send_user:
        #             continue

        #         info_send_user = json.loads(info_send_user)
        #         if info_send_user["channel"] not in list_channels:
        #             continue

        #         list_info = list_given.intersection(info_send_user["give_info"])
                
        #         send_data={"action": "update"}
        #         for info in list_info:
        #             send_data.update(message_data[info])
                    
        #         result[f"user:{usersend}"] = dumper(send_data, default=str)
            
        #     return result

        # newpr["lastchanged"] = datetime.now()
        # pr = await Project.objects.create(**newpr)
        # for user in data.users:  
        #     await pr.users.add(User(id = user.id, __pk_only__ = True))
    

        
        return resp
    channels=  (f"user:{user['id']}", f"project:{id}",)+ chatchannel      
    await RedisWorker.create_channels(websocket, consumer, channels=channels, save_info=save_info)
  
class Actions:
    async def rebuild(data,user,id):        
        print("обновляю")    
        payload = await get_project(id)
        payload['datachat'], chatchannel = await get_chatdata_chatchannel(id)          
        channels=  ( f"project:{id}",) + chatchannel
        val = dumper({"action": "build","payload":payload})
        resp = {}
        for x in channels:
            resp[x]= val      
        return resp






        
    async def confirmation(data,user,id):
       
        task = await Task.objects.get(id=data['id'])
        task.status=data['status']    
        task.lastchanged = datetime.now()    
        await  task.update()
        a= await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',data["id"],'project_tasks'),True)        
        a['comment']=data['commentadd'] if len(data['commentadd'])>0 else None
        await historyDataCreator(user, a, 2,4,id,data["id"])
        if len(data['comment_up'])>0:
            a['comment']=data['comment_up'] 
            await historyDataCreator(user, a, 2,7,id,data['id'])
        rating = await UserRating.objects.create(author=user['id'],user=task.responsible.id, rating=data['r_rating'],level=2,project=id, task=data['id'])
        # !Автообновление статуса работы (отправить на проверку)
        
       

        return {
            f"user:{user['id']}": dumper({"mess": "Статус изменен"}),
            f"project:{id}": dumper({"action": "rebuild","payload": 'payload'}),
            f"task:{data['id']}": dumper({"action": "rebuild","payload": 'payload'}),
        }
    



    async def update(data, user ,id): 
        res = await update_project(data, user)
        pl = await get_project(id)
        return {
            f"user:{user['id']}": dumper({"mess": "Проект обновлен успешно"}),
            f"project:{id}": dumper({"action": "build","payload":pl})
        }
    
    
    async def addTask(data,user,id):
        data['parent']=id
        await create_task(data, user)    
            
        payload =  await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',id,"projectTasksBase"),True)
        
        payload = await get_project(id)
        print(payload)
        # ! возможно, потом переделать на частичное, а не полное обновление проекта
        return {
            f"user:{user['id']}": dumper({"mess": "Задача создана успешно"}),
            f"project:{id}": dumper({"action": "build","payload":payload})
        }
    async def deltask(data,user,id):
        await del_task_from_proj(data,user)

        payload =   await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',id,"projectTasksBase"),True)
        return {
            f"user:{user['id']}": dumper({"mess": "Задача удалена успешно"}),
            f"project:{id}": dumper({"action": "build","payload":payload})
        }
    
    async def creatework(data,user,projectid):      
        
        await create_work_from_project(data, projectid, data['parent'],user)
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',projectid,"projectTasksBase"),True)
        # ! возможно, потом переделать на частичное, а не полное обновление проекта
        return {
            f"user:{user['id']}": dumper({"mess": "Работа создана успешно"}),
            f"project:{projectid}": dumper({"action": "rebuild","payload":"payload"}),
            f"task:{data['parent']}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str),
           
        }
    async def editwork(data,user,projectid):
        # print(data)
        await edit_work_from_project(data,projectid, data['parent']['id'],user)

        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',projectid,"projectTasksBase"),True)
       
        return {
            f"user:{user['id']}": dumper({"mess": "Работа изменена успешно"}),
            f"project:{projectid}": dumper({"action": "rebuild","payload":"payload"}),
            f"task:{data['parent']['id']}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }



    async def delwork(data,user,id):
        # print(data)
        await del_work_from_project(data)
        await historyDataCreator(user, data, 3,3,id,data['parent']['id'],data['id'])
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',id,"projectTasksBase"),True)
        
        return {
            f"user:{user['id']}": dumper({"mess": "Работа удалена успешно"}),
            f"project:{id}": dumper({"action": "rebuild","payload":'payload'}),
            f"task:{data['parent']['id']}": json.dumps({"action": "rebuild","payload":'payload'}, indent=4, sort_keys=True, default=str)
        }





    async def updatetask(data,user,id):
        
        await update_task_from_proj(data,user)
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',id,"projectTasksBase"),True)
         # ! возможно, потом переделать на частичное, а не полное обновление проекта
        return {
            f"user:{user['id']}": dumper({"mess": "Задача обновлена успешно"}),
            f"project:{id}": dumper({"action": "rebuild","payload":'payload'})
        }


    # async def sendchat(data, user, id):
      
    #     newchatmessage ={'sender': user['id'], 'parent':id, 'message':data, 'datetime':datetime.now()}
    #     res = await ProjectChat.objects.create(**newchatmessage)      
       
    #     sendback={'id':res.id,
    #               'datetime':res.datetime,
    #               'sender': {"id": user['id'], 'fullname': f"{user['sn']} {user['givenName']}"},
    #               'message':res.message,
    #               'parent':res.parent
    #               }
    #     await ProjectHistory.objects.create(**{"project":res.parent, "action": 1, "author": user['id'], "level":1,"text":f"{user['sn']} {user['givenName']} оставил комментарий" })
    #     return {
    #         f"project:{id}": dumper({"action": "newChatMessage","payload":sendback})
    #     }    
        
    # async def delmessage(data, user, id):        
    #     await ProjectChat.objects.delete(id=data['id'])
    #     await ProjectHistory.objects.create(**{"project":data['parent'], "author": user['id'], "action": 3, "level":1,"text":f"{user['sn']} {user['givenName']} удалил комментарий" })
    #     return {
    #         f"user:{user['id']}": dumper({"mess": "Сообщение удалено"}),
    #         f"project:{id}": dumper({"action": "deletedMessage","payload":data['id']})
    #     }  
    async def fileuploaded(data,user,id):  
            # !ОБновление данных на канале работы о загруженных файлах
        wf=await FileListGetter.files_in_project(id)       
        return {
            f"user:{user['id']}": dumper({"mess": "Загрузка завершена"}),
            f"project:{id}": dumper({"action": "filerenew","payload":wf})
        }
    
    async def deletefile(data,user,id):
        
        fp = Path(__file__).parent.parent.parent
        os.remove(fp.joinpath(data['filepath'][1:]))
        await Projectfile.objects.delete(id=data['id'])    
        
        await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',id,'project'),True)
        return {
            f"user:{user['id']}": dumper({"mess": "Файл удален"}),
            f"project:{id}": dumper({"action": "filedeleted","payload":{"id":data['id']}})
        }

    
    async def updateFile(data, user ,id): 
                    
            res = await Projectfile.objects.get(id=data['id'])
            
            
            await res.update(**data)
            await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',id,'project'),True)
            
            return {
                f"user:{user['id']}": dumper({"mess": "Доступ к файлу обновлен"}),
                f"project:{id}": dumper({"action": "fileupdated","payload":querytoPydantic(FileGetterUpdated,res)})
            }  


        
    async def getprojectdocks(data,user,id):        
        docs = await Documentation.objects.filter(project=id).select_related(["doctype","doc_user","doc_user__user__position","doc_user__user","approver","approver__position"]).order_by(["doctype","-created"]).fields(["id","doctype","doc_user","created","approved","approver","approvedtime","docnumber","path"]).all()
        res, users=[],[]
        for el in docs:
            users=[]
            for x in el.doc_user:
                
                dt = querytoPydantic(UserProjectFullName,x.user)
                dt['accepted']=x.accepted
                users.append(dt)
            

            resic = querytoPydantic(AllProjectDocumentation,el)
            resic['accepters']=users
            res.append(resic)

        return {
            f"user:{user['id']}": dumper({"action":"buildDocspage","payload": res}),
          
        } 
    async def project__clonedock(data,user,id):
        doc= await Documentation.objects.create( project=id,doctype= await DocType.objects.get(name=data['doctype__name']), vrersion=data['version'],approved=0, approver=data['approver'],created = datetime.now())
           
        for x in data['accepters']:
            # print(x['id'])
            await DocUser.objects.create(doc=doc.id,user=x['id'])
            # u = await User.objects.get(id=x['id'])
            # await doc.accepters.add(u, accepted=0)
                # await   DocUser.objects.create(user=x['id'],)  
        res = await PD.get_doclist(id) 
           
        

       


        return { 
            f"user:{user['id']}": dumper({"action":"opendoc","payload": doc.id}),
            f"project:{id}": dumper({"action":"buildDocspage","payload": res}),
        }

    async def approver_update(data,user,id):        
        upd = await Documentation.objects.get(id=data['id'])
        upd.approved = data['approved']
        
        print(upd.doctype.id, data['approved'], date.today().strftime('%Y-%m-%d'))
        print("!______________________________________!")
        if upd.doctype.id==5 and data['approved']==3:
                data['version']['orderdate'] = date.today().strftime('%Y-%m-%d')
        upd.comment = data['comment']
        upd.vrersion=data['version']
        upd.approvedtime = datetime.now()
        await upd.update()
        res = await PD.get_doclist(id)    
        
       
        return {
            # f"user:{user['id']}": dumper({"action":"buildDocspage","payload": res}),
            f"project:{id}": dumper({"action":"buildDocspage","payload": res})
        }  

    async def acceptor_update(data,user,id):
        upd = await DocUser.objects.get(user=user['id'], doc=data['id'])
        
        upd.accepted=data['accepters']['accepted']
        upd.comment = data['accepters']['comment']
        upd.acceptedtime = datetime.now()
        await upd.update()
        res = await PD.get_doclist(id)  
        return {           
            f"project:{id}": dumper({"action":"buildDocspage","payload": res})
        }  
    
    
    async def doc_deleter(data, user,id):   
        
        if data['path'] is not None and len(data['path'])>0:
            
        
            fp = Path(__file__).parent.parent.parent
            os.remove(fp.joinpath(data['path'][1:]))
        await Documentation.objects.delete(id=data['id'])
        res = await PD.get_doclist(id)  
        return {  
                f"user:{user['id']}": dumper({"action":"closeDocdialog","payload": 'close'}),         
                f"project:{id}": dumper({"action":"buildDocspage","payload": res})
            } 
    
    

    async def project_savedock(data,user,id):
        print(data)
        result ={}
        doc=""
        oldaccepters, currwntaccepters=[],[]
        if 'id' in data.keys():
            print("UPDATE")
            doc = await Documentation.objects.select_related('doc_user').get(id=data['id'])
            if(len(data['version'])>0 and ('docnumber' in data['version']) and len(data['version']['docnumber'])>0):
                doc.docnumber=data['version']['docnumber']
            else:
                doc.docnumber=None           
            
            doc.vrersion=data['version']
            doc.approved=data['approved']
            doc.approver=data['approver']

            await doc.update()
            
            
            for us in doc.doc_user:
                oldaccepters.append(us.user.id)
                
            oldaccepters=set(oldaccepters)
            
            for u in data['accepters']:
                currwntaccepters.append(u['id'])
            currwntaccepters= set(currwntaccepters)

            oldlist = list(oldaccepters.difference(currwntaccepters))
            if len(oldlist)>0:
                remove = await DocUser.objects.get(user__in=oldlist, doc=doc.id)
                await remove.delete()
            # for userid in oldaccepters.difference(currwntaccepters):
                # u = await User.objects.get(id=userid)  
                # await doc.accepters.remove(u)
                # await DocUser.objects.get(documentation = doc.id, user=u.id)
            
            for userid in currwntaccepters.difference(oldaccepters):
                # u = await User.objects.get(id=userid)
                await DocUser.objects.create(user=userid, doc=doc.id)
              
                # addata = next(x for x in data['accepters'] if x['id']==u.id)
                # await doc.accepters.add(u, accepted= addata['accepted'])


            if data['actiontype']=="toaccept":
                for userid in currwntaccepters.intersection(oldaccepters):
                    # u = await User.objects.get(id=userid)
                
                    up = await DocUser.objects.get(user=userid, doc=doc.id)
                    up.accepted=1
                    await up.update()
            
            





        else:
            print("_________________________________________")
            print(data)
            docnumbered=None
            if('docnumber' in data['version'].keys() and data['version']['docnumber'] and len(data['version']['docnumber'])>0):
                docnumbered=data['version']['docnumber']
            
            
            doc= await Documentation.objects.create( project=id,doctype= await DocType.objects.get(name=data['doctype__name']), vrersion=data['version'],approved=data['approved'],docnumber=docnumbered, approver=data['approver'],created = datetime.now())
            
            for x in data['accepters']:
             
                # u = await User.objects.get(id=x['id'])
                # await doc.accepters.add(u, accepted=x['accepted'])
                await   DocUser.objects.create(user=x['id'], doc=doc.id)  

            result[f"user:{user['id']}"]= dumper({"action":"idtonewdock","payload":{"id": doc.id,"vrersion":data['version']}})




        res = await PD.get_doclist(id)      
        # print (res)
        result[f"project:{id}"]= dumper({"action":"buildDocspage","payload": res})
        return result
        # return {
        #     # f"user:{user['id']}": dumper({"action":"buildDocspage","payload": res}),
        #     f"project:{id}": dumper({"action":"buildDocspage","payload": res})
        # }  