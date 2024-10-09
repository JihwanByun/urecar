package com.ssafy.a303.backend.domain.report.dto;

import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ReportResponseDto {

    private long reportId;
    private String type;
    private String content;
    private String datetime;
    private ProcessStatus processStatus;
    private byte[] firstImage;

}
