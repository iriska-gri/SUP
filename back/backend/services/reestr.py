from sqlalchemy import select, func, or_,case, literal_column, distinct

from conf.sessions import database
from ormar import or_ as orm_or
from services.redis_key import *
from orm.models import *
from services.rediskeyhelper.project.query import Projectquery as PQ
from services.rediskeyhelper.project.buildier import ProjectBuildier
class ReestrService():
    # @classmethod
    # async def get_assignments(cls,userid,is_superuser, parentid=False):
    #     assignment = Assignment.Meta.table
    #     tsk = Task.Meta.table
    #     work = Work.Meta.table
    #     assignmentStatus =  AssignmentStatus.Meta.table 
    #     filterparent=True if not parentid else (assignment.c.parent == parentid)
    #     q = (
    #             select(assignment.c.id, assignment.c.name, assignment.c.parent.label("work"),
                
    #              assignmentStatus.c.name.label("status"), assignment.c.status.label("status__id"),assignment.c.lastchanged, assignment.c.dateend,
    #              work.c.parent.label("task"), tsk.c.parent.label("project"))                
    #             .where(filterparent)
    #             .join(assignmentStatus, assignmentStatus.c.id==assignment.c.status)
    #             .join(work, work.c.id == assignment.c.parent)
    #             .join(tsk, tsk.c.id == work.c.parent)

    #             .select_from(assignment).group_by(assignment.c.id, assignmentStatus.c.id, tsk.c.id,work.c.id)
    #     )
       
    #     return [dict(x) for x in await database.fetch_all(q)]

    @classmethod
    async def give_list_reestr(cls, userid:int,typ:str, is_superuser=False,filters={}):
        # user_project__user__sn__startswith = "Орех", user_project__role=2
        print(filters,"FIIIIIILTERS")
        for [key,val] in filters.items():
            if key in ['dateend__lte','dateend__gte','datestart__lte','datestart__gte']:
                filters[key]= datetime.strptime(val, '%Y-%m-%d').date()
        # (let[key,val] of Object.entries(payload))
        # {
        #     if ( ['dateend__lte','dateend__gte','datestart__lte','datestart__gte'].includes(key))  payload[key] = new Date(val)

        # }
        dtn = datetime.now()
        if typ=="projects":

            projects = await Project.objects.prefetch_related(["status","project_task","project_task__status","project_task__responsible","user_project","user_project__user","user_project__role"]).filter(**filters).all()
            # print(projects)
            
            return [querytoPydantic(ProjectReestrSchema,x) for x in projects] 
            
        elif typ=="tasks":
            tasks =   await Task.objects.prefetch_related(["status","task_work","parent","responsible","task_work__status","task_work__responsible"]).filter(**filters).all()
            # print(tasks)
            
            return [querytoPydantic(TaskReestrSchema,x) for x in tasks] 
        elif typ=="works":
            works = await Work.objects.prefetch_related(["status","parent","work_assignment","responsible","work_assignment__status","work_assignment__responsible"]).filter(**filters).all()
            
            return [querytoPydantic(WorkReestrSchema,x) for x in works]
        else:
            assgn = await Assignment.objects.prefetch_related(["status","parent","parent__parent","parent__parent__parent","responsible"]).filter(**filters).all()
           
            dt=[]
            for x in assgn:
                b=querytoPydantic(AssignmReestrSchema,x)
                b['parent']['parent']={'parent':{'id': x.parent.parent.parent.id},
                                        "id": x.parent.parent.id                   }
                dt.append(b)
            print(datetime.now()-dtn)
            return dt
        # print(userid, typ)
        # if typ =="assignments":

        #     return await cls.get_assignments(userid,is_superuser)

        # project = Project.Meta.table        
        # pruser = ProjectUser.Meta.table   
        # users = User.Meta.table    
        # departm = Department.Meta.table
        # r={
        #     'projects':{
        #         "main":Project.Meta.table,
        #         "sub":Task.Meta.table, 
        #         "m_status":ProjectStatus.Meta.table,
        #         "s_status":TaskStatus.Meta.table,
        #         "relation":'project',
        #         'completed':5,
        #         "filter_user": True,
        #         "joinuser": ProjectUser.Meta.table
        #         # if is_superuser else or_(pruser.c.user == userid, project.c.author == userid)
        #     },
        #     'tasks':{
        #         "main":Task.Meta.table,
        #         "sub":Work.Meta.table, 
        #         "m_status":TaskStatus.Meta.table,
        #         "s_status":TaskStatus.Meta.table,
        #         "relation":'project',
        #         'completed':5,
        #         "filter_user": True 


        #     },
        #     'works':{   
        #         "main":Work.Meta.table,
        #         "sub":Assignment.Meta.table, 
        #         "m_status":TaskStatus.Meta.table,
        #         "s_status":AssignmentStatus.Meta.table,
        #         "relation":'project',
        #         'completed':5,
        #         "filter_user": True,
        #         "parent":Task.Meta.table 
                      

        #     }
        # }
        
       
        # completed_t = (
        #     select(func.count(distinct(r[typ]["sub"].c.id)))
        #     .outerjoin(r[typ]["s_status"])
        #     .where(r[typ]["s_status"].c.id == r[typ]["completed"])
        #     .where(r[typ]["sub"].c.parent == r[typ]["main"].c.id)
        #     .select_from(r[typ]["sub"]).scalar_subquery().correlate(r[typ]["main"])
        # )
        # # print(completed_t)
        # # filter_user = True if is_superuser else or_(pruser.c.user == userid, project.c.author == userid, project.c.leader==userid)
        # appender =[]
        # grouper=[]
        # joiner=[]
        # if typ == "works":
        #     appender = [r[typ]["parent"].c.id.label("task"), r[typ]["parent"].c.parent.label("project")]
        #     grouper = [r[typ]["parent"].c.id]
        #     q = (
        #         select(
        #             func.count(distinct(r[typ]["sub"].c.id)).label("all"),
        #             completed_t.label("completed"),
        #             r[typ]["main"].c.id, r[typ]["main"].c.name,                
        #             r[typ]["m_status"].c.name.label("status"), 
        #             r[typ]["m_status"].c.id.label("status_id"),
        #             r[typ]["main"].c.lastchanged,  r[typ]["main"].c.dateend,
        #             *appender
        #         ).where(r[typ]["filter_user"])
        #         .outerjoin(r[typ]["m_status"], r[typ]["main"].c.status == r[typ]["m_status"].c.id)
        #         .outerjoin(r[typ]["sub"], r[typ]["sub"].c.parent == r[typ]["main"].c.id)
        #         .outerjoin(pruser, pruser.c[r[typ]['relation']] == r[typ]["main"].c.id)
        #         .outerjoin(*[r[typ]["parent"],r[typ]["parent"].c.id==  r[typ]["main"].c.parent] if typ == "works" else [])  
                
        #         .select_from(r[typ]["main"]).group_by(r[typ]["main"].c.id, r[typ]["m_status"].c.id, *grouper)
        #     )
        # elif typ=="tasks":
        #     appender = [r[typ]["main"].c.parent] 
        #     q = (
        #         select(
        #             func.count(distinct(r[typ]["sub"].c.id)).label("all"),
        #             completed_t.label("completed"),
        #             r[typ]["main"].c.id, r[typ]["main"].c.name,                
        #             r[typ]["m_status"].c.name.label("status"), 
        #             r[typ]["m_status"].c.id.label("status_id"),
        #             r[typ]["main"].c.lastchanged,  r[typ]["main"].c.dateend,
        #             *appender
        #         ).where(r[typ]["filter_user"])
        #         .outerjoin(r[typ]["m_status"], r[typ]["main"].c.status == r[typ]["m_status"].c.id)
        #         .outerjoin(r[typ]["sub"], r[typ]["sub"].c.parent == r[typ]["main"].c.id)
        #         .outerjoin(pruser, pruser.c[r[typ]['relation']] == r[typ]["main"].c.id)
                 
                
        #         .select_from(r[typ]["main"]).group_by(r[typ]["main"].c.id, r[typ]["m_status"].c.id)
        #     )
        # else:
        #      q = (
        #         select(
        #             func.count(distinct(r[typ]["sub"].c.id)).label("all"),
        #             completed_t.label("completed"),
        #             r[typ]["main"].c.id, r[typ]["main"].c.name,                
        #             r[typ]["m_status"].c.name.label("status"), 
        #             r[typ]["m_status"].c.id.label("status_id"),
        #             r[typ]["main"].c.lastchanged,  r[typ]["main"].c.dateend,
                    
                 
        #         ).where(r[typ]["filter_user"])
        #         .outerjoin(r[typ]["m_status"], r[typ]["main"].c.status == r[typ]["m_status"].c.id)
        #         .outerjoin(r[typ]["sub"], r[typ]["sub"].c.parent == r[typ]["main"].c.id)           
               
        #         .select_from(r[typ]["main"]).group_by(r[typ]["main"].c.id, r[typ]["m_status"].c.id)
        #      )
       
        # res = [dict(x) for x in await database.fetch_all(q)]
        # for x in res:
        #     nude = {}
        #     nude['users']= await PQ.get_nudeprojectusers(x['id'])            
        #     a = await ProjectBuildier.build_proj_persons(nude)
        #     x["users"]= a["users"]
       
        # return res

    # @classmethod
    # async def give_list_child(cls, userid,parent__type, parentid, is_superuser=False):
        
    #     # print("LIST_CHILD", parent__type,)
    #     nowview = Task.Meta.table
    #     childv = Work.Meta.table
    #     nowviewstatus = TaskStatus.Meta.table
    #     childvStatus =  TaskStatus.Meta.table     
    #     task = Task.Meta.table
    #     proj = Project.Meta.table
    #     if parent__type=="projects":
    #         pass
    #     #     if not is_superuser:
    #     #         print(await ProjectUser.objects.filter(user=userid, project=parentid).all())
    #     #         if not await ProjectUser.objects.filter(user=userid, project=parentid).exists():
    #     #             # pass
    #     #             return None
            
        
    #     elif parent__type=="tasks":
    #         # if not is_superuser:
    #         #     if not await Task.objects.select_related(["parent__users"]).filter(orm_or(users__id=userid, author=userid, rp=userid), id=parentid).exists():
    #         #         return None
    #         nowview = Work.Meta.table
    #         childv = Assignment.Meta.table
    #         nowviewstatus = TaskStatus.Meta.table
    #         childvStatus =  AssignmentStatus.Meta.table    
            
           
    #     elif parent__type=="works":
    #         return await cls.get_assignments(userid,is_superuser, parentid)

    #     else:
    #         # if not is_superuser:
    #         #     if not await Task.objects.filter(users__id=userid, id=parentid).exists():
    #         #         return None
    #         return await cls.get_assignments(userid,is_superuser, parentid)



    #     completed_work = (
    #             select(func.count(distinct(childv.c.id))).join(childvStatus)
    #             .where(childv.c.parent == nowview.c.id)
    #             .where(childvStatus.c.name =="Исполнена")            
    #             .select_from(childv).scalar_subquery().correlate(nowview)
    #         )
    #     if parent__type=="projects":
            
    #         q = (
    #                 select(
    #                     func.count(distinct(childv.c.id)).label("all"), completed_work.label("completed"), nowview.c.id, nowview.c.name, nowviewstatus.c.name.label("status"), nowviewstatus.c.id.label("status_id"), nowview.c.dateend,
    #                     nowview.c.parent.label("task"),task.c.parent.label("project")
    #                 )
    #                 .where(nowview.c.parent == parentid)
    #                 .outerjoin(nowviewstatus, nowview.c.status == nowviewstatus.c.id)
    #                 .outerjoin(childv, childv.c.parent == nowview.c.id)                    
    #                 .select_from(nowview).group_by(nowview.c.id, nowviewstatus.c.id, task.c.id)
    #             )   
    #     else:
            
    #         q = (
    #                 select(
    #                     func.count(distinct(childv.c.id)).label("all"), completed_work.label("completed"), nowview.c.id, nowview.c.name, nowviewstatus.c.name.label("status"), nowviewstatus.c.id.label("status_id"), nowview.c.dateend,
    #                     nowview.c.parent.label("task"),task.c.parent.label("project")
    #                 )
    #                 .where(nowview.c.parent == parentid)
    #                 .outerjoin(nowviewstatus, nowview.c.status == nowviewstatus.c.id)
    #                 .outerjoin(childv, childv.c.parent == nowview.c.id)
    #                 .outerjoin(task, task.c.id==  nowview.c.parent)
                
    #                 .select_from(nowview).group_by(nowview.c.id, nowviewstatus.c.id, task.c.id)
    #             )   
      
      
    #     return [dict(x) for x in await database.fetch_all(q)]
        


