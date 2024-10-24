from orm.models import *
from orm.schema import *
from services.wsservice import *



class AssignmentQuery:
    async def assignment(id):
        assignment: Assignment = await Assignment.objects.select_related(["status","parent","responsible",'author']).fields(
            ["responsible__id","id","name","datestart","dateend", "parent__name","difficult",
            "responsible__username","responsible__sn","responsible__givenName","longname",
            "author__id","author__username","author__sn","author__givenName",
            "description","comment","timeneeded","author__id","status","getstarted","parent__id"]
        ).get(id=id) 
           
        return querytoPydantic(AssignmentinWork, assignment)
  
    
    async def assignments_in_work(work):
        assignments = await Assignment.objects.filter(parent=work).fields(["id","name"]).all()  
        return [querytoPydantic(Assignment.get_pydantic(include={"id"}), a) for a in assignments]

    async def assignment_status_update(id,status):
        res = await Assignment.objects.get(id=id)
        res.status= status
        res.lastchanged = datetime.now()
        if status==2:            
            if res.getstarted is None:
                res.getstarted = datetime.now()
        return await res.update()
