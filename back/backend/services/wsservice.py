import json
def querytoPydantic(schema,query):
    """
    Ormar результат в Pydantic схему

    Args:
        schema : класс схемы
        query (_type_): ormar запрос

    Returns:
        _type_: словарь, приведенный в соответствие со схемой

    """
    
    return schema(**query.dict()).dict()


def dumper(obj):
    return json.dumps(obj, indent=4, sort_keys=True, default=str)
        