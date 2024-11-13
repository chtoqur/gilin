from contextlib import asynccontextmanager
import asyncio
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger
from dotenv import load_dotenv
import os
from fastapi import FastAPI
import requests
from datetime import datetime
from fastapi.responses import JSONResponse
from redis.asyncio import Redis
from pydantic import BaseModel

load_dotenv()

REDIS_HOST = os.getenv("REDIS_HOST")  # Redis 컨테이너의 호스트
REDIS_PORT = int(os.getenv("REDIS_PORT"))
REDIS_USER = os.getenv("REDIS_USER")
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD")
REDIS_TTL = 3600  # TTL of 1 hour for each station entry
REDIS_GEO_KEY = os.getenv("REDIS_GEO_KEY")  # Key for Redis GEO data structure

# API configuration
API_KEY = os.getenv("SEOUL_API_KEY_SEO")  # Replace with your actual API key
BASE_URL = f"{os.getenv('SEOUL_API_BASE_URL')}/{API_KEY}/json/bikeList"
stations_per_request = 1000




# 위치 정보 모델
class Location(BaseModel):
    name: str
    longitude: float
    latitude: float

#Redis 클라이언트 지연 초기화 함수
async def get_redis_client():
    global redis_client, REDIS_HOST, REDIS_PORT, REDIS_USER, REDIS_PASSWORD
    if redis_client is None:
        return Redis(
            host=REDIS_HOST,
            port=REDIS_PORT,
            username=REDIS_USER,
            password=REDIS_PASSWORD,
            decode_responses=True
        )
    else:
        return redis_client

@asynccontextmanager
async def lifespan(app):
    global redis_client
    # scheduler 실행
    redis_client = Redis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        username=REDIS_USER,  # username 설정
        password=REDIS_PASSWORD,
        decode_responses=True)
    await fetch_and_store_bike_station_status()
    scheduler.add_job(lambda: asyncio.create_task(fetch_and_store_bike_station_status()), IntervalTrigger(minutes=5))
    scheduler.start()
    yield

app = FastAPI(lifespan=lifespan)
redis_client = None
scheduler = AsyncIOScheduler()


@app.get("/")
async def read_root():
    return "hello"

async def fetch_and_store_bike_station_status():
    start_index, end_index = 1, stations_per_request
    all_stations = []
    global redis_client
    try:
        redis = redis_client
        while True:
            url = f"{BASE_URL}/{start_index}/{end_index}/"
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()
            if 'rentBikeStatus' not in data or 'row' not in data['rentBikeStatus']:
                break

            stations = data['rentBikeStatus']['row']
            all_stations.extend(stations)

            start_index += stations_per_request
            end_index += stations_per_request

        for station in all_stations:
            station_id = station['stationId']
            station_name = station['stationName']
            latitude = float(station['stationLatitude'])
            longitude = float(station['stationLongitude'])
            parking_bike_tot_cnt = station['parkingBikeTotCnt']

            await redis.geoadd(REDIS_GEO_KEY, (longitude, latitude, station_id))

            station_data = {
                'stationName': station_name,
                'parkingBikeTotCnt': parking_bike_tot_cnt
            }
            await redis.hmset(f"{station_id}", station_data)
            await redis.expire(f"{station_id}", REDIS_TTL)

        print(f"Data successfully stored in Redis at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from API: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

@app.get('/update_stations')
async def update_stations():
    await fetch_and_store_bike_station_status()
    return JSONResponse(content={"message": "Stations updated successfully"})

# 서버 실행 명령어
# uvicorn main:app --reload
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host='127.0.0.1', port=5000)


