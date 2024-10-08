# 1. 베이스 이미지로 OpenJDK 21을 사용
FROM openjdk:21-jdk-slim

# 2. 작업 디렉토리 생성
WORKDIR /app

# 3. 빌드된 JAR 파일을 컨테이너로 복사 (CI/CD에서 미리 빌드된 JAR 사용)
COPY build/libs/*.jar app.jar

# 4. 컨테이너 시작 시 JAR 파일을 실행하도록 설정
ENTRYPOINT ["java", "-jar", "/app/app.jar"]