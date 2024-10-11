package com.ssafy.a303.notification.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class NotificationResponseDto {

    private long notificationId;
    private long reportId;
    private String content;
    private String datetime;

}
