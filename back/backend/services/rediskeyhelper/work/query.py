from orm.models import *
from orm.schema import *
from services.wsservice import *



class Workquery:
    async def task_work(id) -> dict:
       
        work= await Work.objects.select_related(["status","parent","responsible","work_assignment"]).order_by("work_assignment__dateend").fields(["responsible__id","responsible__username",
        "responsible__sn","responsible__givenName","id","parent","name","status", "datestart","dateend","comment","difficult","longname", 'description',
                   "work_assignment__name", "work_assignment__id","work_assignment__dateend"]).get(id=id)
        
        return querytoPydantic(Work4project, work)

    async def getstatus(id):
        status = await TaskStatus.objects.get(id=id)
        return querytoPydantic(TaskStatus.get_pydantic(include={'id','name'}),status)
    

    async def work_status_update(user, id, status):
         work = await Work.objects.get(id=id)
         work.status = status
         return await work.update()