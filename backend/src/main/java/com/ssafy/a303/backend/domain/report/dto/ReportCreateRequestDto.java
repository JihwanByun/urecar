package com.ssafy.a303.backend.domain.report.dto;

import lombok.Getter;

@Getter
public class ReportCreateRequestDto {

    private Long memberId;
    private Double latitude;
    private Double longitude;

}
