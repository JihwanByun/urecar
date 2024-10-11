package com.ssafy.a303.notification.controller;

import com.ssafy.a303.notification.dto.NotificationRequestDto;
import com.ssafy.a303.notification.dto.NotificationResponseDto;
import com.ssafy.a303.notification.service.ResultNotificationService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/notifications")
public class ResultNotificationController {

    private final ResultNotificationService resultNotificationService;

    public ResultNotificationController(ResultNotificationService resultNotificationService) {
        this.resultNotificationService = resultNotificationService;
    }

    @PostMapping("/first")
    public ResponseEntity<Void> sendFirstNotification(@RequestBody NotificationRequestDto dto) {
        resultNotificationService.sendFirstNotification(dto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/one-minute")
    public ResponseEntity<Void> sendOneMinuteNotification(@RequestBody NotificationRequestDto dto) {
        resultNotificationService.sendOneMinuteNotification(dto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/second")
    public ResponseEntity<Void> sendSecondNotification(@RequestBody NotificationRequestDto dto) {
        resultNotificationService.sendSecondNotification(dto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/result")
    public ResponseEntity<Void> sendResultNotification(@RequestBody NotificationRequestDto dto) {
        resultNotificationService.sendResultNotification(dto);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{memberId}")
    public ResponseEntity<List<NotificationResponseDto>> getNotificationsPerMember(@PathVariable long memberId) {
        return ResponseEntity.ok().body(resultNotificationService.getNotifications(memberId));
    }

    @DeleteMapping("/{notificationId}")
    public ResponseEntity<Void> deleteNotification(@PathVariable long notificationId) {
        resultNotificationService.deleteByNotificationId(notificationId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/all/{memberId}")
    public ResponseEntity<Void> deleteAllNotifications(@PathVariable long memberId) {
        resultNotificationService.deleteByMemberId(memberId);
        return ResponseEntity.ok().build();
    }

}
