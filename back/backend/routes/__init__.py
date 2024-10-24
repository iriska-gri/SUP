from fastapi import APIRouter

from . import (
    main,
    history,
    test,
    auth,
    filters,
    project,
    tasks,
    chats,
    works,


)


router = APIRouter()
router.include_router(main.router)
router.include_router(test.router)
router.include_router(filters.router)
router.include_router(auth.router)
router.include_router(project.router)
router.include_router(tasks.router)
router.include_router(chats.router)
router.include_router(history.router)
router.include_router(works.router)
# router.include_router(supogramm.router)