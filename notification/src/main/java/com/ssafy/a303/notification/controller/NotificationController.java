package com.ssafy.a303.notification.controller;

import com.ssafy.a303.notification.dto.NotificationRequestDto;
import com.ssafy.a303.notification.service.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/first")
    public ResponseEntity<Void> sendFirstNotification(@RequestBody NotificationRequestDto dto) {
        notificationService.sendFirstNotification(dto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/second")
    public ResponseEntity<Void> sendSecondNotification(@RequestBody NotificationRequestDto dto) {
        notificationService.sendSecondNotification(dto);
        return ResponseEntity.ok().build();
    }

}
