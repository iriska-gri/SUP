from fastapi import (
    APIRouter,
    Depends,
    status
)
from services.wsservice import *
from services.depends import AD
from orm.models import *
from orm.schema import *
from datetime import datetime, date
router = APIRouter(
    prefix='/supogramm',
    tags=['Чаты'], 
    
)
from services.redis_key import *

# @router.post("/getchat",response_model=list[ChatList])
# async def getchat(chat:ChatParamsToGetIt):
    
#     res = await model[chat.type].objects.select_related(['sender','sender__position']).filter(parent=chat.id).all()
    
#     return res
@router.get("/getchat")
async def get_my_chatList(id:int):
   
    mychatlist = await ChatUser.objects.filter(user=id).fields(["chat"]).all()
    response = []
    
    response = await asyncio.gather(*[REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',a.chat.id,"mychatlist",{'func':'get_my_chatList'})) for a in mychatlist])
    
    return  response


async def get_unreaded(id:int):
    redis =await get_redis_pool()
    unreaded = await redis.hget(f"data:user/{id}", 'unreadedmessages')                
    unreaded = json.loads(unreaded) if unreaded is not None else []
    await redis.close()
    return unreaded



@router.post("/createchat")
async def createchat(data:dict, user):    
    users = set(data['users'])
    users.add(user['id'])
    
    newchat = await Chat.objects.create(name=data['name'],level=data['level'],parent=data['parent'],admin=user['id'])
    for x in list(users):
        u = await User.objects.get(id=x)
        await newchat.users.add(u)
    r = await REdSetter.updateKeyReturnChecker(REdSetterSettings('chatroom',newchat.id,"mychatlist",{'func':'get_my_chatList'}),True)    
   
    return r

@router.post("/delchat")
async def delchato(data, user):
    
    await ChatUser.objects.delete(chat=data['id'], user=user['id'])    
    await REdSetter.updateOneKeyReturnChecker(REdSetterSettings('data:chatroom',data['id'],"mychatlist",{'func':'leavechat', 'key':'users','user':user}),True)
    # await ChatMessage.objects.delete(chat=data['id'])
    # await Chat.objects.delete(id=data['id'])

    # return  await get_my_chatList(user['id'])





@router.post("/sendtochat")

async def sendtochat(data,user):
    newm = await ChatMessage.objects.create(chat=data['id'], text=data['text'], sender=user['id'])        
    n= await ChatMessage.objects.select_related(['sender','chat']).get(id=newm.id)

    mes = querytoPydantic(LchMesWithParent, n)

    leta =await REdSetter.updateOneKeyReturnChecker(REdSetterSettings('data:chatroom',data['id'],"mychatlist",{'func':'updatechatsnapshot',"key":"lastmessage",'mes':mes}),True) 
   

    return mes
    
async def updateusers(data,user):
    
    cht= await Chat.objects.select_related(["users"]).get(id=data['id'])
    oldadmin=cht.admin
    nameact = []
    if "name" in data.keys():
        cht.name=data['name']
        nameact = [Rs_Worker.redis_key_key_setter(RedisSettings(f'data:chatroom/{data["id"]}',data=data['name'],key="name"))]
    cht.admin=data['admin']
    await cht.update()
 

    oldusers = set([x.id for x in cht.users])
    currentusers = set(data['users'])
    deletion = list(oldusers.difference(currentusers))
    for userid in oldusers.difference(currentusers):
        u = await User.objects.get(id=userid)
        await cht.users.remove(u)
    # await ChatUser.objects.filter(chat=data['id'], user__in=deletion).delete()
    
    
    
    for userid in currentusers.difference(oldusers):
        u = await User.objects.get(id=userid)
        await cht.users.add(u)
    

    
    await asyncio.gather( *nameact, Rs_Worker.redis_key_key_setter(RedisSettings(f'data:chatroom/{data["id"]}',data=[querytoPydantic(ChatUserschema, x) for x in list(cht.users)],key="users")),
    Rs_Worker.redis_key_key_setter(RedisSettings(f'data:chatroom/{data["id"]}',data={"id":data['admin']},key="admin")) 
    
     )
   
    return {'del' :deletion,"added":currentusers}

async def addinguser(data,user):
    user = await User.objects.get(id=data['user'])
    cht= await Chat.objects.select_related(["users"]).get(id=data['chat'])
    
    if user.id not in [x.id for x in cht.users]:
        await cht.users.add(user)
        await REdSetter.updateOneKeyReturnChecker(REdSetterSettings('data:chatroom',data['chat'],"mychatlist",{'func':'addchat', 'key':'users','user':user}),True)
    
    return user


async def ireadedIt(data,user):
    return await REdSetter.updateOneKeyReturnChecker(REdSetterSettings('data:user',user['id'],"mychatlist",{'func':'ireadIt', 'key':'unreadedmessages', 'chatroom': data}),True)
    
async def getprev(data,user):

    mesg = await ChatMessage.objects.select_related(['sender']).filter(chat=data['chat']).order_by("-id").paginate(page=data['offset'],page_size=20).all()
    tenmes = []
    for x in mesg:
        tenmes.append(querytoPydantic(LastChatMessage, x))
    tenmes.reverse()       
  
    return tenmes



async def delmessager(data,user):
    #   удаление сообщения
  

    tsk= [REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',data['chat'],"mychatlist",{'func':'get_my_chatList'}),True) ,ChatMessage.objects.delete(id=data['id'])]

    # await ChatMessage.objects.delete(id=data['message'])
    # newten = await REdSetter.updateKeyReturnChecker(REdSetterSettings('data:chatroom',data['chat'],"mychatlist",{'func':'get_my_chatList'}),True) 
    # print(newten['users'])   
    newten = await asyncio.gather(*tsk)
    # print(newten)
    await  asyncio.gather(*[REdSetter.updateOneKeyReturnChecker(REdSetterSettings('data:user',x['id'],"mychatlist",{'func':'updateunreaded','messid':data['id'], 'key':'unreadedmessages'}),True)  for x in newten[0]['users']])