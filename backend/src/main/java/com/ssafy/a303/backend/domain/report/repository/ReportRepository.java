package com.ssafy.a303.backend.domain.report.repository;

import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import com.ssafy.a303.backend.domain.report.entity.Report;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ReportRepository extends JpaRepository<Report, Long> {

    List<Report> findAllByMemberId(long memberId);

    Report getReportById(Long reportId);

    List<Report> getReportsByProcessStatus(ProcessStatus processStatus);

    @Query("SELECT r FROM Report r WHERE r.member.id = :memberId " +
            "AND (:processStatus IS NULL OR r.processStatus = :processStatus) " +
            "AND r.createdAt BETWEEN :startDate AND :endDate " +
            "ORDER BY r.createdAt DESC")
    List<Report> findReportsByMemberIdAndProcessStatusAndCreatedAtBetween(
            @Param("memberId") long memberId,
            @Param("processStatus") ProcessStatus processStatus,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate
    );
}
