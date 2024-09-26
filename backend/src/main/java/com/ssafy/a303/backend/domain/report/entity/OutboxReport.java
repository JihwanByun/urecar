package com.ssafy.a303.backend.domain.report.entity;

import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;

public class OutboxReport extends Report {

    @Enumerated(EnumType.STRING)
    private OutboxStatus outboxStatus;

}
