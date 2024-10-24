from orm.models import *
from orm.schema import *
from services.wsservice import *


class Projectquery:
    def __init__(self) -> None:
        pass
    
    @classmethod
    async def ProjectBaseFieldsQuery(self,id):  
        """Берем только проект (без информации о пользователях - только их ид и роль)"""
        a = await Project.objects.select_related( ["status","ptype","project_task"]).get(id=id)        
        a=querytoPydantic(ProjectGet,a)
        a['users'] = await self.get_nudeprojectusers(id)    
        return a


    @classmethod
    async def get_nudeprojectusers(self,projectid):      
        usersq = await ProjectUser.objects.select_related(["role"]).filter(project=projectid).all()
        
        users = [querytoPydantic(ProjectUserSchema,x) for x in usersq]        
        return users

    @classmethod
    async def project_status_update(id, status):
        work = await Project.objects.get(id=id)
        work.status = status
        return await work.update()

    