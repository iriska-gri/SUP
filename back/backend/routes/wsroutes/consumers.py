from fastapi import APIRouter

from . import (
    main,
    reestr,
    project,
    task,
    work,
    supogramm

)


router = APIRouter()
router.include_router(main.router)
router.include_router(project.router)
router.include_router(task.router)
router.include_router(reestr.router)
router.include_router(work.router)
router.include_router(supogramm.router)
