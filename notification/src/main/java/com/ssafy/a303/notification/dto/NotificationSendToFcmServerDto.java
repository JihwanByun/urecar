package com.ssafy.a303.notification.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class NotificationSendToFcmServerDto {

    private Long memberId;
    private Long contentId;
    private String title;
    private String content;
    private String clientToken;

}
