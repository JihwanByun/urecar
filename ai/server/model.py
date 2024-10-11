from sqlalchemy import Column, BigInteger, String, DateTime, Double, Enum
from sqlalchemy.orm import declarative_base
import enum

Base = declarative_base()


# process_status의 enum 정의
class ProcessStatus(enum.Enum):
    ACCEPTED = "ACCEPTED"
    CANCELLED_FIRST_FAILED = "CANCELLED_FIRST_FAILED"
    CANCELLED_SECOND_FAILED = "CANCELLED_SECOND_FAILED"
    ONGOING = "ONGOING"
    UNACCEPTED = "UNACCEPTED"
    FIRST_ANALYSIS_SUCCESS = "FIRST_ANALYSIS_SUCCESS"


class Report(Base):
    __tablename__ = 'report'

    report_id = Column(BigInteger, primary_key=True, index=True)  # 기본 키
    content = Column(String(1000), nullable=True)  # 내용 열
    created_at = Column(DateTime(6), nullable=True)  # 생성일 열
    first_image = Column(String(255), nullable=True)  # 첫 번째 이미지 열
    latitude = Column(Double, nullable=True)  # 위도 열
    longitude = Column(Double, nullable=True)  # 경도 열
    process_status = Column(Enum(ProcessStatus), nullable=True)  # 처리 상태 열
    second_image = Column(String(255), nullable=True)  # 두 번째 이미지 열
    type = Column(String(255), nullable=True)  # 타입 열
    member_id = Column(BigInteger, nullable=True)  # 회원 ID 열
    official_name = Column(String(255), nullable=True)  # 공식 이름 열
