package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import java.util.List;

public interface OfficialService {

    List<AnalysisSuccessReportResponseDto> getAnalysisSuccessReports();

    void decideReportOutcome(ReportDecisionRequestDTO reportDecisionRequestDTO);

}
