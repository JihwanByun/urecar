# 베이스 이미지 선택
# FROM python:3.12.6-slim
FROM continuumio/anaconda3:latest

# 작업 디렉토리 설정
WORKDIR /app

# 필요 파일 복사
COPY ./requirements.txt /app/requirements.txt

# 필요한 패키지 설치
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
# RUN conda install --yes --file /app/requirements.txt

# FastAPI 소스 코드 복사
COPY . /app

# 8000 포트 오픈
# EXPOSE 8000

# 애플리케이션 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# 기존 이미지에서 시작

# 시스템 업데이트 및 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch==2.4.0 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
RUN pip3 install ultralytics==8.3.7



