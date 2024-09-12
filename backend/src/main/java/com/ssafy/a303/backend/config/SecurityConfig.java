package com.ssafy.a303.backend.config;

import com.ssafy.a303.backend.security.handler.JwtAccessDeniedHandler;
import com.ssafy.a303.backend.security.handler.LoginSuccessHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    public SecurityFilterChain configure(HttpSecurity http, LoginSuccessHandler loginSuccessHandler, JwtAccessDeniedHandler jwtAccessDeniedHandler) throws Exception {

        http
                .csrf(AbstractHttpConfigurer::disable) //REST API는 사용자의 정보를 기억하지 않기 때문에 꺼도 됨
                .cors(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        http
                .formLogin(config -> config.successHandler(loginSuccessHandler));

        http
                .authorizeHttpRequests(
                        authorize -> authorize
                                .requestMatchers("/swagger", "/swagger-ui.html", "/swagger-ui/*", "/api-docs", "/api-docs/*", "/v3/api-docs/*").permitAll()
                                .requestMatchers(HttpMethod.POST, "/login", "/signup").permitAll()
                                .requestMatchers(HttpMethod.OPTIONS,"/**").permitAll()
                                .anyRequest().permitAll()
                );

//        http
//                .addFilterBefore(jsonUsernamePasswordAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class)
//                .addFilterBefore(new JwtAuthenticationFilter(memberService, jwtService, userDetailsService), UsernamePasswordAuthenticationFilter.class)
//                .addFilterBefore(jwtExceptionFilter, JwtAuthenticationFilter.class);

        http
                .exceptionHandling((exceptionHandling) ->
                        exceptionHandling.accessDeniedHandler(jwtAccessDeniedHandler)
                );
//
//        http
//                .logout((logout) -> logout
//                        .permitAll()
//                        .logoutSuccessHandler(((request, response, authentication) -> {
//                            memberService.deleteNotificationToken(request.getHeader("Authorization"));
//                            jwtService.saveLogoutAccessToken(request.getHeader("Authorization"));
//                            jwtService.deleteRefreshToken(JwtUtil.getLoginEmail(request.getHeader("Authorization")));
//                        }))
//                );

        return http.build();
    }

}
