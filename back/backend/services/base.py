from orm.models import Otdel, Position, Rank, Department,Organization

all_fk: dict = {
    "otdel": Otdel,
    "department": Department,
    "organization":Organization,
    "position": Position,
    "rank": Rank
}

class BaseService():

    async def create_fk(self, into_schema: dict, fks_check: tuple, updating:bool=False) -> dict:
        """
        Создает форины

        Args:
            into_schema (dict): Ожидаемая схема для создания
            dict_fk (dict): Кортеж ключей
            updating:bool=False - ормар просит почему-то на обновлении id, а не модель
        Returns:
            [dict]: Словарь для создания объекта
        """
        
        for fk in fks_check:

            model = all_fk[fk]
        
            if into_schema[fk]['name'] is not None:
                
                res = await model.objects.get_or_create(**into_schema[fk])
                
                if updating:
                    
                    into_schema[fk] = res[0].id
                else:
                    into_schema[fk] = res[0]
            else:
                del into_schema[fk]
        
        return into_schema

class QueryHelper():
    def appendForntoQ(fields:list, foreign:str):
        newarr=[]
        for x in fields:
            newarr.append(f'{x}__{foreign}')
        return fields+newarr