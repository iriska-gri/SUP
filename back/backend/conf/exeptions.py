from fastapi import (
    HTTPException,
    status
)

class UnauthError(HTTPException):
    """ Некоректные имя пользователя или пароль """

    def __init__(self) -> None:
        super().__init__(status.HTTP_401_UNAUTHORIZED, detail='Некоректные имя пользователя или пароль', headers={'WWW-Authenticate': 'Bearer'})

class ADError(HTTPException):
    """ Ошибки AD """

    def __init__(self,text) -> None:
        super().__init__(status.HTTP_401_UNAUTHORIZED, detail=text, headers={'WWW-Authenticate': 'Bearer'})


class UserBaseError(HTTPException):
    """ Пользователя нет в базе СУП """

    def __init__(self) -> None:
        super().__init__(status.HTTP_404_NOT_FOUND, detail='Пользователя нет в базе СУП, подтвердите почту лотус')

class UserMailError(HTTPException):
    """ Пользователя нет в базе СУП """

    def __init__(self) -> None:
        super().__init__(status.HTTP_404_NOT_FOUND, detail='Подтвердите почту лотус')

class UsernameError(HTTPException):
    """ Пользователь с таким логином уже существует """

    def __init__(self) -> None:
        super().__init__(status.HTTP_409_CONFLICT, detail='Пользователь с таким логином уже существует')

class DoesNotNoteError(HTTPException):
    """ Такой записи не существует """

    def __init__(self) -> None:
        super().__init__(status.HTTP_409_CONFLICT, detail='Такой записи не существует')

class BadAccountError(HTTPException):
    """ Ваша учетная записть недействительна """

    def __init__(self) -> None:
        super().__init__(status.HTTP_409_CONFLICT, detail='Ваша учетная записть недействительна')

class CodeConfirmationError(HTTPException):
    """ Ошибки, полученные при сбое в операциях кода подтверждения """
    def __init__(self, text) -> None:
        super().__init__(status.HTTP_409_CONFLICT, detail=text)