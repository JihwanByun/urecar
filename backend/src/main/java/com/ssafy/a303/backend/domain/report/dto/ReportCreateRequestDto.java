package com.ssafy.a303.backend.domain.report.dto;

import lombok.Getter;

@Getter
public class ReportCreateRequestDto {

    private Long memberId;
    private String type;
    private Double latitude;
    private Double longitude;

}
