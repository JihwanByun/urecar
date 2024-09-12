package com.ssafy.a303.backend.security.handler;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.domain.member.entity.Member;
import com.ssafy.a303.backend.domain.member.repository.MemberRepository;
import com.ssafy.a303.backend.security.dto.LoginResponseDto;
import com.ssafy.a303.backend.security.jwt.JwtService;
import com.ssafy.a303.backend.security.jwt.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Component
@Slf4j
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final MemberRepository memberRepository;
    private final ObjectMapper objectMapper;
    private final JwtService jwtService;

    @Override
    @Transactional
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException {
        String accessToken = JwtUtil.createAccessToken(memberRepository.findByEmail(authentication.getName()));
        String refreshToken = JwtUtil.createRefreshToken(authentication.getName());
        jwtService.saveRefreshToken(authentication.getName(), refreshToken);
        log.info("refresh token: {}", refreshToken);
//        Cookie refreshTokenCookie = createCookie(authentication.getName());
//        jwtService.saveRefreshToken(authentication.getName(), refreshTokenCookie.getValue());
//        log.debug("redis store data: {}", refreshTokenCookie.getValue());

        response.setStatus(HttpStatus.OK.value());
//        response.addCookie(refreshTokenCookie);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        Member member = memberRepository.findByEmail(authentication.getName());
        LoginResponseDto loginResponseDto = null;
//        LoginResponseDto loginResponseDto = LoginResponseDto.of(accessToken, refreshToken, member);
//
//        if (member.getKindergarten() != null) {
//            loginResponseDto.setKindergartenId(member.getKindergarten().getId());
//        }
//
//        if (member.getBan() != null) {
//            loginResponseDto.setBanId(member.getBan().getId());
//        }
//
//        if (member.getKidMember() != null && member.getMemberStatus() == atype.ACCEPT) {
//            List<KidMember> kidMembers = member.getKidMember();
//            for (KidMember kidMember : kidMembers) {
//                Kid kid = kidMember.getKid();
//                loginResponseDto.setKidId(kid.getId());
//                loginResponseDto.setKindergartenId(kid.getKindergarten().getId());
//                loginResponseDto.setBanId(kid.getBan().getId());
//            }
//        }

        objectMapper.writeValue(response.getWriter(), loginResponseDto);
    }

//    private Cookie createCookie(String userName) {
//        String cookieName = "refreshToken";
//        String cookieValue = JwtUtil.createRefreshToken((userName));
//        Cookie cookie = new Cookie(cookieName, cookieValue);
//        cookie.setHttpOnly(false);
//        cookie.setSecure(true);
//        cookie.setPath("/");
//        cookie.setAttribute("SameSite", "None");
//        cookie.setMaxAge(60 * 60 * 24 * 14);
//        return cookie;
//    }

}
