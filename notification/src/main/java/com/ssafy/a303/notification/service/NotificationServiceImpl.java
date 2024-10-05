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

    private final static String TITLE = "UreCar";
    private final static String FIRST_SUCCESS = "첫 번째 사진이 수용되었습니다.";
    private final static String FIRST_FAILURE = "첫 번째 사진이 불수용되었습니다.";
    private final static String SECOND_SUCCESS = "두 번째 사진이 수용되었습니다.";
    private final static String SECOND_FAILURE = "두 번째 사진이 불수용되었습니다.";


    @Override
    public void sendFirstNotification(NotificationRequestDto dto) {
        if (dto.getResult()) {
            sendByToken(NotificationSendToFcmServerDto.builder()
                    .memberId(dto.getMemberId())
                    .title(TITLE)
                    .content(FIRST_SUCCESS)
                    .clientToken(dto.getToken())
                    .build());
            return;
        }

        sendByToken(NotificationSendToFcmServerDto.builder()
                .memberId(dto.getMemberId())
                .title(TITLE)
                .content(FIRST_FAILURE)
                .clientToken(dto.getToken())
                .build());
    }

    @Override
    public void sendSecondNotification(NotificationRequestDto dto) {
        if (dto.getResult()) {
            sendByToken(NotificationSendToFcmServerDto.builder()
                    .memberId(dto.getMemberId())
                    .title(TITLE)
                    .content(SECOND_SUCCESS)
                    .clientToken(dto.getToken())
                    .build());
            return;
        }

        sendByToken(NotificationSendToFcmServerDto.builder()
                .memberId(dto.getMemberId())
                .title(TITLE)
                .content(SECOND_FAILURE)
                .clientToken(dto.getToken())
                .build());
    }

    public void sendByToken(NotificationSendToFcmServerDto dto) {
        Message message = Message.builder()
                .setNotification(Notification.builder()
                        .setTitle(dto.getTitle())
                        .setBody(dto.getContent())
                        .build())
                .setToken(dto.getClientToken())
                .build();
        try {
            String response = FirebaseMessaging.getInstance().send(message);
            log.info("FCMsend-" + response);
        } catch (FirebaseMessagingException e) {
            log.info("FCMexcept-" + e.getMessage());
        }

    }

}
