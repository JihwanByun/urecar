package com.ssafy.a303.outbox_kafka_producer.service;

import com.ssafy.a303.outbox_kafka_producer.KafkaProducer;
import com.ssafy.a303.outbox_kafka_producer.repository.OutboxReportRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Slf4j
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
        kafkaProducer.sendMessage("test","test +" + LocalDateTime.now());
//        log.info("topic 1");
//        kafkaProducer.sendMe
//        Random random = new Random();
//        kafkaProducer.sendMessageKey("test", String.valueOf(random.nextInt(6) % 6),"L" + LocalDateTime.now());
    }
}
