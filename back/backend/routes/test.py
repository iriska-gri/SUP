from fastapi import (
    APIRouter,
    Depends,
    status
)
from sqlalchemy import select, func, or_
from conf.sessions import database
from services.depends import AD
from orm.models import *
from orm.schema import *
# from conf.log import logger
from services.reestr import ReestrService
from datetime import timedelta
router = APIRouter(
    prefix='/test',
    tags=['Всяческое тестирование'], 
    
)


# async def geto_user(id: int, use
# AS = AD(ReestrService)
@router.post("/deleteeassignment",  status_code=status.HTTP_201_CREATED)
#  ! 
async def updateassignment(assignmentdel: int):
    old_assignment = await Assignment.objects.get(id = assignmentdel)
    if old_assignment.status.id in [1,3,4]:
        ...




@router.post("/updateassignment",  status_code=status.HTTP_201_CREATED)
#  ! 
async def updateassignment(assignment: AssignmentUpdate):
      
    old_assignment = await Assignment.objects.get(id = assignment.id)
    
    # Если попадает в статус "в работе"
    userchanged = False if (int(assignment.user.id)==int(old_assignment.user.id)) else True
    now = datetime.now()
    
    if old_assignment.status.id !=5:
        if int(assignment.status.id) == 2  and not userchanged:
            print(1)
            assignment.timeneeded = old_assignment.timeneeded
            assignment.datetimestart = now

        elif assignment.status.id==3 and userchanged:
            print(2)
            assignment.timeneeded = 0
            # Отправить в таблицу лузеров запись
            old_assignment.timeneeded = old_assignment.timeneeded + ((now - old_assignment.datetimestart).total_seconds())
            await AssignmentLoose.objects.create(**old_assignment.dict(exclude='id'))

        # Если на паузе
        elif assignment.status.id ==3 and not userchanged:
            print(3)
            assignment.datetimestart = now
            assignment.timeneeded = assignment.timeneeded + ((now - old_assignment.datetimestart).total_seconds())
        # Если в статус проверки
        elif assignment.status.id==4 and not userchanged:  
            print(4)
            
            assignment.timeneeded = assignment.timeneeded + ((now - old_assignment.datetimestart).total_seconds())
                    

        await old_assignment.update(**assignment.dict())
        return {"mess": old_assignment}
    else:
        return {"mess": "Поручение уже завершено"}
    
    


# @router.get("/getuser")
# #  ! 
# async def users():
#     users = await User.objects.values({"id", "first_name"})
    
#     print(users)
    
#     return {"mess": users}


@router.post("/createassignment",  status_code=status.HTTP_201_CREATED)
#  ! 
async def createassignment(assignment: AssignmentCreate):
    pr = await Assignment.objects.create(**assignment.dict())
    return {"mess": "ok"}





@router.get("/{userid}/{projectid}/{taskid}",  status_code=status.HTTP_201_CREATED)
#  ! 
async def get_task_list(userid: int, projectid:int):
    
    result = await ReestrService.give_list_tasks(userid, projectid)
    return {"mess": result}






# @router.get("/{userid}",  status_code=status.HTTP_201_CREATED)
#  ! 
# async def get_project_list(userid: int):
# #    ! Нужно создать задачу, только потом получится )
    
#     result = await ReestrService.give_list_projects(userid,'projects')
#     return {"mess": result}



@router.post("/deleteproj",  status_code=status.HTTP_201_CREATED)
#  ! 
async def del_project(projectid: int):
    await Project.objects.delete(id = projectid)
   
    print("-----!---------!------------!-")
    return {"mess": "Проект удален"}


@router.post("/updateproj",  status_code=status.HTTP_201_CREATED)
#  ! 
async def upd_my_project(project: ProjectUpdate):

    project_field_update = project.dict(exclude={'users'}, exclude_unset=True)
    if len(project_field_update.keys()) > 1:
        project_field_update["lastchanged"] = datetime.now()
        await Project(**project_field_update).update(project_field_update.keys())

    if "users" not in project.dict(exclude_unset=True):
        return {"mess": "Нет юзеров"}
    
    project_with_users = await Project.objects.select_related("users").fields(['id', 'users__id']).get(id=project.id)
    
    projectuser = project_with_users.users
    oldusers = {user.id for user in projectuser}
    currentusers = {user.id for user in project.users}

    for userid in oldusers.difference(currentusers):
        await projectuser.remove(User(id = userid, __pk_only__ = True))
        # "Вас исключили из проекта"

    for userid in currentusers.difference(oldusers):
        await projectuser.add(User(id = userid, __pk_only__ = True))
        # Вы добавлены в проект

    return {"mess": projectuser}




@router.post("/createtask",  status_code=status.HTTP_201_CREATED)
#  ! 
async def create_task(task: TaskCreate):
    newtask =task.dict(exclude={'users','id'})    
    ts = await Task.objects.create(**newtask)
    for user in task.users:  
        await ts.users.add(User(id = user.id, __pk_only__ = True))
    
    return {"mess": "ok"}
    

@router.post("/testWS",  status_code=status.HTTP_201_CREATED)
async def test():
    return await Project.objects.select_related([Project.leader,Project.status, Project.author]).fields(['leader__id','leader__username','status__name','author__middle_name']).all()


# "name": null,
#     "description": "string",
#     "customer": "string",
#     "datestart": null,
#     "dateend": null,
#     "lastchanged": "2022-10-23T12:18:19.237094",
#     "id": 1,
#     "leader": {
#       "username": "string",
#       "password": "$2b$12$arfIqIBkqltaQjWiz1Ubye4irECvFSxhdIECt1nS9g4boCwuTAo1e",
#       "first_name": "string",
#       "last_name": "string",
#       "middle_name": "string",
#       "innerphone": "string",
#       "phone": "string",
#       "email": "string",
#       "superuser": true,
#       "id": 1,
#       "eventchecklists": [],
#       "assignments": [],
#       "eventchats": [],
#       "eventfiles": [],
#       "assignmentlooses": [],
#       "notefiles": [],
#       "assignmentchats": [],
#       "user_x_user": [],
#       "author_canban": [],
#       "canbanuser_x_user": [],
#       "author": [],
#       "hardskills": [],
#       "visiblefor_x_user": [],
#       "leader_x_user": [],
#       "otdel": {
#         "id": 1
#       },
#       "leaves": [],
#       "responsible_user": [],
#       "rank": {
#         "id": 1
#       },
#       "position": {
#         "id": 1
#       },
#       "assignmentfiles": [],
#       "tasks": [],
#       "softskills": []
#     },
#     "users": [],
#     "projecthistorys": [],
#     "status": {
#       "id": 1
#     },
#     "documentations": [],
#     "project_task": [],
#     "author": {
#       "id": 1,
#       "canbanuser": null,
#       "eventuser": null,
#       "userhardskill": null,
#       "usersoftskill": null,
#       "projectuser": null,
#       "noteuser": null,
#       "taskuser": null
#     }
#   }











@router.post("/test",  status_code=status.HTTP_201_CREATED)
async def test():
    return await ReestrService.give_list_projects(1, is_superuser=True)    

# post = await Post(title="Test post").save() 
# await post.categories.create( name="Test category1",  postcategory={"sort_order": 1, "param_name": "volume"}, )

# @router.post('/auth/register', status_code=status.HTTP_201_CREATED, response_model=UserFull, tags=['Авторизация'])
# async def register(user_data: UserRegister, auth_service: AuthService = Depends(AS.serv)):
#     """ Регистрация пользователя """
 
#     return await auth_service.create(user_data)

# await ReestrService.get_list(params={"field":"", 'searchval':""})

# @router.post("/")
# async def Check_This_Out(user_data: BaseOtdel,        
#                         check_otdel: OtdelService=Depends()):        
#         name= await check_otdel.checkForeign(user_data.name.lower().title())
        
#         return  name

# #    , Authorize: AuthJWT = Depends()
# @router.get("/{id}")
# async def geto_user(id: int, user_id = Depends(currentuserID)):
   
#     # текущий ид пользователя
#     print("------------------------------")
#     print('current_user')
    
#     return {"field":'id',"searchval":'id'}


# async def receiver(websocket: WebSocket, user_id: int):
    
#     async for data in websocket.iter_json():
#         await broadcast.publish(channel=f"chatroom3", message=json.dumps(data))
#         await broadcast.publish(channel=f"chatroom4", message=json.dumps(data))


# async def sender(websocket: WebSocket, user_id: int):


#         async with broadcast.subscribe(channel=f"chatroom{user_id}") as subscriber:
#             async for event in subscriber:
#                 await websocket.send_text(event.message)
# class ConnectionManager:
#     def __init__(self):
#         self.active_connections: list[WebSocket] = []
    

#     async def connect(self, websocket: WebSocket):
#         await websocket.accept()
#         self.active_connections.append(websocket)
        

#     def disconnect(self, websocket: WebSocket):
#         self.active_connections.remove(websocket)

#     async def send_personal_message(self, message: str, websocket: WebSocket):
#         await websocket.send_text(message)

#     async def broadcast(self, message: str):
#         for connection in self.active_connections:           
#             await connection.send_text(message)

# STOPWORD = "STOP"


# async def reader(channel: aioredis.client.PubSub, websocket: WebSocket):
#     while True:
#         try:
#             async with async_timeout.timeout(1):
#                 message = await channel.get_message(ignore_subscribe_messages=True)
#                 if message is not None:
#                     if message["data"] == STOPWORD:
#                         print("(Reader) STOP")
#                         break
#                     # await manager.send_personal_message(f"You wrote:", websocket)
#                     await websocket.send_text(f"Client #1 says: {message}")
#                     print(f"(Reader) Message Received: {message}")
                    
#                 await asyncio.sleep(0.01)
#         except asyncio.TimeoutError:
#             pass
   # try:
        
    #     while True:
    #         data = await websocket.receive_json(mode="text")
    #         print(data)            
    #         print("отправлено")
        
            

    #         future = asyncio.create_task(reader(pubsub, websocket))

    #         await redis.publish("channel:1", json.dumps(data))
    #         await redis.publish("channel:2", "World")
    #         await redis.publish("channel:1", STOPWORD)

    #         await future
        
            
    # except WebSocketDisconnect:
    #     # manager.disconnect(websocket)
    #     # await manager.broadcast(f"Client # left the chat")
    #     print("foooooooooooooooooooooooooooooooooooooooooooo, disconnect")
    



# async def main():