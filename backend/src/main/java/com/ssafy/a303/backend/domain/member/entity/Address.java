package com.ssafy.a303.backend.domain.member.entity;

import jakarta.persistence.Embeddable;

@Embeddable
public class Address {

    private String address;
    private String addressDetail;
    private String zipCode;

}
