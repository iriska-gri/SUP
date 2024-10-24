import datetime


created = datetime.datetime.today()
incoming = {'longname': 'Информационная система управления проектами', 
                'tasks': [{'dateend': '2023-09-15', 'datestart': '2023-09-08', 'description': 'wdqw', 'difficult': 2, 'id': 71, 'longname': 'za', 'name': 'Документация', 'parent': {'id': 63}, 'responsible': {'givenName': 'Виталий Владимирович', 'id': 421, 'sn': 'Сапунов'}, 'status': {'id': 2, 'name': 'Исполнение'}, 
                'task_work': [{'dateend': '2023-09-09', 'datestart': '2023-09-08', 'description': 'lj.jk', 'difficult': 3, 'id': 93, 'longname': '', 'name': 'Тестирование', 'parent': {'id': 71, 'parent': {'id': 63}}, 'responsible': {'givenName': 'Виталий Владимирович', 'id': 421, 'sn': 'Сапунов'}, 'status': {'id': 5, 'name': 'Завершена'}, 'work_assignment': [], 'comment': {'text': 'не принято', 'author': {'avatar': '/static/default/avatardef.png', 'id': 421, 'sn': 'Сапунов'}}, 'planning': '2023-09-13'}],
                'comment': {'text': 'ujnjj', 'author': {'avatar': '/static/default/avatardef.png', 'id': 421, 'sn': 'Сапунов'}}, 
                'planning': '2023-09-15'}, {'dateend': '2023-08-30', 'datestart': '2023-08-11', 'description': 'sdfsdfsdf', 'difficult': 3, 'id': 72, 'longname': '123', 'name': 'Новая задача123', 'parent': {'id': 63}, 'responsible': {'givenName': 'Виталий Владимирович', 'id': 421, 'sn': 'Сапунов'}, 'status': {'id': 1, 'name': 
                'Запланирована'}, 'task_work': [], 'comment': {'text': 'Не предоставлен', 'datet': ''}}], 'orderdate': '2023-09-13', 'planresult': [{'problem': '12222', 'comment': '11111'}], 'problemsrisks': [{'problem': '1231', 'comment': '32323'}]}




print (created)

def taskworkbefore(data, created):
    res= [e for e in data if datetime.datetime.strptime(e['dateend'], '%Y-%m-%d')<=created or e['status']['id']==5 ]
    return len(res)>0

resultbefore = [e for e in incoming['tasks'] if (datetime.datetime.strptime(e['dateend'], '%Y-%m-%d')<=created) or e['status']['id']==5 or taskwork(e['task_work'])==True]
print (resultbefore)
print((datetime.datetime.strptime("2023-10-12", '%Y-%m-%d')-created).days)