from services.redis_key import *
import asyncio

async def emptyidct():
    asyncio.sleep(0)
    return {}

async def emptyarr():
    asyncio.sleep(0)
    return []

async def asincuser(arr)->list:
    return [{"role":x["role"],"percent":x["percent"], "user": await REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',x['user']['id'],'getuser'))} for x in arr]
    



class ProjectBuildier:
    async def build_proj_persons(nudeproj): 
       
        nudeproj['users']=await asincuser( nudeproj['users'])
        
       
        return nudeproj