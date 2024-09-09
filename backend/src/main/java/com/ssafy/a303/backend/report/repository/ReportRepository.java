package com.ssafy.a303.backend.report.repository;

import com.ssafy.a303.backend.report.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, Long> {

}
