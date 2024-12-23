package com.ssafy.a303.backend.domain.report.dto;

import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class ReportCreateResponseDto {

    private long reportId;
    private String type;
    private String datetime;
    private ProcessStatus processStatus;
    private byte[] firstImage;

}