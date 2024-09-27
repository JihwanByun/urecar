package com.ssafy.a303.backend.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.exception.ErrorCode;
import com.ssafy.a303.backend.exception.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class JwtAccessDeniedHandler implements AccessDeniedHandler {

    ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException {
        response.setHeader("Content-type","application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(ErrorCode.UNAUTHORIZED_ACCESS.getStatus());
        response.getWriter().write(objectMapper.writeValueAsString(new ErrorResponse(ErrorCode.UNAUTHORIZED_ACCESS)));
    }

}
