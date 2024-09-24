package com.ssafy.a303.backend.security.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LoginResponseDto {

    String accessToken;

}
