package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.OngoingReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import java.util.List;

public interface OfficialService {

    List<OngoingReportResponseDto> getOngoingReports();

    void decideReportOutcome(ReportDecisionRequestDTO reportDecisionRequestDTO);

}
