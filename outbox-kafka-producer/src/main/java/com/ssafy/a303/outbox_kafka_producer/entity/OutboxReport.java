package com.ssafy.a303.outbox_kafka_producer.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
public class OutboxReport {

    @Id
    @GeneratedValue
    private long id;

    @Enumerated(EnumType.STRING)
    private OutboxStatus outboxStatus;

    private int memberId;

    private long reportId;

    private String firstImage;

    private String secondImage;

    private String token;
}

