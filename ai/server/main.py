from confluent_kafka import Consumer, KafkaError
import asyncio
import logging
from fastapi import FastAPI
import torch
import ultralytics
from ultralytics import YOLO
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_client import Summary
import os

from database import SessionLocal
from model import Report, ProcessStatus

import json
import httpx


app = FastAPI()

# spring notification api url
SPRING_NOTIFICATION_URL = "http://j11a303.p.ssafy.io:8082/notifications/first"

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
    'auto.offset.reset': 'earliest',  # 커밋부터 읽기
    'enable.auto.commit': True,        # 자동 커밋 활성화
    'auto.commit.interval.ms': 50000,   # 5초마다 오프셋 자동 커밋
}

consumer = Consumer(consumer_config)
consumer.subscribe([KAFKA_TOPIC])

# Prometheus Summary 메트릭 생성
REQUEST_TIME = Summary('image_process_execution_seconds', 'Time spent processing a request')
Instrumentator().instrument(app).expose(app)

@app.on_event("startup")
async def startup_event():
    logger.info("App startup initiated")
    asyncio.create_task(consume_kafka())


@app.on_event('shutdown')
async def app_shutdown():
    consumer.close()

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

        #     # 메시지의 각 파티션에 대해 처리
        # for partition, messages in msg.items():
        #     for message in messages:

        #         content = message.value
        #         report_id = content["reportId"]
        #         first_image_path = content["firstImage"]

        #         image_data = read_image(first_image_path)

        #         with torch.no_grad():
        #             evaluation_result = model(image_data).numpy()
        #             update_process_status(report_id, evaluation_result)
        await process_msg(msg)

        # Kafka 메시지 처리
        print(f"Received message: {msg.value()}")

model = YOLO('/home/ubuntu/docker/ai/train43_best.pt')
# model = torch.load('/home/ubuntu/docker/ai/train43_best.pt')
# model = torch.load(r'C:\workspace\S11P21A303\ai\server\train43_best.pt')

@REQUEST_TIME.time()
async def process_msg(msg):
                # 메시지의 각 파티션에 대해 처리
    # for partition, messages in msg.value():
    #     for message in messages:


    content = json.loads(msg.value().decode('utf-8'))
    report_id = content["reportId"]
    first_image_path = content["firstImage"]

        # 파일 경로 검증 로직
 
    try:
        image_data = read_image(first_image_path)
    except Exception:
        return

    with torch.no_grad():
        result = model.predict(image_data)
        # evaluation_result = model(image_data).numpy()
        evaluation_result = check_illegal_parking(result)
        update_process_status(report_id, evaluation_result)

    # for evaluation result, call api of spring notification server
    member_id = content["memberId"]
    token = content["token"]
    await send_notification(report_id, evaluation_result, token, member_id)

async def send_notification(report_id, evaluation_result, token, member_id):
    data = {
        "memberId": member_id,
        "reportId": report_id,
        "result": evaluation_result,
        "token": token
    }
    
    print(member_id)
    print(report_id)
    print(evaluation_result)

    async with httpx.AsyncClient() as client:
        try:
            print("notification")
            response = await client.post(SPRING_NOTIFICATION_URL, json=data)
        except Exception as e:
            print(f"Error sending notification: {e}")            


def check_illegal_parking(result):
    vehicle_boxes = []
    lane_boxes = []
    # return True

    if len(result[0].boxes)==0:
        return False

    # 각 객체의 바운딩 박스와 클래스 추출
    for box in result[0].boxes:
        box_cls = int(box.cls)
        class_name = result[0].names[box_cls]
        
        # 클래스 이름에 따라 차량과 차선을 구분
        if class_name in ['vehicle_car', 'vehicle_bus', 'vehicle_truck', 'vehicle_bike']:
            vehicle_boxes.append(box)
        elif class_name in ['lane_white', 'lane_blue', 'lane_yellow', 'lane_shoulder']:
            lane_boxes.append(box)
            
    # if vehicle_boxes or lane_boxes:
    #     return True
    
    # 바운딩 박스 간 겹침 여부 확인
    for vehicle in vehicle_boxes:
        for lane in lane_boxes:
            if is_overlapping(vehicle, lane):
                return True
    
    return False

# 바운딩 박스 겹침 여부 확인 함수
def is_overlapping(box1, box2):
    x1_min, y1_min, x1_max, y1_max = box1.xyxy[0].tolist()
    x2_min, y2_min, x2_max, y2_max = box2.xyxy[0].tolist()

    # 두 박스가 겹치는지 확인
    if x1_min < x2_max and x1_max > x2_min and y1_min < y2_max and y1_max > y2_min:
        return True
    return False

# class ModelLoadError(Exception):
#     pass
# try:
#     model = torch.load('/home/ubuntu/docker/ai/train43_best.pt',weights_only=False)

# except FileNotFoundError:
#     raise ModelLoadError("Model file not found.")

def update_process_status(report_id, evaluation_result):
    db = SessionLocal()
    report = db.query(Report).filter(Report.report_id == report_id).first()

    if report is None:
        print(f"Report with ID {report_id} not found.")
        return

    # 평가 결과에 따라 process_status 업데이트
    if evaluation_result == "ACCEPTED":
        report.process_status = ProcessStatus.FIRST_ANALYSIS_SUCCESS
    else:
        report.process_status = ProcessStatus.CANCELLED_FIRST_FAILED  # 예시로 다른 상태로 변경

    db.commit()
    db.refresh(report)
    db.close()

async def process_message(image_data):
    return model(image_data).numpy()


def read_image(image_path):
    from PIL import Image
    import numpy as np

    image = Image.open(image_path).convert('RGB')
    return np.array(image)