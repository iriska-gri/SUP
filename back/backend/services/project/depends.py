from fastapi import (
    Depends,
    Query,
    status,
    WebSocket,
)
from orm.models import *
from orm.schema import *
from services.wsservice import *


history_dict={
    "name": {"text":"Имя проекта","getid":False, },
    "datestart": {"text":"Дата начала:","getid":False},
    'dateend':{"text":"Дата окончания","getid":False},
    'status':{"text": "Статус ","getid":True, "sch":ProjectStatus},
    'secretary':{"text":"Секретарь","getid":True, "sch":User},
    'rp': {"text":"Руководитель","getid":True, "sch":User},
    'director':{"text": "Директор","getid":True, "sch":User},
    'coordinator': {"text":"Координатор", "getid":True,"sch":User},
    'ptype': {"text":"Тип","getid":True, "sch":ProjectType},
    'pcode': {"text":"Код","getid":False },


}





class PD:
    @classmethod
    async def getproject(id:int, project:ProjectGet):
        return await ProjectGet()

    async def checkdiff(updpr, pr ,user):
#         {'name': 'Информационная система Управления Проектами', 'datestart': datetime.date(2022, 12, 15), 'dateend': datetime.date(2022, 12, 31), 'status': 1, 'author': 421, 
# 'secretary': 438, 'rp': 424, 'lastchanged': datetime.datetime(2022, 12, 19, 15, 6, 2, 459781), 'director': 438, 'coordinator': None, 'ptype': 2, 'pcode': 'string', 'id': 11}
        for [key,val] in pr.dict().items():
            oldval=None
            if key not in ['lastchanged','id','author','users','watchers']:
                if key in updpr.keys():
                    if history_dict[key]["getid"] and val:
                        # print(type(val))
                        oldval = val['id']
                        
                    elif val and not history_dict[key]["getid"]:
                        oldval = val
                    else:
                        oldval=val

                    if oldval!=updpr[key]:
                        if history_dict[key]["getid"] and history_dict[key]["sch"]==User :

                            ou = await User.objects.get_or_none(id=oldval)
                            ou = f'{ou.sn} {ou.givenName}' if ou else "Не назначен"
                            nu = await User.objects.get_or_none(id=updpr[key]) 
                            nu = f'{nu.sn} {nu.givenName}' if nu else "Не назначен"
                            # await ProjectHistory.objects.create(**{"level":1, "author": user,"project": pr.id,"action":2, "text": f"{history_dict[key]['text']} {ou} => {nu}"})
                        elif history_dict[key]["getid"]:
                            ov =  await history_dict[key]['sch'].objects.get_or_none(id=oldval)
                            ov= ov.name if ov else "Не назначен"
                            nv =  await history_dict[key]['sch'].objects.get(id=updpr[key]) 
                            nv= nv.name if nv else "Не назначен"
                            # await ProjectHistory.objects.create(**{"level":1, "author": user,"project": pr.id,"action":2, "text": f"{history_dict[key]['text']} {ov} => {nv}"})

                        # else:
                            # await ProjectHistory.objects.create(**{"level":1, "author": user,"project": pr.id,"action":2, "text": f"{history_dict[key]['text']} {oldval} => {updpr[key]}"})

    async def get_doclist(id:int):
       

        docs = await Documentation.objects.filter(project=id).select_related(["doctype","doc_user","doc_user__user","doc_user__user__position","approver","approver__position"]).order_by(["doctype","-created"]).fields(["id","doctype","doc_user","created","approved","approver","approvedtime","docnumber"]).all()
        res, users=[],[]
        for el in docs:
            users=[]
            for x in el.doc_user:
                
                dt = querytoPydantic(UserProjectFullName,x.user)
                dt['accepted']=x.accepted
                users.append(dt)
            

            resic = querytoPydantic(AllProjectDocumentation,el)
            resic['accepters']=users
            res.append(resic)
        return res