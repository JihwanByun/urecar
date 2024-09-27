package com.ssafy.a303.backend.security.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LoginResponseDto {

    private String accessToken;
    private Long memberId;
    private String memberName;

}
