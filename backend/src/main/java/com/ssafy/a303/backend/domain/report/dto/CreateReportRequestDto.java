package com.ssafy.a303.backend.domain.report.dto;

import lombok.Data;
import lombok.Getter;

@Getter
@Data
public class CreateReportRequestDto {

    private Integer memberId;
    private String content;
    private String firstImage;
    private Double latitude;
    private Double longitude;

}
