package com.ssafy.a303.backend.domain.report.entity;

import jakarta.persistence.*;
import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Getter
public class DistinctIllegalParkingZone {

    @Id
    @GeneratedValue
    @Column(name = "zone_id")
    private long id;

    private LocalDate enforcementDate;
    private LocalTime enforcementTime;

    private String oldAddress;
    private String newAddress;

    @Embedded
    private Location location;
}
