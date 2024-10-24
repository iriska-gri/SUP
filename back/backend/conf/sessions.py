import os
from pathlib import Path
from dotenv import load_dotenv

import sqlalchemy
import databases

import aioredis

BASE_DIR = Path(__file__).parent.parent.parent
load_dotenv(BASE_DIR.joinpath(".env"))

database = databases.Database(os.environ["DATABASE_URL"].replace("postgresql://", "postgresql+asyncpg://"))
metadata = sqlalchemy.MetaData()

async def get_redis_pool_gen():
    redis= await aioredis.from_url("redis://localhost", encoding="utf-8", decode_responses=True)
    try:  
        yield redis
    finally:
        print("Закрываю редис генератор")
        await redis.close()
    
async def get_redis_pool():
    return await aioredis.from_url("redis://localhost", encoding="utf-8", decode_responses=True)

