package com.ssafy.a303.backend.domain.member.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class AnalysisSuccessReportListResponseDto {

    private long reportId;
    private String memberName;
    private String date;
    private String type;

}
