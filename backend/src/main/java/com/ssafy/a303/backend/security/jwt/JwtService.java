package com.ssafy.a303.backend.security.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class JwtService {

    private final static String LOGOUT = "logout";
    private final JwtRepository refreshTokenRepository;

    public void saveRefreshToken(String email, String refreshToken) {
        refreshTokenRepository.save(email, refreshToken, JwtUtil.getExpiredTime(refreshToken));
    }

    public void saveLogoutAccessToken(String accessToken) {
        refreshTokenRepository.save(accessToken, LOGOUT, JwtUtil.getExpiredTime(accessToken));
    }

    public boolean isTokenStored(String token) {
        String savedToken = (String)refreshTokenRepository.findByKey(JwtUtil.getLoginEmail(token));
        if(savedToken == null) {
            return false;
        }
        return savedToken.equals(token);
    }

    public boolean isLogoutAccessToken(String accessToken) {
        return refreshTokenRepository.hasKey(accessToken);
    }

    public void deleteRefreshToken(String email) {
        refreshTokenRepository.delete(email);
    }

}
