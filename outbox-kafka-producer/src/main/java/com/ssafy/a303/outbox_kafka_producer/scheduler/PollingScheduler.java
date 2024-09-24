package com.ssafy.a303.outbox_kafka_producer.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ssafy.a303.outbox_kafka_producer.service.OutBoxReportService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class PollingScheduler {
    
    private final OutBoxReportService outBoxReportService;

    @Scheduled(fixedDelay = 2000)
    public void pollingDatabase(){
        System.out.println("polling");
        outBoxReportService.publishMessage();
    }
}
