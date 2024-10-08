from fastapi import FastAPI, File, UploadFile, BackgroundTasks
from fastapi.responses import JSONResponse
from PIL import Image
import io
from confluent_kafka import Consumer, KafkaError
import asyncio

app = FastAPI()

# kafka setting
KAFKA_BROKER_URL = "j11a303.p.ssafy.io:40000"
KAFKA_TOPIC = "first_wait"

# consumer setting
consumer_config = {
    'bootstrap.servers': KAFKA_BROKER_URL,
    'group.id' : 'first-wait-consumer-group'
}

@app.on_event("startup")
async def startup_event():
    asyncio.create_task(validate_image())

@app.get("/")
async def root():
    return {"message": "Hello World"}

async def validate_image(file: UploadFile = File(...)):
    consumer = Consumer(consumer_config)
    consumer.subscribe([KAFKA_TOPIC])

    while True:
        msg = consumer.poll(timeout=1.0)
        print("polling")
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() != KafkaError._PARTITION_EOF:
                print(f"Kafka error: {msg.error()}")
            continue

        print(f"Received message: {msg.value().decode('utf-8')}")
    # try:
    #     # 이미지 파일 읽기
    #     contents = await file.read()
    #     image = Image.open(io.BytesIO(contents))

    #     # AI 모델을 통해 이미지 검증 (예시, 실제 검증 코드 작성)
    #     result = image

    #     return JSONResponse(content={"result": result})

    # except Exception as e:
    #     return JSONResponse(content={"error": str(e)}, status_code=400)
