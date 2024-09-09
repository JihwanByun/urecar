package com.ssafy.a303.backend.domain.report.repository;

import com.ssafy.a303.backend.domain.report.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, Long> {

}
