package com.ssafy.a303.backend.domain.report.repository;

import com.ssafy.a303.backend.domain.report.entity.OutboxReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OutboxReportRepository extends JpaRepository<OutboxReport, Long> {

}
