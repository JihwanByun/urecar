package com.ssafy.a303.backend.domain.member.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class OngoingReportResponseDto {

    private long reportId;
    private String memberName;
    private String content;
    private byte[] firstImage;
    private double latitude;
    private double longitude;

}
