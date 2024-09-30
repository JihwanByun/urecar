package com.ssafy.a303.outbox_kafka_producer.entity;

public enum ProcessStatus {

    ONGOING, ACCEPTED, UNACCEPTED, CANCELLED_FIRST_FAILED, CANCELLED_SECOND_FAILED

}
