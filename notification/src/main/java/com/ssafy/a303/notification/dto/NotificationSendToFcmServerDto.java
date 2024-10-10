package com.ssafy.a303.notification.dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class NotificationSendToFcmServerDto {

    private Long memberId;
    private Long reportId;
    private Long contentId;
    private LocalDateTime createAt;
    private String title;
    private String content;
    private String clientToken;

}
