package com.ssafy.a303.backend.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

import jakarta.annotation.PostConstruct;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class JwtUtil {

    private static final String JTW_PREFIX = "Bearer ";
    private static final String MEMBER_EMAIL = "memberEmail";

    private static SecretKey KEY;
    private static String ISSUER;
    private static long ACCESS_EXPIRED_TIME;
    private static long REFRESH_EXPIRED_TIME;

    @Value("${spring.application.name}")
    private String issuer;

    @Value("${jwt.token.secret}")
    private String secretKey;

    @Value("${jwt.token.access-expired-time}")
    private long accessExpiredTime;

    @Value("${jwt.token.refresh-expired-time}")
    private long refreshExpiredTime;

    @PostConstruct
    public void init() {
        ISSUER = this.issuer;
        ACCESS_EXPIRED_TIME = this.accessExpiredTime;
        REFRESH_EXPIRED_TIME = this.refreshExpiredTime;
        KEY = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
    }

    public static String createAccessToken(String email){
        return Jwts.builder()
                .issuer(ISSUER)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + ACCESS_EXPIRED_TIME))
                .claim(MEMBER_EMAIL, email)
                .signWith(KEY)
                .compact();
    }

    public static String createRefreshToken(String email){
        return Jwts.builder()
                .issuer(ISSUER)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + REFRESH_EXPIRED_TIME))
                .claim(MEMBER_EMAIL, email)
                .signWith(KEY)
                .compact();
    }

    public static String getLoginEmail(String token) {
        return isStartWithJwtPrefix(token)
                ? decodeJwt(removeJwtPrefix(token)).get(MEMBER_EMAIL).toString()
                : decodeJwt(token).get(MEMBER_EMAIL).toString();
    }

    public static Long getExpiredTime(String token) {
        return isStartWithJwtPrefix(token)
                ? (decodeJwt(removeJwtPrefix(token)).getExpiration().getTime() - System.currentTimeMillis()) / 1000
                : (decodeJwt(token).getExpiration().getTime() - System.currentTimeMillis()) / 1000;
    }

    public static boolean isExpired(String token) {
        return isStartWithJwtPrefix(token)
                ? decodeJwt(removeJwtPrefix(token)).getExpiration().before(new Date())
                : decodeJwt(token).getExpiration().before(new Date());
    }

    public static Claims decodeJwt(String token) {
        return Jwts.parser()
                .verifyWith(KEY)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public static String removeJwtPrefix(String token) {
        return token.split(" ")[1];
    }

    private static boolean isStartWithJwtPrefix(String token) {
        return token.startsWith(JTW_PREFIX);
    }

}
