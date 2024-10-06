package com.ssafy.a303.outbox_kafka_producer.scheduler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ssafy.a303.outbox_kafka_producer.service.OutBoxReportService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
@Slf4j
public class PollingScheduler {
    
    private final OutBoxReportService outBoxReportService;

    @Scheduled(fixedDelay = 1000)
    public void pollingDatabase(){
        log.info("polling");
        outBoxReportService.publishMessage();
    }
}
