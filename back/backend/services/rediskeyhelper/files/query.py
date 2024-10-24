from orm.models import *
from orm.schema import *
from services.wsservice import *

class FileListGetter:
    async def files_in_work(workid):
        files = await Projectfile.objects.select_related("sender").filter(work = workid).all()
        wf=[querytoPydantic(Filegetter, x) for x in files]
     
        return wf
    async def files_in_task(id):
        files = await Projectfile.objects.select_related("sender").filter(task = id).all()
       
        wf=[querytoPydantic(Filegetter, x) for x in files]
     
        return wf
    async def files_in_project(id):
        files = await Projectfile.objects.select_related("sender").filter(project = id).all()
       
        wf=[querytoPydantic(Filegetter, x) for x in files]
        print("s")
        return wf