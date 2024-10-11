# 불법 주정차 신고 간편화 서비스, UreCar 🚗

<div align=center>
  <img src="/UreCar.png" width="90%" />
</div>

## 📅 프로젝트 정보

<div align=center>

### SSAFY 11기 2학기 특화 프로젝트

2024.08.26(화) ~ 2024.10.11(금) [7주]



</div>
</br>

## 주제

불법 주정차 신고 절차를 간소화하고 AI와 위치 데이터 통해 불법 여부를 판단하는 **불법 주정차 신고 간편화 서비스**

</br>

## 기획 배경

> 기존 불법 주정차 신고 앱 안전 신문고의 단점

- 복잡한 신고 절차
- 신고 과정에서의 유저 편의성이 낮음


</br>

## 📝 기능 소개
### :sweat_smile: 신고자

**신고 생성**  

불법주정차 사진을 촬영합니다.  
불법주정차 분석 성공(1-1)  
불법주정차 분석 실패(1-3)  

1-1. 불법주정차 분석 성공

- 주정차 확인을 위해 1분 대기합니다. 1분 후 알림을 받습니다.
- 불법주정차 관련 설명을 작성합니다.
- 1분 후 2차 사진을 촬영합니다.  
  - 불법주정차 분석 성공(1-2)
  - 불법주정차 분석 실패(1-3)

1-2. 2차 불법주정차 사진 분석 성공
- 신고 정보가 공무원에게 전달됩니다.

1-3. 불법주정차 분석 실패
- 신고가 취소됩니다.  
  
**신고 조회**
  - 신고한 정보들을 확인할 수 있습니다.
  - 날짜 별, 상태 별로 분류해 확인할 수 있습니다.
- 불법주정차 가이드 및 안전 뉴스 확인
  - 불법주정차에 대한 정보를 확인할 수 있습니다.
  - 안전 뉴스를 확인할 수 있습니다.  

### :sweat_smile: 공무원
- 분석 완료 신고 정보 조회 및 검사
  - AI 및 위치 검증이 완료된 신고 정보를 확인할 수 있습니다.
- 신고 정보에 대해 수용 or 불수용을 할 수 있습니다.
  - 신고 정보 수용
    - 신고 수용 알림이 신고자에게 전송됩니다.
  - 신고 정보 불수용
    - 신고 불수용 알림이 신고자에게 전송됩니다.



> 사진 촬영

- **1차 사진**
  - 
  - 
  - 
  - 
- **2차 사진**
  - 
  - 
  - 
  - 
- **신고 결과**
  - 
  - 

> 안전 뉴스 📢

- ****
  - 
  - 
  - 
  - 
- 
  - 
  - 
  - 
  - 
- 
  - 
  - 

> 신고 가이드 ⏰

- ****
  - 
  - 
  - 
  - 
  - 





</br>

## 📱 서비스 화면
|                                                                  |                                                                  |                                                                     |                                                                     |
|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:-------------------------------------------------------------------:|:-------------------------------------------------------------------:|
| <img src="assets/screenshots/UreCar_메인페이지.jpg" width="175px" />  |  <img src="assets/screenshots/UreCar_신고조회.jpg" width="175px" />  |   <img src="assets/screenshots/UreCar_신고실패.jpg" width="175px" />    |    <img src="assets/screenshots/UreCar_갤러리.jpg" width="175px" />    |
|                              메인 페이지                              |                               신고조회                               |                                신고실패                                 |                                 갤러리                                 |
| <img src="assets/screenshots/UreCar_알림페이지.jpg" width="175px" />  | <img src="assets/screenshots/UreCar_알림_상태바.jpg" width="175px" /> | <img src="assets/screenshots/UreCar_불법주정차_가이드.jpg" width="175px" /> |   <img src="assets/screenshots/UreCar_마이페이지.jpg" width="175px" />   |
|                              알림 페이지                              |                              알림 상태바                              |                              불법주정차 가이드                              |                                마이페이지                                |
| <img src="assets/screenshots/UreCar_로그인페이지.jpg" width="175px" /> |  <img src="assets/screenshots/UreCar_회원가입.jpg" width="175px" />  | <img src="assets/screenshots/UreCar_공무원_신고리스트.jpg" width="175px" /> | <img src="assets/screenshots/UreCar_공무원_상세페이지.jpg" width="175px" /> |
|                             로그인 페이지                              |                             회원가입 페이지                             |                             공무원 신고 리스트                              |                            공무원 신고 상세 페이지                            |


</br>

## 🔎 기술 스택

> Frontend

<div>
  <img src="https://img.shields.io/badge/React-61DAFB?style=flat&logo=React&logoColor=white"/>
  <img src="https://img.shields.io/badge/TypeScript-3178C6?style=flat&logo=typescript&logoColor=white"/>
  <img src="https://img.shields.io/badge/Tailwind CSS-06B6D4?style=flat&logo=tailwindcss&logoColor=white"/>
  <img src="https://img.shields.io/badge/Storybook-FF4785?style=flat&logo=storybook&logoColor=white"/>
</div>
<div>
  <img src="https://img.shields.io/badge/Recoil-3578E5?style=flat&logo=recoil&logoColor=white"/>
  <img src="https://img.shields.io/badge/React Query-FF4154?style=flat&logo=ReactQuery&logoColor=white"/>
  <img src="https://img.shields.io/badge/axios-5A29E4?style=flat&logo=axios&logoColor=white"/>
</div>
<div>
  <img src="https://img.shields.io/badge/yarn-5FA04E?style=flat&logo=yarn&logoColor=white"/>
  <img src="https://img.shields.io/badge/Vite-646CFF?style=flat&logo=vite&logoColor=white"/>
  <img src="https://img.shields.io/badge/Node.js-5FA04E?style=flat&logo=node.js&logoColor=white"/>
</div>
</br>

> Backend

<div>
  <img src="https://img.shields.io/badge/Java-000000?style=flat&logo=openjdk&logoColor=white"/>
  <img src="https://img.shields.io/badge/Spring Boot 3-6DB33F?style=flat&logo=springboot&logoColor=white"/>
  <img src="https://img.shields.io/badge/Spring Security-6DB33F?style=flat&logo=springsecurity&logoColor=white"/>
  <img src="https://img.shields.io/badge/Intelli J-000000?style=flat&logo=intellijidea&logoColor=white"/>
</div>
<div>
  <img src="https://img.shields.io/badge/JPA-59666C?style=flat&logo=hibernate&logoColor=white"/>
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/MongoDB-47A248?style=flat&logo=mongodb&logoColor=white"/>
  <img src="https://img.shields.io/badge/Redis-FF4438?style=flat&logo=redis&logoColor=white"/>
</div>
</br>

> CI/CD

<div>
  <img src="https://img.shields.io/badge/Amazon EC2-FF9900?style=flat&logo=amazonec2&logoColor=white"/>
  <img src="https://img.shields.io/badge/Amazon S3-569A31?style=flat&logo=amazons3&logoColor=white"/>
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white"/>
  <img src="https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white"/>
  <img src="https://img.shields.io/badge/nginx-009639?style=flat&logo=nginx&logoColor=white"/>
</div>
</br>

> Collaboration Tool

<div>
  <img src="https://img.shields.io/badge/Jira-0052CC?style=flat&logo=jira&logoColor=white"/>
  <img src="https://img.shields.io/badge/Git-05032?style=flat&logo=git&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitLab-FC6D26?style=flat&logo=gitlab&logoColor=white"/>
  <img src="https://img.shields.io/badge/Notion-000000?style=flat&logo=notion&logoColor=white"/>
  <img src="https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white"/>
  <img src="https://img.shields.io/badge/Miro-050038?style=flat&logo=miro&logoColor=white"/>
</div>
<div>
  <img src="https://img.shields.io/badge/Webex-000000?style=flat&logo=webex&logoColor=white"/>
  <img src="https://img.shields.io/badge/Mattermost-0058CC?style=flat&logo=mattermost&logoColor=white"/>
  <img src="https://img.shields.io/badge/Discord-5865F2?style=flat&logo=discord&logoColor=white"/>
</div>
</br>

## 🧩 ERD

![ERD](assets/UreCar_ERD.jpg)

</br>

## 🗃️ 아키텍처

![시스템 아키텍처](assets/UreCar_architecture.jpg)

> 주요 아키텍처

- **MySQL & MongoDB**
  - 데이터의 특성에 맞는 DB를 사용하기 위해 2개로 나누어서 관리하였다.
  - MySQL은 관계형 데이터베이스로서 회원, 일정, 급식, 공지사항, 투약의뢰서, 귀가동의서와 같은 구조화된 데이터를 관리하는데 적합하다.
  - MongoDB는 비정형 데이터인 알림장, 메모 데이터를 저장하기에 적합하다.
  - 회원, 일정, 급식, 공지사항, 투약의뢰서, 귀가동의서 서비스와 알림장, 메모 서비스는 각각 사용하는 데이터가 철저하게 분리되어 있고, 2개의 DB를 모두 사용하는 요청하는 횟수가 매우 적어 두 개의 서버로 분리해 보다 효율적으로 관리하였다.
- **PWA**
  - Kidwe 서비스는 유치원 선생님이 일과 중 사용하기에 모바일 환경이 더욱 편리하다 생각했다.

</br>

## 🎨 화면 설계서

[🔗 Figma](<https://www.figma.com/design/CIgKnla27tmKOUzFrZiBKU/wow?node-id=0-1&node-type=canvas&t=hRaCLQ5Lg8yqNioX-0>)

![Wireframe](assets/UreCar_WireFrame.jpg)

</br>

## 🔃 API 명세서

> MySQL

 <img src="assets/UreCar_API명세서.jpg" alt="API명세서 - MySQL" width="60%">

</br>

## 🥝 팀원

| Name      | Roles                                   | GitHub                                         |
| :-------- | :-------------------------------------- | :--------------------------------------------- |
| 변지환 👑 | 팀장 | [@JihwanByun](https://github.com/JihwanByun)        |
| 김혁 🐹 | Frontend                                | [@ssafyhyuk](https://github.com/ssafyhyuk) |
| 권대형 🍀 | Frontend                           | [@doto3852](https://github.com/doto3852)   |
| 백승우 🐶 | AI                 | [@galler-ist](https://github.com/galler-ist)   |
| 박동환 🍬 | Backend                                 | [@ParkDH0809](https://github.com/ParkDH0809)   |
| 임준혁 🐰 | Backend, CI/CD                          | [@Im-Junhyuk](https://github.com/Im-Junhyuk)         |
