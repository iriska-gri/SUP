from orm.models import *
from orm.schema import *
from services.wsservice import *



class Taskquery:
    async def project_tasks(id):
        task: Task = await Task.objects.select_related(["status","parent","responsible",'task_work','parent']).fields(
            ["task_work__id","longname",
            "task_work__id",
            "task_work__name",            
            "status","status__name","parent__id","responsible__id","responsible__username",
            "responsible__sn","responsible__givenName","dateend","datestart","description","name","comment", 'difficult' ]
        ).get(id=id)        
        return querytoPydantic(Task4ProjectGet, task)

    async def task_status_update(user, id, status):
         work = await Task.objects.get(id=id)
         work.status = status
         return await work.update()