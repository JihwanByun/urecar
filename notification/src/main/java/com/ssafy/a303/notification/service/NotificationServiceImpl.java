package com.ssafy.a303.notification.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.ssafy.a303.notification.dto.NotificationRequestDto;
import com.ssafy.a303.notification.dto.NotificationSendToFcmServerDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class NotificationServiceImpl implements NotificationService {

    @Override
    public void sendFirstNotification(NotificationRequestDto dto) {
        sendByToken(NotificationSendToFcmServerDto.builder()
                .memberId(dto.getMemberId())
                .title("테스트 메시지 제목")
                .content("테스트 메시지 본문")
                .build(),
        dto.getToken());
    }

    @Override
    public void sendSecondNotification(NotificationRequestDto dto) {

    }

    public void sendByToken(NotificationSendToFcmServerDto dto, String token) {
        Message message = Message.builder()
                .setNotification(Notification.builder()
                        .setTitle(dto.getTitle())
                        .setBody(dto.getContent())
                        .build())
                .putData("score", "850")
                .putData("time", "2:45")
                .setToken(token)
                .build();
        try {
            String response = FirebaseMessaging.getInstance().send(message);
            log.info("FCMsend-" + response);
        } catch (FirebaseMessagingException e) {
            log.info("FCMexcept-" + e.getMessage());
        }

    }

}
