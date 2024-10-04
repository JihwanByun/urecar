package com.ssafy.a303.notification.dto;

import lombok.Getter;

@Getter
public class NotificationRequestDto {

    private Long memberId;
    private Long reportId;
    private Boolean result;
    private String token;

}
