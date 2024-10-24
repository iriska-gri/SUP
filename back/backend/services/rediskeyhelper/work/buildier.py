from services.redis_key import *
import asyncio
class WorkBuildier:
    async def worklist(arr):         
        wa = [REdSetter.updateKeyReturnChecker(REdSetterSettings('data:work',x["id"],'task_work')) for x in arr]
        
        res = await asyncio.gather(*wa)
     
        return res