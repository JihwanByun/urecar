package com.ssafy.a303.outbox_kafka_producer.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Builder;

@Entity
@Builder
public class OutboxReport{

    @Id
    int id;
}