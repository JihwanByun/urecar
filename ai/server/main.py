from confluent_kafka import Consumer, KafkaError
import asyncio
import logging
from fastapi import FastAPI
import torch

from database import SessionLocal
from model import Report, ProcessStatus


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

consumer = Consumer(consumer_config)
consumer.subscribe([KAFKA_TOPIC])

# @app.on_event("startup")
# async def startup_event():
#     logger.info("App startup initiated")
#     asyncio.create_task(consume_kafka())
#
# @app.on_event('shutdown')
# async def app_shutdown():
#     consumer.close()

@app.get("/")
async def root():
    return {"message": "Hello World"}

# Kafka 메시지 소비를 처리하는 비동기 함수
async def consume_kafka():
    current_loop = asyncio.get_running_loop()
    while True:
        print("polling")
        logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
        msg = await current_loop.run_in_executor(None, consumer.poll, 1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() != KafkaError._PARTITION_EOF:
                print(f"Kafka error: {msg.error()}")
            continue

            # 메시지의 각 파티션에 대해 처리
        for partition, messages in msg.items():
            for message in messages:

                content = message.value
                report_id = content["reportId"]
                first_image_path = content["firstImage"]

                image_data = read_image(first_image_path)

                with torch.no_grad():
                    evaluation_result = model(image_data).numpy()
                    update_process_status(report_id, evaluation_result)
        # Kafka 메시지 처리
        print(f"Received message: {msg.value()}")
        await asyncio.sleep(1)  # 비동기 작업이므로 조금 대기

class ModelLoadError(Exception):
    pass
try:
    model = torch.load('/home/ubuntu/docker/ai/train43_best.pt',weights_only=True)

except FileNotFoundError:
    raise ModelLoadError("Model file not found.")

def update_process_status(report_id, evaluation_result):
    db = SessionLocal()
    report = db.query(Report).filter(Report.report_id == report_id).first()

    if report is None:
        print(f"Report with ID {report_id} not found.")
        return

    # 평가 결과에 따라 process_status 업데이트
    if evaluation_result == "ACCEPTED":
        report.process_status = ProcessStatus.ACCEPTED
    else:
        report.process_status = ProcessStatus.UNACCEPTED  # 예시로 다른 상태로 변경

    db.commit()
    db.refresh(report)
    db.close()

async def process_message(image_data):
    return model(image_data).numpy()


def read_image(image_path):
    from PIL import Image
    import numpy as np

    image = Image.open(image_path)
    return np.array(image)