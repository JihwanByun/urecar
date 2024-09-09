package com.ssafy.a303.outbox_kafka_producer;

import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class KafkaProducer {
    
    private final KafkaTemplate<String, String> kafkaTemplate;

    public void sendMessage(String topic, String message){

    kafkaTemplate.send(topic, message).thenAccept(result -> {
                System.out.println("Message sent to partition: " + result.getRecordMetadata().partition());
            })
            .exceptionally(ex -> {
                System.err.println("Message sending failed: " + ex.getMessage());
                return null;
            });

    }

}
