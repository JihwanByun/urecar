package com.ssafy.a303.outbox_kafka_producer.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.mapping.KPropertyPathExtensionsKt;
import org.springframework.stereotype.Service;

import com.ssafy.a303.outbox_kafka_producer.KafkaProducer;
import com.ssafy.a303.outbox_kafka_producer.repository.OutboxReportRepository;

import lombok.RequiredArgsConstructor;

@Service
public class OutBoxReportService {
    
    private final String firstRequest;

    private final String secondRequest;

    private final OutboxReportRepository outboxReportRepository;

    private final KafkaProducer kafkaProducer;

    public OutBoxReportService(@Value("${spring.kafka.topic.name.first-request}") String firstRequest,
    @Value("${spring.kafka.topic.name.second-request}") String secondRequest, 
    OutboxReportRepository outboxReportRepository, KafkaProducer kafkaProducer){
        this.firstRequest = firstRequest;
        this.secondRequest = secondRequest;
        this.outboxReportRepository = outboxReportRepository;
        this.kafkaProducer = kafkaProducer;
    }
    public void publishMessage(){
        // read from table
        
        // publish msg to kafka
        kafkaProducer.sendMessage(firstRequest, "firstRequest" + LocalDateTime.now());
        System.out.println("topic 1 sent");
        kafkaProducer.sendMessage(secondRequest, "secondRequest" + LocalDateTime.now());
        System.out.println("topic 2 sent");
        // delete outbox column
    }
}
