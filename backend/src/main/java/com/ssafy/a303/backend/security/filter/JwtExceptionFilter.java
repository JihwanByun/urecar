package com.ssafy.a303.backend.security.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import com.ssafy.a303.backend.exception.ErrorResponse;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtExceptionFilter extends OncePerRequestFilter {

    ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws IOException, ServletException {
        try {
            chain.doFilter(req, res);
        } catch (CustomException e) {
            setErrorResponse(req, res, e);
        }
    }

    public void setErrorResponse(HttpServletRequest req, HttpServletResponse response, Throwable ex) throws IOException {
        Object exception = req.getAttribute("exception");
        response.setHeader("Content-type","application/json");
        response.setCharacterEncoding("utf-8");
        if(exception instanceof ErrorCode){
            ErrorCode errorCode = (ErrorCode) exception;
            response.setStatus(errorCode.getStatus());
            response.getWriter().write(objectMapper.writeValueAsString(new ErrorResponse(errorCode)));
            return;
        }

        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, ex.getMessage());
    }

}
