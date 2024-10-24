from orm.models import *
import json
dictofkeys={
1:{"name":"Проект",
    "longname":"Полное название проекта",
    "responsible":"Ответственный",
    'datestart':"Начало",
    'dateend': 'Окончание',
    'description': 'Описание',
    'status':"Статус",
    'filepath':"Загружен",
    'filedel':"Удален",
    'iditit': "Результат"
                },
2:{"name":"Задача",
    "longname":"Полное название задачи",
    "responsible":"Ответственный",
    'datestart':"Начало",
    'dateend': 'Окончание',
    'description': 'Описание',
    'status':"Статус",
    'filepath':"Загружен",
    'filedel':"Удален",
    'iditit': "Результат"
                },
3:{"name":"Работа",
"longname":"Полное название работы",
    "responsible":"Ответственный",
    'datestart':"Начало",
    'dateend': 'Окончание',
    'description': 'Описание',
    'status':"Статус",
    'filepath':"Загружен",
    'filedel':"Удален",
    'iditit': "Результат"
                },
4:{"name":"Поручение",
    "longname":"Полное название поручения",
    "responsible":"Ответственный",
    'datestart':"Начало",
    'dateend': 'Окончание',
    'description': 'Описание',
    'status':"Статус",
    'filepath':"Загружен",
    'filedel':"Удален",
    'iditit': "Результат",
    'difficult':"Сложность"

                }
}


def foreignkeytoint(data,arr=['status','responsible','type']):
    """Переводит словарь с подобъектами (форины при орбновлении)

    Args:
        data (dict): {b:c,d:{id:6}}
        arr (list): Список ключей, которые надо разобрать
    Returns:
        _dict_: {b:c,d:6}
    """

    for [key,val] in data.items():
        if key in arr and val:            
            data[key]=val['id']
    return data


def exclude_keys(dictionary, keys):
    return {
        key: value for key, value in dictionary.items()
        if key not in keys
    }







def get_date_from_str(date):
    month_list = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря']
    try:
        date_list = date.split('-')
        return f'"{date_list[2]}" {month_list[int(date_list[1]) - 1]} {date_list[0]} г.'
    except Exception:
        return '"    " _______________________ 20_____г.'
   


async def historyDataCreator(user,data,level,action,projectid,taskid=None,workid=None,assid=None):
    """Создание записи в таблицу истории

    Args:
        data (_dict_): Новые данные 
        level (_int_): Уровень 1-4 Проект-поручение
        action (_int_): Действие
        projectid (_int_): id проекта
        taskid (_type_, optional): ID задачи. Defaults to None.
        id (_type_, optional): ID поручения. Defaults to None.
    """
    tobasedict = {} 
    for (key,val) in data.items():
        if key in dictofkeys[level].keys():
            tobasedict[key]=val       

    await ProjectHistory.objects.create(author=user['id'],info=tobasedict,action=action,level=level, comment=data['comment'] if 'comment' in data.keys() else None, project=projectid,task=taskid,work=workid,assignment=assid)
    


def findrole(data, roleid):
    
    return list(filter(lambda user: user['role']['id'] == roleid, data))[0]