package com.ssafy.a303.notification.service;

import com.ssafy.a303.notification.dto.NotificationRequestDto;
import com.ssafy.a303.notification.dto.NotificationResponseDto;
import java.util.List;

public interface ResultNotificationService {

    void sendFirstNotification(NotificationRequestDto dto);

    void sendSecondNotification(NotificationRequestDto dto);

    List<NotificationResponseDto> getNotifications(long id);

    void deleteByNotificationId(long id);

    void deleteByMemberId(long id);

    void sendResultNotification(NotificationRequestDto dto);

    void sendOneMinuteNotification(NotificationRequestDto dto);

}
