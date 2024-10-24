from fastapi import (
    APIRouter,
    Depends,
    status
)
from services.base import QueryHelper as QH
from services.depends import AD
from orm.models import *
from orm.schema import *
from datetime import datetime, date
router = APIRouter(
    prefix='',
    tags=['Операции с задачами'], 
    
)
import asyncio
from services.wsservice import *
from services.helper import *
from services.redis_key import *
from services.rediskeyhelper.project.buildier import *
from services.rediskeyhelper.work.buildier import *
from services.rediskeyhelper.assignment.buildier import *
from services.rediskeyhelper.files.query import *
@router.get("/task/{item_id}")


async def get_task(projectid:int, id: int):   
 
    proj,task = await asyncio.gather( 
        REdSetter.updateKeyReturnChecker(REdSetterSettings('data:project',projectid,'project')),
        REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',id,'project_tasks')),
        # REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',item_id,'task_work')),
        
    )
    task['task_work'], task['task_files'], proj=await asyncio.gather(
                                        WorkBuildier.worklist(task['task_work']),
                                        FileListGetter.files_in_task(id),
                                        ProjectBuildier.build_proj_persons(proj)  
    )

    for x in task['task_work']:
       a = await asyncio.gather(AssignmentBuildier.assignmentlist(x['work_assignment']))
       x['work_assignment'] = a[0]
       
    history = await ProjectHistory.objects.select_related(["author",'action']).filter(project=projectid, task=id,assignment__isnull=True).order_by("-id").all()
    task['history']= [querytoPydantic(History4Status,x) for x in history]
    
    return {"project":proj,"task":task}
    # return task


@router.get("/createtask/",  status_code=status.HTTP_201_CREATED)

async def create_task(data, user:dict = Depends(AD.protect_claim)):
    print('user---------------------------')
    # await ProjectHistory.objects.create(**{"author":user['id'],"level":2,"project":data['parent'], 'action':1, "text": f"создал(а) задачу {data['name']} ({data['datestart']}-{data['dateend']}).\n Ответственным назначен {data['responsible']['text']}"})
   
    data = TaskCreate.parse_obj(data)
    nt=await Task.objects.create(**data.dict(),status=1)
    # await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',nt.id,'project_tasks'),True) 
    # return {"id":res.id, "name":res.name}


router.get("/updatetask/",  status_code=status.HTTP_201_CREATED)

async def update_task_from_proj(data, user:dict = Depends(AD.protect_claim)):
    
    data = foreignkeytoint(data)
    print(data)
    task = await Task.objects.get(id = data['id'])
    await task.update(**data)
    await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:task',data['id'],'project_tasks'),True) 
    return {"id":task.id, "name":task.name}

router.get("/deltask/",  status_code=status.HTTP_201_CREATED)

async def del_task_from_proj(data, user:dict = Depends(AD.protect_claim)):
    ttd=   await Task.objects.get(id=data['id'])
    await ttd.task_work.clear()
    await ttd.delete()

