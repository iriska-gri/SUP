from asyncio import tasks, gather

from typing import Union
from fastapi import (
    APIRouter,
    Depends,
    status,
    Form, UploadFile

)
from fastapi.responses import FileResponse
from conf.sessions import get_redis_pool
from aioredis.client import PubSub, Redis
import json
import time
from datetime import datetime
import shutil
from pathlib import Path
from services.depends import AD
from orm.models import *
from orm.schema import *
from datetime import datetime, date
router = APIRouter(
    prefix='',
    tags=['Операции с проектом'], 
    
)
from services.redis_key import *
from services.docxdocuments import DocxCreator as DC
from services.base import QueryHelper as QH
from services.wsservice import *
from services.project.depends import *
from services.rediskeyhelper.project.buildier import ProjectBuildier
from services.rediskeyhelper.files.query import FileListGetter
from services.helper import foreignkeytoint, exclude_keys, historyDataCreator




@router.post("/createproj",  status_code=status.HTTP_201_CREATED)

async def create_projects(data:dict, user:dict = Depends(AD.protect_claim)):
  
  
    project = data['project']
    prc = exclude_keys(project,['tasks','project_checkpoint','id','users','status','history'])
    prc= foreignkeytoint(prc,['ptype'])    
    
    projusers = project['users']
    
    pr = await Project.objects.create(**prc, author=user['id'], status=1 )    
    for p_user in projusers:
        if p_user['role']['id']>0:           
            await ProjectUser.objects.create(project=pr.id,user=p_user['user']['id'], role=p_user['role']['id'],percent=p_user['percent'] )

    tasksandworks={}
    for x in project['tasks']:  
        del x['fakeid']     
        tsk = await Task.objects.create(**exclude_keys(x,['task_work','status','id']), status=1, parent = pr.id)
        tasksandworks[tsk.id]=[]
 
        for y in x['task_work']:
            del y['fakeid'] 
            w=await Work.objects.create(**exclude_keys(y,['status','id']), parent = tsk.id, status=1)
            tasksandworks[tsk.id].append(w.id)
           
    a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',pr.id,'project'))
    await historyDataCreator(user, a,1,1,pr.id)
    for [key, val] in tasksandworks.items():
        a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',key,'project_tasks'))
        await historyDataCreator(user, a,2,1,pr.id,key)
        for x in val:
            a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',x,'task_work'))
            await historyDataCreator(user, a,3,1,pr.id,key,x)

    for x in project['project_checkpoint']:
        await ProjectCheckpoint.objects.create(project=pr.id,checkpoint=x)
    
    return {"id":pr.id}
  

@router.get("/getprevdock/{pid}")
async def getpreviousdock(type:str,lastdatetype:str,pid:int):
    related=['doctype']+QH.appendForntoQ(['approver'],'position')
    print(lastdatetype,type,pid)
    res = await Documentation.objects.select_related(related).filter(approved=3,approvedtime__isnull=False, doctype__name=type, project=pid).order_by('-approvedtime').all()   
    
   
    return {'prevdock':querytoPydantic(ProjectDockInfo, res[0])if len(res)>0 else None}

@router.get("/getdock/{item_id}", response_model=ProjectDockInfo)

async def getprojectdock(item_id:int):
    
    users = []
    related=['doctype','doc_user']+QH.appendForntoQ(['doc_user__user','approver'],'position')
    res = await Documentation.objects.select_related(related).get(id=item_id)
    for x in res.doc_user:       
        dt = querytoPydantic(UserProjectFullName,x.user)
        dt['comment']=x.comment
        dt['accepted']=x.accepted
        dt['acceptedtime']=x.acceptedtime

        users.append(dt)
    res = res.dict()
    res['accepters']=users
    return res



  

@router.get("/project/{item_id}")

async def get_project(item_id: int):
    now = datetime.now()
    nudeproj =  await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',item_id,'project'))
    nudeproj = await ProjectBuildier.build_proj_persons(nudeproj)
   
    
    tasks = []
    for x in nudeproj['project_task']:   
        projt = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',x['id'],'project_tasks'))       
        projt['task_work'] =await asyncio.gather(*[REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',y['id'],'task_work')) for y in projt['task_work']])
        
        tasks.append(projt)
        
    
    del nudeproj['project_task']
    nudeproj['tasks']=tasks
    nudeproj['project_files']= await FileListGetter.files_in_project(item_id)
    # print(nudeproj['project_files'])
    history = await ProjectHistory.objects.prefetch_related(["author",'action']).filter(project=item_id, assignment__isnull=True).order_by("-id").all()
    nudeproj['history'] = [querytoPydantic(History4Status,x) for x in history]
    # print(await  ProjectCheckpoint.objects.filter(project = nudeproj['id']).all())
    nudeproj['project_checkpoint']= [x.checkpoint for x in await ProjectCheckpoint.objects.filter(project = nudeproj['id']).all()]
    print(f"потрачено {datetime.now()-now}")
    return nudeproj
   


@router.post("/project/{item_id}")
async def update_project(data, user):
    
    project=data['project']
    deleter = data['delete'] if "delete" in data.keys() else None
    print('project_checkpoint')
    print(project["users"])
    
    nudep = exclude_keys(project,['tasks','project_checkpoint','id','users','history','author', 'pcode','datachat','project_files'])
    nudep= foreignkeytoint(nudep,['ptype','status'])    
    
    pr= await Project.objects.get(id=project['id'])
    await pr.update(**nudep)
    await gather(ProjectUser.objects.delete(project=project['id']), ProjectCheckpoint.objects.delete(project=project['id'])  )   
    

    for x in project['project_checkpoint']:
        await ProjectCheckpoint.objects.create(project=pr.id,checkpoint=x)

    a= [ProjectUser.objects.create(**{"role": x['role']['id'],"percent":x['percent'],"project":project['id'],"user":x['user']['id']}) for x in project['users']]
    await gather(*a)
    tasksandworks={}

    for x in project['tasks']:

        hist_action =2
        if x['id']<=0:
            x['status']=1
            x= exclude_keys(x,['id'])
            hist_action =1
        else:
            
            x=foreignkeytoint(x,['status','responsible'])
        print("------------------------------------------------")
        
        tsk= await Task.objects.update_or_create(**exclude_keys(x,['task_work','parent','fakeid']), parent=pr.id)
       
        a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',tsk.id,'project_tasks'),True)
        await historyDataCreator(user, a,2,hist_action,pr.id,tsk.id)
        # tasksandworks[tsk.id]=[]
        
        for y in x['task_work']:
            hist_action =2
            if y['id']<=0:
                y['status']=1
                y= exclude_keys(y,['id'])
                hist_action =1
         
            w=await Work.objects.update_or_create(**exclude_keys(y,['parent','fakeid']), parent = tsk.id)
            a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',w.id,'task_work'),True)
            await historyDataCreator(user, a,3,hist_action,pr.id,tsk.id,w.id)
        a=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',tsk.id,'project_tasks'),True)
    

    if deleter is not None:
        if 'delworks' in deleter.keys():
            delworks = await Work.objects.filter(id__in=deleter['delworks']).all()
            # delworks = await Work.objects.all()
            hist_action =3
            for x in delworks:
                chats=[]
                asgm = await x.work_assignment.all()
                asgnments = [a.id for a in asgm]  
                # print(asgnments) 
                    
                await REdSetter.arr_key_del(f"data:assignments/",  asgnments)
                
                chats=await Chat.objects.filter(parent__in = asgnments, level=4).all()                      
                
                
                chats= chats+await Chat.objects.filter(parent = x.id, level=3).all()
                

                await REdSetter.arr_key_del(f"data:chatroom/",  [ch.id for ch in chats])
                
                [await ch.delete() for ch in chats]

                await x.delete()
                print('ok') 
            await REdSetter.arr_key_del(f"data:work/",  deleter['delworks'])
        if 'deltasks' in deleter.keys():
    
            tasks = await Task.objects.filter(id__in=deleter['deltasks']).all()
            chats = await Chat.objects.filter(parent__in = deleter['deltasks'], level=2).all()
            await REdSetter.arr_key_del(f"data:chatroom/",  [ch.id for ch in chats])
            [await ch.delete() for ch in chats]
            [await tks.delete() for tks in tasks]
            await REdSetter.arr_key_del(f"data:task/",  deleter['deltasks'])

    


    # !25.08.2023
    # keybase_del - удаление ключа и базы
    # await REdSetter.keybase_del(f"data:work/", Work, deleter['delworks'])

    # await gather(*[REdSetter.key_del(f"data:task/{x}") for x in deleter['deltasks']]  )
    # for x in project['project_checkpoint']:
    #     await ProjectCheckpoint.objects.update_or_create(project=pr.id,checkpoint=x)    
    # await historyDataCreator(user, a,1,hist_action,pr.id)
    
    
    return await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',project['id'],'projectMainFieldsUpdater'),True)


@router.post("/project/{item_id}/uploaddock")
async def uploaddock(item_id:int,file:UploadFile, approver:Optional[int]=Form(None), approved:Optional[int]=Form(None),doctype:str=Form(...),docnumber:Optional[str]=Form(None)):
    
    fp = Path(__file__).parent.parent
   
    fp =fp.joinpath('uploads','documents',f'{item_id}/')
    
    fp.mkdir(parents=True,exist_ok=True)
    fn = f'{time.time()}_{file.filename}'
    file_location = fp.joinpath(fn)
    with open(file_location, "wb+") as file_object:
        shutil.copyfileobj(file.file, file_object)
    print(docnumber)
    saving = {'project':item_id,
                'approved': approved,
                'approver': approver if approver>0 else None,
                'doctype':await DocType.objects.get(name=doctype),
                'created':datetime.now(),
                'vrersion':json.dumps({}),
                'docnumber':docnumber,
                'path':f'/uploads/documents/{item_id}/{fn}'
    }    
    print(str(file_location))
    await Documentation.objects.create(**saving)
    return {"created":"ok"}

    
@router.get("/uploads/documents/{pid}/{filename}", response_class=FileResponse)
async def main(filename:str,pid:int):
    print("boooo--------------------------------------------", filename)
    return f"{Path(__file__).parent.parent}/uploads/documents/{pid}/{filename}"

@router.get("/project/downloaddock/{docid}")

async def main(docid:int, confirmationmod:bool):
    """Документы проекта. docid - ID документа, confirmation - если нужно согласование"""
    res=""
    if confirmationmod==True:
        related = ['project','doc_user','doctype']+ QH.appendForntoQ(['doc_user__user'],'position')+QH.appendForntoQ(['approver'],'position')
        
        doc = await Documentation.objects.select_related(related).get(id=docid)
        print("-----------------------------------------------------------------")
        

        res=DC.confirmer(doc)
    else:
        print("-----------------------------------------------------------------")
        related = ['project','approver','doctype','doc_user']+ QH.appendForntoQ(['doc_user__user'],'position')+QH.appendForntoQ(['approver'],'position')
        
        doc = await Documentation.objects.select_related(related).get(id=docid)
       
        
        res=DC.docChooser(doc)

        
    return DC.decodetobase(res)


