
from fastapi import (
    APIRouter,
    Depends,
    status
)
from services.depends import AD
from orm.models import *
from orm.schema import *
from .project import *
from datetime import datetime, date
from services.redis_key import REdSetter
router = APIRouter(
    prefix='',
    tags=['Операции с работами'], 
    
)

from services.wsservice import *
from services.helper import *
from services.rediskeyhelper.files.query import FileListGetter
from services.rediskeyhelper.assignment.buildier import AssignmentBuildier

    


async def create_work_from_project(data,project,task, user:dict = Depends(AD.protect_claim)):
    data['responsible']=data['responsible']['id']
   
    nw = await Work.objects.create(**data)
    dt=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',nw.id,'task_work'),True) 
    await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',nw.parent.id,'project_tasks'),True)
    await historyDataCreator(user,dt,3,1,project,task,workid=nw.id)
    



async def edit_work_from_project(data, projectid,taskid,user:dict = Depends(AD.protect_claim)):
    
    data = foreignkeytoint(data)  
    
    work = await Work.objects.get(id = data['id'])
    await work.update(**data)
    dt=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data['id'],'task_work'),True)   
    await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',taskid,'project_tasks'),True) 
    await historyDataCreator(user,dt,3,2,projectid,taskid,workid=work.id)
    
    
async def del_work_from_project(data) :
    # work = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data['id'],'task_work'))   
    await Work.objects.delete(id=data['id'])    
    work = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data['id'],'task_work')) 
    
    wassignid = [x['id'] for x in  work['work_assignment']]
    chats = await Chat.objects.filter(level=4, parent__in=wassignid).fields(["id"]).all()
    chatdel = [REdSetter.key_del(f"data:chatroom/{x.id}") for x in chats]
    assdel = [REdSetter.key_del(f"data:assignment/{x}") for x in wassignid]
    await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',data['parent']['id'],"project_tasks"),True)
    await asyncio.gather(*chatdel, *assdel, REdSetter.key_del(f"data:work/{data['id']}"), REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',data['parent']['id'],'project_tasks'),True) )
    







async def create_assignment_from_task(data,projectid,taskid,user):
    data = foreignkeytoint(data) 
    # print(data)
    data['status']=1 
    data['author']=user['id']
    assgn = await Assignment.objects.create(**data)

    await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data['parent'],'task_work'),True)   
    dt=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',assgn.id,'work_assignment'),True)

    await historyDataCreator(user,dt,4,1,projectid,taskid,workid=data['parent'], assid=assgn.id)

async def del_assignment_from_task(data,projectid,taskid,user):
    a =await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',data["id"],'work_assignment'))   
    await historyDataCreator(user,{"name":a['name']},4,3,projectid,taskid,data['parent']['id'],data["id"])
    await asyncio.gather(
        REdSetter.key_del(f"data:assignment/{data['id']}"),
        Assignment.objects.delete(id=data['id']),
        REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',data['parent']['id'],'task_work'),True)  

    )

    


async def edit_assignment_from_task(data,projectid,taskid, user):
   
    data = foreignkeytoint(data)   
    
    asigm = await Assignment.objects.get(id = data['id'])
    asigm.lastchanged = datetime.now()
    await asigm.update(**data)
    
    dt=await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',data["id"],'work_assignment'),True)
    await historyDataCreator(user,dt,4,2,projectid,taskid,workid=data['parent']['id'], assid=asigm.id)




# @router.get("/work/{item_id}")

async def get_work(projectid:int,taskid:int, item_id: int):   
    now1 =  datetime.now()
    print("начало")
    proj,task,work = await asyncio.gather( 
        REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',projectid,'project')),
        REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',taskid,'project_tasks')),
        REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',item_id,'task_work')),
        
    )
   
    print(f'конец work {datetime.now()-now1}')
    now =  datetime.now()     
    
    work['work_assignment'], work['work_files'],proj =  await asyncio.gather(                                                                         
                                                                        AssignmentBuildier.assignmentlist(work['work_assignment']), 
                                                                        FileListGetter.files_in_work(item_id),
                                                                        ProjectBuildier.build_proj_persons(proj)                       
                                                                         )
    # work['history'] = ProjectHistory.objects.filter()
    history = await ProjectHistory.objects.select_related(["author",'action']).filter(project=projectid, task=taskid,work=item_id).order_by("-id").all()
    work['history']= [querytoPydantic(History4Status,x) for x in history]
    print(work['history'])
    print(f'конец task_work {datetime.now()-now1}')
    now =  datetime.now()
   
    
    print(f"ИТОГО: {now-now1}")
    
    return {'work':work,"project":proj,"task":task}