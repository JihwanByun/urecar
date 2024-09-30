package com.ssafy.a303.outbox_kafka_producer.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Entity
@ToString(exclude = {"member"})
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Report {

    @Id
    @GeneratedValue
    @Column(name = "REPORT_ID")
    private long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

    @Column(length = 1_000)
    private String content;
    private String type;

    @Column(nullable = false)
    private String firstImage;
    private String secondImage;

    private LocalDateTime createdAt;

    @Column(nullable = false)
    private double latitude;
    @Column(nullable = false)
    private double longitude;

    @Enumerated(EnumType.STRING)
    private ProcessStatus processStatus;

    @Builder
    public Report(Member member, String content, String firstImage,
                  LocalDateTime createdAt, double latitude, double longitude, ProcessStatus processStatus) {
        this.member = member;
        this.content = content;
        this.firstImage = firstImage;
        this.createdAt = createdAt;
        this.latitude = latitude;
        this.longitude = longitude;
        this.processStatus = processStatus;
    }

    public void updateSecondImage(String secondImage) {
        this.secondImage = secondImage;
    }

}

