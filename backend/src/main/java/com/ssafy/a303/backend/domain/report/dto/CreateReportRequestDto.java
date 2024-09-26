package com.ssafy.a303.backend.domain.report.dto;

import lombok.Getter;

@Getter
public class CreateReportRequestDto {

    private Long memberId;
    private String content;
    private Double latitude;
    private Double longitude;

}
