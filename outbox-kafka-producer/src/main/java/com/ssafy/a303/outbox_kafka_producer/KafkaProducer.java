package com.ssafy.a303.outbox_kafka_producer;

import com.ssafy.a303.outbox_kafka_producer.repository.OutboxReportRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class KafkaProducer {
    
    private final KafkaTemplate<String, String> kafkaTemplate;
    private final OutboxReportRepository outboxReportRepository;

    public void sendMessage(String topic, String message){

    kafkaTemplate.send(topic, message).thenAccept(result -> {
                log.info("Message sent to partition: " + result.getRecordMetadata().partition());
            })
            .exceptionally(ex -> {
                System.err.println("Message sending failed: " + ex.getMessage());
                return null;
            });
    }

    public void sendMessageKey(String topic, String key,String message){

        kafkaTemplate.send(topic, key, message).thenAccept(result -> {
                    System.out.println("Message sent to partition: " + result.getRecordMetadata().partition());
                    log.info("key = {}", key);
                })
                .exceptionally(ex -> {
                    System.err.println("Message sending failed: " + ex.getMessage());
                    return null;
                });

    }
}
