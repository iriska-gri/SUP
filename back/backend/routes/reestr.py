import json
from services.reestr import ReestrService
from orm.models import Project
class ReestrProjectActs:
    """ Обработчик сокетов реестров """
   
    
    # async def project_filtering(data, user):           
    #     payload =  await Project.objects.select_related(Project.leader).fields('leader__password').all()
    #     return  { f"user:{user['id']}" : json.dumps({"payload": payload, "action": "build"}, default=str)}

    # async def getchild(data, user,typen):        
    #     payload = await ReestrService.give_list_child(user['id'],data['parent__type'],data['parent__id'], is_superuser=user["superuser"])  
    #     return  { f"user:{user['id']}" : json.dumps({"child": payload, "action": "build"}, default=str)}





    async def getfilter(data, user,typen):
        # print(data,"daaaaa",typen)
        return { f"user:{user['id']}" : json.dumps({"action": "build","payload":await ReestrService.give_list_reestr(user['id'],typen,is_superuser=user["superuser"], filters = data['payload'])}, default=str)}

# from fastapi import (
#     APIRouter,
#     Depends
# )
# from typing import Optional
# from fastapi_jwt_auth import AuthJWT
# from orm.models import project
# from orm.schema import BaseProject,BaseProjectstatuses
# from services.projects import ReestrService
# from services.projectstatus import ProjectstatussService
# router = APIRouter(
#     prefix='/project',
#     tags=['Project'],
    
# )





# operation_id="authorize"
# @router.get("/")
# async def get_all_projects(
#             user_id = Depends(currentuserID),
#             filterstatus: Optional[Depends()]=None):
#     print(user_id)
#     projectsList = await ReestrService.get_list(params={"field":"", 'searchval':""})
#     return []

# @router.get("/")
# async def get_all_projects(user_id = Depends(currentuserID)):
#     print(user_id)

#     return {"a":"b"}

# @router.post("/")
# async def create_project(project: ProjectSchema):
#     project_id = await Project.create(**project.dict())
#     return {"project_id": project_id}


# @router.get("/{id}")
# async def get_project(id: int, ):
#     project = await Project.get_join(id, ("User",))
#     return {'project': project}

