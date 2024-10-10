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
import java.util.List;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class ResultNotificationServiceImpl implements ResultNotificationService {

    private final static String TITLE = "UreCar";
    private final static String FIRST_SUCCESS = "%d 신고 분석이 완료되었습니다.\n(검증 성공)";
    private final static String FIRST_FAILURE = "%d 신고 분석이 완료되었습니다.\n(검증 실패)";
    private final static String SECOND_SUCCESS = "%d 신고가 정상 접수되었습니다.";
    private final static String SECOND_FAILURE = "%d 2차 분석이 완료되었습니다.\n(검증 실패)";
    private final static String ANALYSIS_SUCCESS = "%d 신고가 수용되었습니다.\n";
    private final static String ANALYSIS_FAILURE = "%d 신고가 불수용되었습니다.\n";

    private final ResultNotificationRepository resultNotificationRepository;

    public ResultNotificationServiceImpl(ResultNotificationRepository notificationRepository) {
        this.resultNotificationRepository = notificationRepository;
    }

    @Transactional
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

    @Transactional
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

    @Transactional
    @Override
    public void sendResultNotification(NotificationRequestDto dto) {
        sendByToken(NotificationSendToFcmServerDto.builder()
                .memberId(dto.getMemberId())
                .title(TITLE)
                .content(dto.getResult() ? ANALYSIS_SUCCESS : ANALYSIS_FAILURE)
                .reportId(dto.getReportId())
                .clientToken(dto.getToken())
                .createAt(LocalDateTime.now())
                .build());
    }

    @Transactional
    public void sendByToken(NotificationSendToFcmServerDto dto) {
        Message message = Message.builder()
                .setNotification(Notification.builder()
                        .setTitle(dto.getTitle())
                        .setBody(String.format(dto.getContent(), dto.getReportId()))
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
        return resultNotificationRepository.findByMemberIdAndIsDeletedFalseOrderByCreatedAtDesc(memberId)
                .stream()
                .map(resultNotification -> NotificationResponseDto.builder()
                        .notificationId(resultNotification.getId())
                        .content(resultNotification.getContent())
                        .datetime(resultNotification.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                        .reportId(resultNotification.getReportId())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    public void deleteByNotificationId(long notificationId) {
        ResultNotification resultNotification = resultNotificationRepository.findById(notificationId);
        resultNotification.removeNotification();
        resultNotificationRepository.save(resultNotification);
    }

    @Transactional
    public void deleteByMemberId(long memberId) {
        List<ResultNotification> notifications = resultNotificationRepository.findByMemberIdAndIsDeletedFalseOrderByCreatedAtDesc(memberId);
        notifications.forEach(ResultNotification::removeNotification); // 상태만 변경
        resultNotificationRepository.saveAll(notifications); // 일괄 저장
    }

}
