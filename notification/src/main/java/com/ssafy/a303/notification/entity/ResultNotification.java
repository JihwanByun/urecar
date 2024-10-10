package com.ssafy.a303.notification.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ResultNotification {

    @Id
    @GeneratedValue
    @Column(name = "NOTIFICATION_ID")
    private long id;

    private String title;
    private String content;

    private LocalDateTime createdAt;

    private long memberId;
    private long reportId;

    @ColumnDefault("false")
    private boolean isDeleted;

    @Builder
    public ResultNotification(String title, String content, LocalDateTime createdAt, long memberId, long reportId) {
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.memberId = memberId;
        this.reportId = reportId;
    }

    public void removeNotification() {
        this.isDeleted = true;
    }

}
