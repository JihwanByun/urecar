package com.ssafy.a303.outbox_kafka_producer.repository;

import com.ssafy.a303.outbox_kafka_producer.entity.OutboxReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OutboxReportRepository extends JpaRepository<OutboxReport, Long> {
    
}
