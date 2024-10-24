# from logging import log
from fastapi_jwt_auth import AuthJWT
from fastapi_jwt_auth.exceptions import AuthJWTException
from fastapi import (
    Depends,
    Query,
    status,
    WebSocket,
)


from conf.jwt import APIAuth
# from conf.log import logger



class AD:

    @classmethod
    async def protect(cls, Authorize: AuthJWT = Depends(), apikey = Depends(APIAuth().set)):
        """
            Требует авторизацию и возвращает текущего пользователя.
            вызов - в аргументы функции передать user_id = Depends(cls.protect)
        """
        
        Authorize.jwt_required()
        current_user = Authorize.get_jwt_subject()

        return current_user

    @classmethod
    async def protect_claim(cls, Authorize: AuthJWT = Depends(), apikey = Depends(APIAuth().set)):
        """
            Требует авторизацию и возвращает текущего пользователя со всеми полями.
            вызов - в аргументы функции передать user_id = Depends(cls.protect_claim)
        """

        Authorize.jwt_required()
        # current_user = Authorize.get_raw_jwt()['user']
        current_user = Authorize.get_raw_jwt()['user']
        
       
        return current_user

    @classmethod
    async def protect_ws(cls, websocket: WebSocket, token: str = Query(...), Authorize: AuthJWT = Depends()):
        
        await websocket.accept()
        
        try:            
            token = token.replace('Bearer ', '')
            Authorize.jwt_required("websocket", token=token)
            return Authorize.get_raw_jwt(token)['user']

        except AuthJWTException as erroren:
            # print(erroren)
            # print("НЕ авторизован")
            # await websocket.send_json({"error":"WS_1008_POLICY_VIOLATION"})
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return None
        except Exception as e:
            print(e)
            # logger.exception(e)
            return None



        

