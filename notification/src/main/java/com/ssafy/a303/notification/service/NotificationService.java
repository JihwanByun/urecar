package com.ssafy.a303.notification.service;

import com.ssafy.a303.notification.dto.NotificationRequestDto;

public interface NotificationService {

    void sendFirstNotification(NotificationRequestDto dto);

    void sendSecondNotification(NotificationRequestDto dto);

}
