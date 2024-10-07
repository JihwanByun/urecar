package com.ssafy.a303.outbox_kafka_producer;

import com.ssafy.a303.outbox_kafka_producer.entity.OutboxReport;
import com.ssafy.a303.outbox_kafka_producer.repository.OutboxReportRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Slf4j
@RequiredArgsConstructor
@Service
public class KafkaProducer {
    
    private final KafkaTemplate<String, OutboxReport> kafkaTemplate;

    public CompletableFuture<SendResult<String, OutboxReport>> sendMessageWithKey(String topic, String key, OutboxReport report){

        return kafkaTemplate.send(topic, key, report);

    }
}
