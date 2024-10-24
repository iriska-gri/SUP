
from fastapi import (
    APIRouter,
    Depends
)
from typing import Optional,List
from fastapi_jwt_auth import AuthJWT
from orm.models import *
from fastapi_jwt_auth import AuthJWT
from orm.schema import UserRegister, UserLogin, User,Rank, Position,ProjectHistoryModel
from services.depends import AD
from datetime import datetime
from services.wsservice import querytoPydantic
router = APIRouter(
    prefix='/history',
    tags=['История'], 
    
)

from services.base import QueryHelper as QH


@router.get("/project/{pid}",response_model=list[ProjectHistoryModel])
# 
#  response_model=list[ProjectHistoryModel])
async def get_history(pid: int):
   now = datetime.now()
   print("Начали")
   
#    related = ["status","ptype"]+QH.appendForntoQ(["director",'coordinator',"secretary","author","rp"],'position')
#    a = await Project.objects.select_related(related).get(id=pid)  
# 
#  
   a= await ProjectHistory.objects.select_related(['author']).filter(project=pid).order_by("-id").all()
   
   print(datetime.now()-now)

   return a