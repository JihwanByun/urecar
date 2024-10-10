package com.ssafy.a303.notification.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.ssafy.a303.notification.dto.NotificationRequestDto;
import com.ssafy.a303.notification.dto.NotificationResponseDto;
import com.ssafy.a303.notification.dto.NotificationSendToFcmServerDto;
import com.ssafy.a303.notification.entity.ResultNotification;
import com.ssafy.a303.notification.repository.ResultNotificationRepository;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class ResultNotificationServiceImpl implements ResultNotificationService {

    private final static String TITLE = "UreCar";
    private final static String FIRST_SUCCESS = "첫 번째 사진이 수용되었습니다.";
    private final static String FIRST_FAILURE = "첫 번째 사진이 불수용되었습니다.";
    private final static String SECOND_SUCCESS = "두 번째 사진이 수용되었습니다.";
    private final static String SECOND_FAILURE = "두 번째 사진이 불수용되었습니다.";

    private final ResultNotificationRepository resultNotificationRepository;

    public ResultNotificationServiceImpl(ResultNotificationRepository notificationRepository) {
        this.resultNotificationRepository = notificationRepository;
    }

    @Override
    public void sendFirstNotification(NotificationRequestDto dto) {
        sendByToken(NotificationSendToFcmServerDto.builder()
                .memberId(dto.getMemberId())
                .title(TITLE)
                .content(dto.getResult() ? FIRST_SUCCESS : FIRST_FAILURE)
                .reportId(dto.getReportId())
                .clientToken(dto.getToken())
                .createAt(LocalDateTime.now())
                .build());
    }

    @Override
    public void sendSecondNotification(NotificationRequestDto dto) {
        sendByToken(NotificationSendToFcmServerDto.builder()
                .memberId(dto.getMemberId())
                .title(TITLE)
                .content(dto.getResult() ? SECOND_SUCCESS : SECOND_FAILURE)
                .reportId(dto.getReportId())
                .clientToken(dto.getToken())
                .createAt(LocalDateTime.now())
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
            FirebaseMessaging.getInstance().send(message);
        } catch (FirebaseMessagingException ignored) {}

        resultNotificationRepository.save(ResultNotification.builder()
                .title(dto.getTitle())
                .content(dto.getContent())
                .createdAt(dto.getCreateAt())
                .memberId(dto.getMemberId())
                .reportId(dto.getReportId())
                .build());
    }

    @Override
    public List<NotificationResponseDto> getNotifications(long memberId) {
        List<ResultNotification> notifications = resultNotificationRepository.findByMemberIdAndIsDeletedFalseOrderByCreatedAtDesc(memberId);
        List<NotificationResponseDto> dtos = new ArrayList<>();
        for (ResultNotification resultNotification : notifications) {
            dtos.add(
                    NotificationResponseDto.builder()
                            .notificationId(resultNotification.getId())
                            .content(resultNotification.getContent())
                            .datetime(resultNotification.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                            .reportId(resultNotification.getReportId())
                            .build()
            );
        }

        return dtos;
    }

    @Override
    public void deleteByNotificationId(long notificationId) {
        ResultNotification resultNotification = resultNotificationRepository.findById(notificationId);
        resultNotification.removeNotification();
        resultNotificationRepository.save(resultNotification);
    }

    @Override
    public void deleteByMemberId(long memberId) {
        List<ResultNotification> notifications = resultNotificationRepository.findByMemberIdAndIsDeletedFalseOrderByCreatedAtDesc(memberId);
        for (ResultNotification resultNotifications : notifications) {
            resultNotifications.removeNotification();
            resultNotificationRepository.save(resultNotifications);
        }
    }

}
