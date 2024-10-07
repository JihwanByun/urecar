package com.ssafy.a303.backend.security.dto;

import com.ssafy.a303.backend.domain.member.entity.Role;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LoginResponseDto {

    private String accessToken;
    private Long memberId;
    private String memberName;
    private Role memberRole;

}
