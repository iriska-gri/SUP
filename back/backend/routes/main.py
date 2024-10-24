from typing import Union
from fastapi import (
    APIRouter,
    Depends,
    status,
    Form, UploadFile

)
from fastapi.responses import FileResponse

import json
import time
from datetime import datetime
import shutil
from pathlib import Path
from services.depends import AD
from orm.models import *
from orm.schema import *
from datetime import datetime, date
router = APIRouter(
    prefix='/main',
    tags=['ОБЩИЙ'], 
    
)

projectfileLevels = {'project':1, 'task':2,'work':3,'assignment':4}





@router.post("/uploader")
async def uploaddock(file:list[UploadFile], info:JSON=Form(...),user:dict = Depends(AD.protect_claim)):

    fp = Path(__file__).parent.parent
   
    fp =fp.joinpath('uploads','ftproject',f'{info["project"]}/')
    
    fp.mkdir(parents=True,exist_ok=True)
    info['sender']=user['id']
    info['datetime']=datetime.now()
    for f in file:
        fn = f'{time.time()}_{f.filename}'
        file_location = fp.joinpath(fn)
        with open(file_location, "wb+") as file_object:
            shutil.copyfileobj(f.file, file_object)
        
        info['filepath']=f'/uploads/ftproject/{info["project"]}/{fn}'        
       
        await Projectfile.objects.create(**info)
    return {"created":"ok"}




@router.get("/getfile", response_class=FileResponse)
async def  gtf(id:int,user:dict = Depends(AD.protect_claim)):
    print(id)
    file = await Projectfile.objects.get(id=id)
    fn = file.filepath
    
    return FileResponse(f"{Path(__file__).parent.parent}{fn}", filename=fn)
# f"{Path(__file__).parent.parent}{fn}"