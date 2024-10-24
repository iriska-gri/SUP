from email.policy import default
from typing import Optional
from datetime import date, datetime
from ormar import pre_delete
from ormar import Integer,JSON, String, Boolean, ForeignKey, Model, ModelMeta, ManyToMany, Date, Text, DateTime, pre_save, pre_update, property_field,UniqueColumns
from conf.sessions import database, metadata
from enum import Enum
import pydantic

# *-------------------- Base --------------------* #
async def change_lastchanged(sender,instance):  
    # print(sender)
    # print(instance.id)
    ttoup=await Project.objects.get(id=instance.id)
    
    upit = {'lastchanged':datetime.now()}
    
    # if instance.datestart and (not ttoup.datestart or instance.datestart < ttoup.datestart):
    #     upit['datestart'] = instance.datestart
    # if instance.dateend and (not ttoup.dateend or instance.dateend < ttoup.dateend):
    #     upit['dateend'] = instance.dateend
    await ttoup.update(**upit)


class BaseId():
    """
        Базовый класс, добавляющий в дочерние Первичный ключ ID    
    """
    id: int = Integer(primary_key=True)

class BaseMeta(ModelMeta):
    """
        Обязательно к добавлению во все таблицы
        class Meta(BaseMeta):
        ...
    """
    metadata = metadata
    database = database

# !-------------------- User --------------------! #
# *-------------------- Foreign Key --------------------* #
class Organization(Model, BaseId):
    name: str = String(max_length=500, unique=True)
    class Meta(BaseMeta):
        ...
class  Department(Model, BaseId):
    name: str = String(max_length=100, sql_nullable=True, unique=True)
    postal_code = String(max_length=100,sql_nullable=True, nullable=True)
    city = String(max_length=200,sql_nullable=True, nullable=True)
    region = String(max_length=200,sql_nullable=True, nullable=True)
    street = String(max_length=200,sql_nullable=True, nullable=True)
    # organization: Organization=ForeignKey(Organization,sql_nullable=True, nullable=True, related_name = "organization_department")

    class Meta(BaseMeta):
        ...

class Otdel(Model, BaseId):
    name: str = String(max_length=200, unique=True)
    shortname: str = String(max_length=7, nullable=True, default="")
    # department:Department=ForeignKey(Department,sql_nullable=True, nullable=True, related_name = "department_otdel")
    
    class Meta(BaseMeta):
        tablename = "otdels"
        ...
 
class Position(Model, BaseId):
    name: str = String(max_length=100, unique=True)
    class Meta(BaseMeta):
        ...

class Rank(Model, BaseId):
    name: str = String(max_length=100, unique=True)
    class Meta(BaseMeta):
        ...



# *-------------------- Base --------------------* #

class User(Model, BaseId):
 
    username: str = String(max_length=250, unique=True,sql_nullable=False,nullable=True)   
    givenName: str = String(max_length=250, sql_nullable=False,nullable=True )
    sn: str = String(max_length=100,sql_nullable=False,nullable=True)    
    telephoneNumber: Optional[str] = String(max_length=100, sql_nullable=True,nullable=True)
    phone: Optional[str] = String(max_length=50,sql_nullable=True, nullable=True)
    email: Optional[str] = String(max_length=250, unique=True,sql_nullable=True, nullable=True)
    otdel: Otdel = ForeignKey(Otdel,sql_nullable=True, nullable=True, related_name = "otdel_user")
    department: Department = ForeignKey(Department, nullable=True, sql_nullable=True, related_name = "department_user")
    organization:Organization=ForeignKey(Organization)
    position: Position = ForeignKey(Position, nullable=True,sql_nullable=True,)    
    physicalDeliveryOfficeName: Optional[str]=String(max_length=100, sql_nullable=True, nullable=True)    
    # hardskills: Optional[list[UserHardSkill]] = ManyToMany(HardSkill,through=UserHardSkill)
    # softskills: Optional[list[UserSoftSkill]] = ManyToMany(SoftSkill,through=UserSoftSkill)
    avatar=Text(nullable=True,default="/static/default/avatardef.png")
    rank: Rank = ForeignKey(Rank,nullable=True,sql_nullable=True)
    active: bool = Boolean(default=True)
    superuser: bool = Boolean(default=False)
    # ! ВОЗможно потом сделаем проверку по последнему входу - так будет ясно, надо-ли обновлять пользователя в AD
    # last_login: Optional[datetime]= DateTime(default=datetime.now())
    @property_field
    def fullname(self)-> str:
        return f'{self.sn} {self.givenName}'
        
    class Meta(BaseMeta):
        include_props_in_dict = True
        ...





# !-------------------- Project --------------------! # 
# *-------------------- Foreign Key --------------------* #    

class DocType(Model, BaseId):
    class Meta(BaseMeta):
        ...
    name:str = String(max_length=100,unique=True)
    

class ProjectStatus(Model, BaseId):
    class Meta(BaseMeta):
        tablename: str = "projectstatuses"
    name:str = String(max_length=100,unique=True, sql_nullable=False,nullable=True)


class ProjectType(Model, BaseId):
    class Meta(BaseMeta):
        ...
    name:str = String(max_length=100,unique=True,sql_nullable=False,nullable=True)

# *-------------------- Base --------------------* #

class Projectrole(Model, BaseId):
    class Meta(BaseMeta):
        ...
    name:str = String(max_length=100,unique=True,sql_nullable=False,nullable=True)



class Project(Model, BaseId):

    class Meta(BaseMeta):
        ...
    name: Optional[str] = String(max_length=255, sql_nullable=True,nullable=True)    
    longname: Optional[str] = String(max_length=500, sql_nullable=True,nullable=True)
    status: Optional[ProjectStatus] = ForeignKey(ProjectStatus,nullable=True, sql_nullable=True)   
    author: User = ForeignKey(User, related_name = "author_user",sql_nullable=False,nullable=True) 
    datestart: Optional[date] = Date(sql_nullable=True,nullable=True, default=date.today())
    dateend: Optional[date] = Date(sql_nullable=True,nullable=True, default=date.today())
    lastchanged: Optional[datetime] = DateTime(nullable=True)
    ptype: Optional[ProjectType] = ForeignKey(ProjectType)
    difficult: int= Integer(default=3)
    info:  Optional[JSON]=JSON(nullable=True, sql_nullable=True) 
    



class ProjectUser(Model, BaseId):
    class Meta(BaseMeta):
        constraints = [UniqueColumns("project","user","role")]
        ...
    user: User = ForeignKey(User)   
    project: Project = ForeignKey(Project, related_name="user_project") 
    role: Projectrole =ForeignKey(Projectrole)
    involved:Optional[Boolean] = Boolean(default=False)
    percent: Optional[int] = Integer(sql_nullable=True,nullable=True, default=0)

class ChatUser(Model, BaseId):
    class Meta(BaseMeta):
        ...
        
    ...

class Chat(Model, BaseId):
    class Meta(BaseMeta):
        constraints = [UniqueColumns("level","parent")]
        ...
    name: str = Text(nullable=True)    
    users: Optional[list[ProjectUser]] = ManyToMany(User, through=ChatUser, related_name = "chat_x_user") 
    level: int= Integer(default=0,minimum=0, maximum=4, nullable=True)
    # Проект -1, задача - 2, работа = 3, поручение 4
    parent: int=Integer(minimum=0,nullable=True)
    admin: User = ForeignKey(User,nullable=True)
    



class ChatMessage(Model,BaseId):
    class Meta(BaseMeta):
        ...
    chat: Chat = ForeignKey(Chat, related_name="chat_message", ondelete="CASCADE")
    sender: User = ForeignKey(User)
    text: str = Text()
    messagetime: Optional[datetime]= DateTime(default=datetime.now)






# *-------------------- Documentation --------------------* #

    



class Documentation(Model, BaseId):

    class Meta(BaseMeta):
        ...
    project: Project = ForeignKey(Project, related_name="project_doc") 
    doctype: DocType =  ForeignKey(DocType)
    docnumber: Optional[str]= String(max_length=100, nullable=True)
    created: datetime = DateTime()
    vrersion = JSON()    
    comment:str = Text(nullable=True)
    approved: int= Integer(default=0,minimum=0, maximum=4)
    approver: User = ForeignKey(User,nullable=True)
    approvedtime: Optional[datetime]= DateTime(nullable=True)
    path: Optional[str]= String(max_length=400, nullable=True)
# согласованность: 0 = не утверждено, 1 -отправлено на утверждение, 2 - утверждено

class DocUser(Model,BaseId):
    class Meta(BaseMeta):
        ...
    user: User = ForeignKey(User) 
    comment:str = Text(nullable=True)
    accepted: int= Integer(default=0,minimum=0, maximum=4)
    acceptedtime: Optional[datetime]= DateTime(nullable=True)
    doc: Documentation = ForeignKey(Documentation, related_name="doc_user", ondelete="CASCADE") 



# *-------------------- History --------------------* #

class HistoryAction(Model, BaseId):
    class Meta(BaseMeta):
        ...
    name: str = String(max_length=100,unique=True)


# !-------------------- Task --------------------! # 
# *-------------------- Foreign Key --------------------* #

class TaskStatus(Model, BaseId):
    class Meta(BaseMeta):
        tablename: str = "taskstatuses"
    name:str = String(max_length=100,unique=True)

class TaskStage(Model, BaseId):
    class Meta(BaseMeta):
        ...
    name:str = String(max_length=500,unique=True)

# *-------------------- Base --------------------* #


class Task(Model, BaseId):
    class Meta(BaseMeta):
        ...
    parent: Project = ForeignKey(Project, related_name = "project_task",sql_nullable=True, nullable=True, ondelete="CASCADE")
    longname: Optional[str] = String(max_length=500, sql_nullable=True,nullable=True)
    name: Optional[str] = String(max_length=500, sql_nullable=True, nullable=True)
    status: TaskStatus = ForeignKey(TaskStatus, sql_nullable=True,nullable=True,)
    description: Optional[Text] = Text(nullable=True)
    datestart: Optional[date] = Date(nullable=True)
    dateend: Optional[date] = Date(nullable=True)   
    responsible: Optional[User] = ForeignKey(User, nullable=True, related_name = "responsible_user")   
    lastchanged: Optional[datetime] = DateTime(default=datetime.now)
    difficult: int= Integer(default=3)
    # comment: Optional[JSON]=JSON(nullable=True,default=[]) 


class Work(Model, BaseId):
    class Meta(BaseMeta):
        ...
    parent: Task = ForeignKey(Task, related_name = "task_work", ondelete="CASCADE")
    name: Optional[str] = String(max_length=500, sql_nullable=False,nullable=True)
    longname: Optional[str] = String(max_length=500, sql_nullable=True,nullable=True)
    status: TaskStatus = ForeignKey(TaskStatus,  sql_nullable=True,nullable=True)
    responsible: User = ForeignKey(User, nullable=True, related_name = "work_responsible_user")
    description: Optional[Text] = Text(nullable=True)
    datestart: Optional[date] = Date(nullable=True)
    dateend: Optional[date] = Date(nullable=True)
    lastchanged: Optional[datetime] = DateTime(default=datetime.now())
    difficult: int= Integer(default=3)
    # comment: Optional[JSON]=JSON(nullable=True,default=[]) 



# !-------------------- Assignment --------------------! #
# *-------------------- Foreign Key --------------------* #

class AssignmentStatus(Model, BaseId):
    class Meta(BaseMeta):
        tablename: str = "assignmentstatuses"
    name: str = String(max_length=100,unique=True)

# *-------------------- Base --------------------* #

class Assignment(Model, BaseId):
    class Meta(BaseMeta):
        ...
    author: User = ForeignKey(User, related_name="assignment_author",nullable=True)
    parent = ForeignKey(Work, related_name="work_assignment", ondelete="CASCADE", sql_nullable=False,nullable=True)
    name: str = String(max_length=255, sql_nullable=False,nullable=True)
    longname: Optional[str] = String(max_length=500, sql_nullable=True,nullable=True)
    responsible: User = ForeignKey(User,nullable=True, related_name = "ass_responsible_user")
    status: Optional[AssignmentStatus] = ForeignKey(AssignmentStatus, sql_nullable=False,nullable=True)
    datestart: Optional[date] = Date(nullable=True)
    dateend: Optional[date] = Date(nullable=True)
    timeneeded: Optional[int] = Integer(default=0)
    lastchanged: Optional[datetime] = DateTime(default=datetime.now())
    description: Optional[str] = Text(nullable=True)
    getstarted:Optional[datetime] = DateTime(nullable=True)
    difficult: int= Integer(default=3)
    info:  Optional[JSON]=JSON(nullable=True, sql_nullable=True) 
    # comment: Optional[JSON]=JSON(nullable=True,default=[]) 


# *-------------------- Files --------------------* #
class ProjectHistory(Model, BaseId):

    class Meta(BaseMeta):
        ...
    
    author: User = ForeignKey(User)
    info:  Optional[JSON]=JSON(nullable=True, sql_nullable=True)  
    project: int= Integer()
    task: int= Integer(nullable=True, sql_nullable=True) 
    work: int= Integer(nullable=True, sql_nullable=True)
    assignment: int= Integer(nullable=True, sql_nullable=True)
    action: HistoryAction = ForeignKey(HistoryAction)    
    createdate: datetime = DateTime(default=datetime.now)
    level:int=Integer(default=1)
    comment: Optional[Text] = Text(nullable=True, sql_nullable=True) 


class Projectfile(Model, BaseId):
    class Meta(BaseMeta):
        ...
    project:Project=ForeignKey(Project, nullable=True,   related_name='project_files')
    task:Task = ForeignKey(Task,nullable=True, related_name='task_files')
    work:Work=ForeignKey(Work,nullable=True, related_name="work_files")
    assignment: Assignment = ForeignKey(Assignment, nullable=True, related_name="assignment_files")
    sender: User = ForeignKey(User)
    datetime: datetime = DateTime()
    filepath: str = Text()
    visible:str=String(max_length=5,nullable=True,)
    counter:int=Integer(sql_nullable=True,default=0)

class ProjectCheckpoint(Model, BaseId):
    class Meta(BaseMeta):
        ...
    project:Project=ForeignKey(Project, nullable=True,  related_name='project_checkpoints')
    checkpoint: date = Date(nullable=True)

class UserRating(Model,BaseId):
    class Meta(BaseMeta):
        ...
    user: User = ForeignKey(User, related_name = "user_score",sql_nullable=False,nullable=True)
    rating: int= Integer(default=0)
    level: int=Integer(default=0)
    project:Project=ForeignKey(Project, nullable=True,   related_name='project_score')
    task:Task = ForeignKey(Task,nullable=True, related_name='task_score')
    work:Work=ForeignKey(Work,nullable=True, related_name="work_score")
    assignment: Assignment = ForeignKey(Assignment, nullable=True, related_name="assignment_score")
    author: User = ForeignKey(User, related_name = "user_authorrating",sql_nullable=False,nullable=True)
    createdate: datetime = DateTime(default=datetime.now)

# !-------------------- Event --------------------! #
