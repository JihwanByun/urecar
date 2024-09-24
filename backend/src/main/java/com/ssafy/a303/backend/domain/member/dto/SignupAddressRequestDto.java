package com.ssafy.a303.backend.domain.member.dto;

import lombok.Getter;

@Getter
public class SignupAddressRequestDto {

    private String address;
    private String addressDetail;
    private String zipCode;

}
