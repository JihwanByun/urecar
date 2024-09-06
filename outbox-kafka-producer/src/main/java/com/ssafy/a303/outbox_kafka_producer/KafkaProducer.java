package com.ssafy.a303.outbox_kafka_producer;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class KafkaProducer {
    
    private final KafkaTemplate<String, String> kafkaTemplate;

    public void sendMessage(String topic, String message){
        kafkaTemplate.send(topic, message);
    }

}
