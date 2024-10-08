from fastapi import FastAPI, File, UploadFile, BackgroundTasks
from fastapi.responses import JSONResponse
from PIL import Image
import io
from confluent_kafka import Consumer, KafkaError
import asyncio
import logging

app = FastAPI()

# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# kafka setting
KAFKA_BROKER_URL = "j11a303.p.ssafy.io:40000"
KAFKA_TOPIC = "first_wait"

# consumer setting
consumer_config = {
    'bootstrap.servers': KAFKA_BROKER_URL,
    'group.id' : 'first-wait-consumer-group',
    'auto.offset.reset': 'latest',  # 커밋부터 읽기
    'enable.auto.commit': True,        # 자동 커밋 활성화
    'auto.commit.interval.ms': 5000,   # 5초마다 오프셋 자동 커밋
}

@app.on_event("startup")
async def startup_event():
    logger.info("App startup initiated") 
    asyncio.create_task(consume_kafka())

@app.get("/")
async def root():
    return {"message": "Hello World"}

# Kafka 메시지 소비를 처리하는 비동기 함수
async def consume_kafka():
    consumer = Consumer(consumer_config)
    consumer.subscribe([KAFKA_TOPIC])

    while True:
        print("polling")
        msg = consumer.poll(timeout=1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() != KafkaError._PARTITION_EOF:
                print(f"Kafka error: {msg.error()}")
            continue

        # Kafka 메시지 처리
        print(f"Received message: {msg.value()}")
        await asyncio.sleep(1)  # 비동기 작업이므로 조금 대기

async def validate_image(file: UploadFile = File(...)):
    try:
        # 이미지 파일 읽기
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))

        # AI 모델을 통해 이미지 검증 (예시, 실제 검증 코드 작성)
        result = image

        return JSONResponse(content={"result": result})

    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=400)

    # try:
    #     # 이미지 파일 읽기
    #     contents = await file.read()
    #     image = Image.open(io.BytesIO(contents))

    #     # AI 모델을 통해 이미지 검증 (예시, 실제 검증 코드 작성)
    #     result = image

    #     return JSONResponse(content={"result": result})

    # except Exception as e:
    #     return JSONResponse(content={"error": str(e)}, status_code=400)
