package com.ssafy.a303.backend.domain.report.dto;

import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class SecondReportResponseDto {

    private long reportId;
    private String officialName;
    private String datetime;
    private String type;
    private String content;
    private ProcessStatus processStatus;
    private byte[] firstImage;

}
