package com.ssafy.a303.backend.domain.member.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class NotificationRequestDto {

    private Long memberId;
    private Long reportId;
    private Boolean result;
    private String token;

}
