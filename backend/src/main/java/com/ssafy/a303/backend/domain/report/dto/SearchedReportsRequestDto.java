package com.ssafy.a303.backend.domain.report.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class SearchedReportsRequestDto {

    private ProcessStatus processStatus;
    private LocalDate startDate;
    private LocalDate endDate;

}
