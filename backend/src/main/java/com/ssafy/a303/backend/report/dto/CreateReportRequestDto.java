package com.ssafy.a303.backend.report.dto;

import lombok.Getter;

@Getter
public class CreateReportRequestDto {

    private Integer memberId;
    private String content;
    private String firstImage;
    private Double latitude;
    private Double longitude;

}
