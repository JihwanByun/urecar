package com.ssafy.a303.backend.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.domain.member.entity.Member;
import com.ssafy.a303.backend.domain.member.service.MemberService;
import com.ssafy.a303.backend.security.dto.LoginResponseDto;
import com.ssafy.a303.backend.security.jwt.JwtService;
import com.ssafy.a303.backend.security.jwt.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final JwtService jwtService;
    private final MemberService memberService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        Member member = memberService.getMemberByEmail(authentication.getName());

        String accessToken = JwtUtil.createAccessToken(member.getEmail());
        String refreshToken = JwtUtil.createRefreshToken(authentication.getName());
        jwtService.saveRefreshToken(authentication.getName(), refreshToken);

        response.setStatus(HttpStatus.OK.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        objectMapper.writeValue(response.getWriter(),
                LoginResponseDto.builder()
                        .accessToken(accessToken)
                        .memberId(member.getId())
                        .memberName(member.getName())
                        .memberRole(member.getRole())
                        .build());
    }


}
