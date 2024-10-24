from fastapi import (
    APIRouter,
    Depends
)
from typing import Optional,List
from fastapi_jwt_auth import AuthJWT
from orm.models import ProjectStatus, TaskStatus, Otdel, Organization, Department,ProjectType
from fastapi_jwt_auth import AuthJWT
from orm.schema import UserRegister, UserLogin, User,Rank, Position
from services.depends import AD
import asyncio
from services.reestr import ReestrService
from orm.redis import RedisWorker
from services.redis_key import *

router = APIRouter(
    prefix='/filters',
    tags=['Фильтрация'], 
    
)

modelsdict = {
    "project__status": ProjectStatus,
    "project__type":ProjectType,
    "task__status": TaskStatus,
    'work__status':TaskStatus,
    'assignment__status':AssignmentStatus,
    "organization":Organization,
    "department":Department,
    "otdel":Otdel,
    "position":Position,
    "user":User,
    "role":Projectrole
    
}
# modelsdictfree = {    
#     "otdel":Otdel,
#     "rank": Rank,
#     "position":Position,
#     "division__otdel": Department
# }


async def filterget(terms, model):
    filterinfo ={}
    
    for x in terms:        
        for [key, val] in x.items():           
          
            query = model[key].objects
            if 'filters' in val.keys():                
                query=query.filter(**val['filters'])
            if 'fields' in val.keys():
                query=query.fields([*val['fields']]) 
            if 'select_related' in val.keys():
                query=query.select_related(val['select_related'])
            if 'exclude' in val.keys():
                query= query.exclude_fields([*val['exclude']])
            if 'sort' in val.keys():
                query=query.order_by(val['sort'])

            filterinfo[key]= await query.all()
                
                
    
    return filterinfo


@router.post("/")
async def getselect(terms:List, username:str = Depends(AD.protect)):
    """Здесь берем все селекты, в том числе для фильтрации. Защищенный API \n
    Пример :[{"project__status": { "sort": "id", "filters":{},"exclude":[]}}] \n
    или [{"organization": {"sort": "id", "filters":{"id":3},"fields":[],"exclude":[],"select_related":"organization_department"
        }}]\n
    или \n
     [{"organization": {"sort": "id", "filters":{},"exclude":[]}},
 {"department": {"sort": "id", "filters":{"organization__id":3},"exclude":[]}},
{"otdel": {"sort": "id", "filters":{"department__id":17},"select_related":"otdel_user"}}\n
    Ключ - таблица, \n
    ВСЕ КЛЮЧИ НЕ ОБЯЗАТЕЛЬНЫ
    "sort - поле сортировки" \n
    "filters" - поля и значения, если еще необходимо и отфильтровать  \n
    "fieds" - [] поля, которые нужны  \n
    "exclude" - [] поля, которые надо выкинуть \n
    "select_related"  - дочернее поле, если надо забрать\n
    
    ключ-таблица: \n
    "project__status": ProjectStatus,\n
    "taskStatus": TaskStatus,\n
    "organization":Organization,\n
    "department":Department,\n
    "otdel":Otdel,\n
    "position":Position,\n
    "user":User\n
    }
    """
  
    return await filterget(terms, modelsdict)
    
@router.post("/free")
async def getfiltersfree(filters:List):

    return await filterget(filters, modelsdict)

@router.post("/userlist")
  
async def getfilters(filters:dict, exclude:list):
    """
    ПОдгрузка oтделов c их пользователями  по фильтрам
    параметр filters={}
     "filters":{"department__id": 17},
     "exclude":['department']"  """    

    return await Otdel.objects.select_related("otdel_user").filter(**filters).fields({'id':...,
                                                                                    'name':...,
                                                                                    'otdel_user':{'id', 'username','givenName','sn'}
                                                                                    }).exclude_fields(*exclude).all()


@router.post("/snistartswith")
async def getusers(terms:List):    
    
    users = await User.objects.filter(**terms[0]['terms']).fields(['id','username', 'sn',"givenName"]).all()    
    tsk = await asyncio.gather(*[REdSetter.updateKeyReturnChecker(REdSetterSettings('users:user',x.id,'getuser')) for x in users])
   
    return tsk