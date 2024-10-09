from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session, declarative_base

from model import Report, ProcessStatus



DATABASE_URL = "mysql+pymysql://ssafy:ssafy@j11a303.p.ssafy.io:3306/urecar"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

Base.metadata.create_all(engine)
def update_process_status(report_id, evaluation_result):
    db = SessionLocal()
    report = db.query(Report).filter(Report.id == report_id).first()

    if report is None:
        print(f"Report with ID {report_id} not found.")
        return

    # 평가 결과에 따라 process_status 업데이트
    if evaluation_result == "ACCEPTED":
        report.process_status = ProcessStatus.ACCEPTED
    else:
        report.process_status = ProcessStatus.CANCELLED_FIRST_FAILED  # 예시로 다른 상태로 변경

    db.commit()
    db.refresh(report)
    db.close()