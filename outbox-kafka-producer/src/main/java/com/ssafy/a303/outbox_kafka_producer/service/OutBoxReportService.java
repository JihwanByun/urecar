package com.ssafy.a303.outbox_kafka_producer.service;

import com.ssafy.a303.outbox_kafka_producer.KafkaProducer;
import com.ssafy.a303.outbox_kafka_producer.entity.OutboxReport;
import com.ssafy.a303.outbox_kafka_producer.entity.OutboxStatus;
import com.ssafy.a303.outbox_kafka_producer.repository.OutboxReportRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.CompletableFuture;

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

    @Transactional
    public void publishMessage(){
        // read from table
        List<OutboxReport> list = outboxReportRepository.findAll();
        if(list.isEmpty()){
            return;
        }

        // publish msg to kafka
        for(OutboxReport report : list){

            String topic = report.getOutboxStatus() == OutboxStatus.FIRST_WAIT ? "first_wait" : "second_wait";
            CompletableFuture<SendResult<String, OutboxReport>> result = kafkaProducer.sendMessageWithKey(topic, String.valueOf(LocalDateTime.now()), report);
            result.thenAccept(sendResult -> {
                log.info("produced successfully");
                outboxReportRepository.deleteById(report.getId());
            }).exceptionally(ex ->{
                log.info("publish failed");
                return null;
                    }
            );
        }
    }
}
