package com.ssafy.a303.backend.domain.member.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class ReportDecisionRequestDTO {

    private Long reportId;
    private String memberName;
    private Boolean decision;

}
