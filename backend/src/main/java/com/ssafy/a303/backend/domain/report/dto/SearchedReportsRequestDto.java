package com.ssafy.a303.backend.domain.report.dto;

import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import java.time.LocalDate;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class SearchedReportsRequestDto {

    private Long memberId;
    private ProcessStatus processStatus;
    private LocalDate startDate;
    private LocalDate endDate;

}
