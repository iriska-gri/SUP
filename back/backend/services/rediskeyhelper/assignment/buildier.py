from services.redis_key import *
import asyncio
class AssignmentBuildier:
    async def assignmentlist(arr):       
        wa = [REdSetter.updateKeyReturnChecker(REdSetterSettings('data:assignment',x["id"],'work_assignment')) for x in arr]
        res = await asyncio.gather(*wa)
        return res