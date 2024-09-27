package com.ssafy.a303.backend.security.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.security.dto.LoginRequestDto;
import com.ssafy.a303.backend.security.user.AuthenticationProviderImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.util.StreamUtils;

/**
 * 사용자 인증을 위한 Filter(login 을 위한 filter)
 * AbstractAuthenticationProcessingFilter: UsernamePasswordAuthenticationFilter 의 추상클래스
 */
@Slf4j
public class JsonUsernamePasswordAuthenticationFilter extends AbstractAuthenticationProcessingFilter {

    private static final String DEFAULT_LOGIN_REQUEST_URL = "/login";
    private static final String HTTP_METHOD = "POST";
    private static final String CONTENT_TYPE = "application/json; charset=utf-8";
    private static final AntPathRequestMatcher DEFAULT_LOGIN_PATH_REQUEST_MATCHER =
            new AntPathRequestMatcher(DEFAULT_LOGIN_REQUEST_URL, HTTP_METHOD);

    private final ObjectMapper objectMapper;
    private final AuthenticationProviderImpl authenticationProvider;

    public JsonUsernamePasswordAuthenticationFilter(ObjectMapper objectMapper,AuthenticationProviderImpl authenticationProvider) {
        super(DEFAULT_LOGIN_PATH_REQUEST_MATCHER);
        this.objectMapper = objectMapper;
        this.authenticationProvider = authenticationProvider;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (request.getContentType() == null || !request.getContentType().equals(CONTENT_TYPE)) {
            throw new AuthenticationServiceException("Authentication Content-Type not supported: " + request.getContentType());
        }
        LoginRequestDto loginRequestDto = objectMapper.readValue(StreamUtils.copyToString(request.getInputStream(), StandardCharsets.UTF_8), LoginRequestDto.class);

        String username = loginRequestDto.getEmail();
        String password = loginRequestDto.getPassword();
        if (username == null || password == null) {
            throw new AuthenticationServiceException("DATA IS MISS");
        }
        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password);

        setDetails(request, authRequest);
        return authenticationProvider.authenticate(authRequest);
    }

    protected void setDetails(HttpServletRequest request, UsernamePasswordAuthenticationToken authRequest) {
        authRequest.setDetails(this.authenticationDetailsSource.buildDetails(request));
    }

}
