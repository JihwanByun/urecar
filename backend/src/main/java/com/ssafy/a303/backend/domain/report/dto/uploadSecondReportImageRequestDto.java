package com.ssafy.a303.backend.domain.report.dto;

import lombok.Getter;

@Getter
public class uploadSecondReportImageRequestDto {

    private Long memberId;
    private Long reportId;
    private double longitude;
    private double latitude;
    private String content;

}
