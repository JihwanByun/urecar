package com.ssafy.a303.backend.domain.member.entity;

import jakarta.persistence.Embeddable;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.NoArgsConstructor;

@Embeddable
@NoArgsConstructor(access =  AccessLevel.PROTECTED)
public class Address {

    private String address;
    private String addressDetail;
    private String zipCode;

    @Builder
    public Address(String address, String addressDetail, String zipCode) {
        this.address = address;
        this.addressDetail = addressDetail;
        this.zipCode = zipCode;
    }

}
