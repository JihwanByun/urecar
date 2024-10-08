package com.ssafy.a303.backend.domain.member.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AnalysisSuccessReportResponseDto {

    private long reportId;
    private String memberName;
    private String content;
    private String datetime;
    private byte[] firstImage;
    private double latitude;
    private double longitude;
    private String type;

}
