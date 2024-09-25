package com.ssafy.a303.outbox_kafka_producer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class OutboxKafkaProducerApplication {

	public static void main(String[] args) {
		SpringApplication.run(OutboxKafkaProducerApplication.class, args);
	}

}
