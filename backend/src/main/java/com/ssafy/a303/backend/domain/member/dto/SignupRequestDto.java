package com.ssafy.a303.backend.domain.member.dto;

import lombok.Getter;

@Getter
public class SignupRequestDto {

    private String email;
    private String password;
    private String name;
    private String tel;
    private SignupAddressRequestDto address;

}
