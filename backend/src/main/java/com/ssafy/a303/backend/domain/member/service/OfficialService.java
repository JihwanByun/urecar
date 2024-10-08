package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportListResponseDto;
import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import java.util.List;

public interface OfficialService {

    List<AnalysisSuccessReportListResponseDto> getAnalysisSuccessReports();

    void decideReportOutcome(ReportDecisionRequestDTO reportDecisionRequestDTO);

    AnalysisSuccessReportResponseDto getAnalysisSuccessReport(Long id);
}
