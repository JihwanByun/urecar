package com.ssafy.a303.backend.domain.member.dto;

import lombok.Getter;

@Getter
public class MemberUpdateRequestDto {

    private String email;
    private String password;
    private String tel;

}
