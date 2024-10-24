from datetime import datetime
import email
from email import message
from lib2to3.pytree import Base
from .models import *
from pydantic import BaseModel, Json
from typing import List, Optional
from pydantic_computed import Computed, computed

# *-------------------- User schema --------------------* #
# class Restore_U(BaseModel):
#     email: str
#     lotus_key:str
#     password:str

class Codeconfirm(BaseModel):
    action:str
    email:Optional[str]
    

class UserLogin(BaseModel):
    username:str
    password: str
    email:Optional[str]

create_user = {"username", "givenName", "sn", "telephoneNumber", "otdel__name", "position__name", "rank__name", "superuser",'department__name','department__postal_code','department__city','department__region','department__street' ,'organization__name', 'physicalDeliveryOfficeName'}
claim_user = {'id',"sn","username", "givenName","telephoneNumber","email","department__name","department__id", "otdel__name","otdel__id", "position__name", "rank__name", "organization__id", "organization__name", "superuser"}
create_user_mult = {"first_name", "last_name", "middle_name", "innerphone","email", "otdel__name", "position__name", "rank__name",'department__name','organization__name'}

UserMultiUpload = User.get_pydantic(include=create_user_mult)
UserRegister = User.get_pydantic(include=create_user)

# UserLogin = User.get_pydantic(include={"username", "password"})
UserLoad = User.get_pydantic(exclude={"password",})
# UserList = User.get_pydantic(include={"id", "first_name","middle_name","last_name","otdel__name"})



class UserList(BaseModel):
    id: int
    given_name: str
    # middle_name: str
    last_name: str
    otdel: Otdel


# ProjectCreate = Project.get_pydantic(include={"id","name", "description", "status__id", "customer", "author__id", "leader__id", "users__id", "lastchanged"})
class UserFullName(BaseModel):    
    sn:str
    givenName:str
    fullname: Computed[str]
    position: Optional[Position]
    
    
    @computed('fullname')
    def fullnamed(sn:str, givenName:str):
        return f'{sn} {givenName}'

class UserProjectFullName(UserFullName):
    id:int

class UserFullInfo(UserProjectFullName):  
    username:Optional[str] 
    telephoneNumber:Optional[str]
    phone:Optional[str]
    email:Optional[str]
    otdel:Optional[Otdel.get_pydantic(include={"id","name"})]
    department:Optional[Department.get_pydantic(include={"id","name"})]
    organization:Optional[Organization.get_pydantic(include={"id","name"})]
    position:Optional[Position.get_pydantic(include={"id","name"})]
    avatar:Optional[str]
    physicalDeliveryOfficeName: Optional[str]
 
 
class GetFilters():
    filters: List

class ProjectHistoryModel(BaseModel):
    id:int
    text: str
    createdate: datetime
    action: dict
    author: User.get_pydantic(include={"id","sn"})
    level: dict


class BaseCreateProjectTask(BaseModel):
    name: Optional[str]
    longname: Optional[str]
    datestart: Optional[date]
    dateend: Optional[date]
    # description: Optional[str]


class ProjectCreate(BaseCreateProjectTask):     
    status: Optional[ProjectStatus.get_pydantic(include={"id"})]    
    author: Optional[User.get_pydantic(include={"id"})] 
 
    info: Optional[dict]           
    
  
    users: Optional[list]
    lastchanged: Optional[datetime] = datetime.now()

    ptype:Optional[ProjectType.get_pydantic(include={"id"})]  

    

    
class ProjectUpdate(ProjectCreate):
    # watchers:Optional[list[ProjectUser.get_pydantic(include={"id"})]]
    id: int


idname = {"id","givenName", "sn"}
# ProjectUser.get_pydantic(include={"id","involved","user__id","user","user__sn"})
class ProjectGet(BaseCreateProjectTask):
    id:int
    status: Optional[ProjectStatus.get_pydantic(include={"id","name"})]    
    pcode: Optional[str]
    project_task:Optional[list[Task.get_pydantic(include={"id"})]]
    ptype:Optional[ProjectType.get_pydantic(include={"id","name"})]  
    author: Optional[User.get_pydantic(include={"id"})] 
    
    users: Optional[list]
    difficult: Optional[int]
    info:Optional[dict]  
    
   
class ProjectUserSchema(BaseModel):
    role:Projectrole.get_pydantic(include={"id","name"})
    user:User.get_pydantic(include={"id"})
    percent: Optional[int]
class ProjectReestrUserSchema(BaseModel):
    role:Projectrole.get_pydantic(include={"id"})
    user:User.get_pydantic(include={"id","sn"})





class ProjectReestrSchema(BaseModel):
    id:int
    name: Optional[str]
    datestart: Optional[date]
    dateend: Optional[date]
    lastchanged:Optional[datetime]
    status:ProjectStatus.get_pydantic(include={"id","name"})
    user_project: Optional[list[ProjectReestrUserSchema]]
    project_task:Optional[list[Task.get_pydantic(include={"id","name","status__id","dateend","status__name","responsible","responsible__sn"})]]


class TaskReestrSchema(BaseModel):
    id: int
    name: str
    parent:Project.get_pydantic(include={"id"})
    datestart: Optional[date]
    dateend: Optional[date]
    lastchanged:Optional[datetime]
    status:TaskStatus.get_pydantic(include={"id","name"})
    responsible: Optional[User.get_pydantic(include={"id","sn"})]
    task_work: Optional[list[Work.get_pydantic(include={"id","name","status__id","dateend","status__name","responsible","responsible__sn"})]]

class WorkReestrSchema(BaseModel):
    id: int
    name: str
    parent:Task.get_pydantic(include={"id","parent"})
    # parent__parent:int
    datestart: Optional[date]
    dateend: Optional[date]
    lastchanged:Optional[datetime]
    status:TaskStatus.get_pydantic(include={"id","name"})
    responsible: Optional[User.get_pydantic(include={"id","sn"})]
    work_assignment: Optional[list[Assignment.get_pydantic(include={"id","name","status__id","dateend","status__name","responsible","responsible__sn"})]]

class AsPP(BaseModel):
    id:int
    parent:Project.get_pydantic(include={"id"})

class ASgnmParent(BaseModel):
    id:int
    # parent: Task.get_pydantic(include={"id"})

class AssignmReestrSchema(BaseModel):
    id: int
    name: str
    parent:ASgnmParent
    
    datestart: Optional[date]
    dateend: Optional[date]
    lastchanged:Optional[datetime]
    status:TaskStatus.get_pydantic(include={"id","name"})
    responsible: Optional[User.get_pydantic(include={"id","sn"})]
    






class AssignmentinTask(BaseModel):
    id:int
    name:str
    status:AssignmentStatus.get_pydantic(include={'id','name'})
    datestart:Optional[date]
    dateend: Optional[date]
    responsible: User.get_pydantic(include={"id"})

class Work4project(BaseModel):
    id:int
    difficult: Optional[int]
    longname: Optional[str]
    work_assignment:Optional[list[Assignment.get_pydantic(include={"id"})]]
    parent:Task.get_pydantic(include={'id','parent__id'})   
    name: str
    status: TaskStatus.get_pydantic(include={"id","name"})
    responsible:Optional[User.get_pydantic(include={"id","sn", "givenName"})]
    dateend: Optional[date]
    datestart:Optional[date]
    description: Optional[Text]    
    work_assignment:Optional[list[Assignment.get_pydantic(include={"id"})]]


class History4Status(BaseModel):
    id: int
    project: Optional[int]
    task:Optional[int]
    work:Optional[int]
    assignment: Optional[int]
    info: dict
    level:int
    author: User.get_pydantic(include={"id","sn","avatar"})
    createdate: datetime
    action: HistoryAction.get_pydantic(include={"id","name"})
    comment:Optional[Text]

# History4Status
 

class WorkAssignments4project(Work4project):
    work_assignment:list[AssignmentinTask]

class AllProjectDocumentation(BaseModel):
    id:int
    doctype:DocType.get_pydantic(include={"id","name"})
    created: datetime
    approved: Optional[int]
    approvedtime:Optional[datetime]
    approver: Optional[UserProjectFullName]
    docnumber:Optional[str]
    accepters:Optional[list]
    path:Optional[str]

class ProjectDockInfo(AllProjectDocumentation):    
    vrersion: dict
    comment:Optional[str]
    path:Optional[str]
    # accepters:Optional[list]

class Task4ProjectGetBase(BaseModel):  
    id:int
    parent: Optional[Project.get_pydantic(include={'id'})]
    status: Optional[TaskStatus.get_pydantic(include={"id","name"})]
    name: Optional[str]
    responsible:Optional[User.get_pydantic(include={"id","sn","givenName"})]
    dateend: Optional[date]
    datestart:Optional[date]
    description:Optional[str] 
    difficult: Optional[int]
    longname: Optional[str]
    # comment:Optional[list]

class Task4ProjectGet(Task4ProjectGetBase):    
    task_work:list[Work.get_pydantic(include={"id"})]

class WorkAssignmentsInTask(Task4ProjectGetBase):
    work_assignment:list[AssignmentinTask]
    # pass
class Task4Proj(BaseModel):
    task:Optional[list[Task4ProjectGetBase]]    
    
class History4ProjectGet(BaseModel):
    id:int
    info: Json
    action: HistoryAction.get_pydantic(include={"id","name"})
    createdate: datetime
    # level: HistoryLevel.get_pydantic(include={"id","name"})
    author: UserFullName





class TaskCreate(BaseCreateProjectTask):
    parent: int
    name: str
    # status: Optional[TaskStatus.get_pydantic(include={"id"})]
    datestart:date
    dateend: date
    responsible: User.get_pydantic(include={"id"})
    # users: Optional[list[ProjectUser.get_pydantic(include={"id"})]]

class TaskUpdate(TaskCreate):
    id:int


class AssignmentCreate(BaseModel):
    task: Optional[Task.get_pydantic(include={"id"})]
    name: str
    user: Optional[User.get_pydantic(include={"id"})]
    status: Optional[AssignmentStatus.get_pydantic(include={"id"})]
    datetimeend:Optional[datetime] = datetime.now()

class AssignmentUpdate(AssignmentCreate):
    id:int
    datetimestart: Optional[datetime] = datetime.now()
    timeneeded: Optional[int]





# -----------------------------------Схемы чатов


class ChatUserschema(BaseModel):
    id:int
    sn: str
    givenName:str
    # username:str
class LastChatMessage(BaseModel):
    id:int
    text:str
    messagetime: datetime
    sender:ChatUserschema

class LchMesWithParent(LastChatMessage):
    chat:Chat.get_pydantic(include={'id',"parent",'level'})






class Chatschema(BaseModel):  
    id:int 
    name:Optional[str]
    users: List[ChatUserschema]
    level:Optional[int]
    parent:Optional[int]
    admin:Optional[User.get_pydantic(include={'id'})]
    # chat: Chat.get_pydantic(include={"id","name"})
    # users:list[CHatuser]

# class ChatList(Chatl):
#     list:Optional[list[Chatl]]   
   
    
# class ChatParamsToPost(ChatlistBase):  
#     sender: int
 

# Поручен
class AAW(BaseModel):
    id:int
    name:str
    datestart: date
    dateend: date
    

class FileGetterUpdated(BaseModel):
    id:int
    project: Optional[Project.get_pydantic(include={"id"})]
    task: Optional[Task.get_pydantic(include={"id"})]
    work:Optional[Work.get_pydantic(include={"id"})]
    assignment:Optional[Assignment.get_pydantic(include={"id"})]
    visible:str

class Filegetter(FileGetterUpdated):
   
    sender:Optional[User.get_pydantic(include={'id',"sn","givenName"})]
    datetime: datetime
    filepath: str
    counter: int










# !Новый
class AssAndWork(AAW):  
    responsible: Optional[User.get_pydantic(include={'id','sn','givenName'})]   
    description: Optional[str]
    difficult: Optional[int]
    longname: Optional[str]
    # comment:Optional[list]
    
class Parent_Parent(AAW):
    rp: Optional[User.get_pydantic(include={'id'})]

class AssignmentinWork(AssAndWork):
    timeneeded: Optional[int]
    author: User.get_pydantic(include={'id'})
    status: AssignmentStatus.get_pydantic(include={'id','name'})
    getstarted: Optional[datetime]
    parent:Work.get_pydantic(include={'id'})

    
   
    # assignment_files:Optional[list[Filegetter]]

class TaskinWork(AssAndWork):
    parent: Parent_Parent

class FullWork(AssAndWork):
    parent: AssAndWork
    lastchanged:Optional[date]
    status:TaskStatus.get_pydantic(include={'id',"name"})
    work_assignment:Optional[list[AssignmentinWork]]
    work_files:Optional[list[Filegetter]]

class WorkonlyFiles(BaseModel):
    work_files:Optional[list[Filegetter]]

class AssignmentUpdated(BaseModel):
    id:int
    status: AssignmentStatus.get_pydantic(include={'id','name'})
    getstarted: Optional[datetime]
    timeneeded: Optional[int]

# !Новый
class WorkforAssignment(BaseModel):
    responsible:User.get_pydantic(include={'id'})
    status:TaskStatus.get_pydantic(include={'id',"name"})
    
    parent:Task.get_pydantic(include={'id','parent__id'})
    work_assignment:Optional[list[Assignment.get_pydantic(include={"id"})]]
    work_files:Optional[list[Filegetter]]