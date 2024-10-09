package com.ssafy.a303.backend.domain.report.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import lombok.Getter;

@Getter
public class SearchedReportsRequestDto {

    private ProcessStatus processStatus;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss:SSS", timezone = "Asia/Seoul")
    private String startDate;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss:SSS", timezone = "Asia/Seoul")
    private String endDate;

}
