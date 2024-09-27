package com.ssafy.a303.outbox_kafka_producer.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class OutboxReport {

    @Id
    @GeneratedValue
    private long id;

    @Enumerated(EnumType.STRING)
    private OutboxStatus outboxStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "REPORT_ID")
    private Report report;

    @Column(nullable = false)
    private String firstImage;
    private String secondImage;

    @Builder
    public OutboxReport(Report report, Member member, String firstImage, String secondImage, OutboxStatus outboxStatus) {
        this.report = report;
        this.member = member;
        this.firstImage = firstImage;
        this.secondImage = secondImage;
        this.outboxStatus = outboxStatus;
    }

}

