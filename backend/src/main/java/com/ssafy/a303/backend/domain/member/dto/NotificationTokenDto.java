package com.ssafy.a303.backend.domain.member.dto;

import lombok.Getter;

@Getter
public class NotificationTokenDto {

    private Long memberId;
    private String token;

}
