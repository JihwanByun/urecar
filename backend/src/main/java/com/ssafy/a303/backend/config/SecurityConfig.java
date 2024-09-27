package com.ssafy.a303.backend.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.domain.member.service.MemberService;
import com.ssafy.a303.backend.security.filter.JsonUsernamePasswordAuthenticationFilter;
import com.ssafy.a303.backend.security.filter.JwtAuthenticationFilter;
import com.ssafy.a303.backend.security.filter.JwtExceptionFilter;
import com.ssafy.a303.backend.security.handler.JwtAccessDeniedHandler;
import com.ssafy.a303.backend.security.handler.LoginFailureHandler;
import com.ssafy.a303.backend.security.handler.LoginSuccessHandler;
import com.ssafy.a303.backend.security.jwt.JwtService;
import com.ssafy.a303.backend.security.jwt.JwtUtil;
import com.ssafy.a303.backend.security.user.AuthenticationProviderImpl;
import com.ssafy.a303.backend.security.user.UserDetailsServiceImpl;
import java.util.Arrays;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Slf4j
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig  {

    private final ObjectMapper objectMapper;
    private final UserDetailsServiceImpl userDetailsService;
    private final AuthenticationProviderImpl authenticationProvider;
    private final LoginSuccessHandler loginSuccessHandler;
    private final LoginFailureHandler loginFailureHandler;
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;
    private final JwtExceptionFilter jwtExceptionFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, MemberService memberService, JwtService jwtService) throws Exception {

        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors((cors) -> cors.configurationSource(corsConfigurationSource()))
                .httpBasic(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        http
                .formLogin(config -> config
                        .successHandler(loginSuccessHandler));

        http
                .authorizeHttpRequests(
                        authorize -> authorize
                                .requestMatchers("/actuator/**","/actuator/prometheus", "/swagger", "/swagger-ui.html", "/swagger-ui/*", "/api-docs", "/api-docs/*", "/v3/api-docs/*").permitAll()
                                .requestMatchers(HttpMethod.POST, "/login", "/signup").permitAll()
                                .requestMatchers(HttpMethod.OPTIONS,"/**").permitAll()
                                .anyRequest().permitAll()
                );

        http
                .addFilterBefore(jsonUsernamePasswordAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(new JwtAuthenticationFilter(memberService, jwtService, userDetailsService), UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(jwtExceptionFilter, JwtAuthenticationFilter.class);

        http
                .exceptionHandling((exceptionHandling) ->
                        exceptionHandling.accessDeniedHandler(jwtAccessDeniedHandler)
                );

        http
                .logout((logout) -> logout
                        .permitAll()
                        .logoutSuccessHandler(((request, response, authentication) -> {
                            jwtService.saveLogoutAccessToken(request.getHeader("Authorization"));
                            jwtService.deleteRefreshToken(JwtUtil.getLoginEmail(request.getHeader("Authorization")));
                        }))
                );

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.addAllowedOriginPattern("*");
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowCredentials(true);
        configuration.addAllowedHeader("*");
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public JsonUsernamePasswordAuthenticationFilter jsonUsernamePasswordAuthenticationFilter() {
        JsonUsernamePasswordAuthenticationFilter jsonUsernamePasswordAuthenticationFilter
                = new JsonUsernamePasswordAuthenticationFilter(objectMapper, authenticationProvider);
        jsonUsernamePasswordAuthenticationFilter.setAuthenticationManager(authenticationManager());
        jsonUsernamePasswordAuthenticationFilter.setAuthenticationSuccessHandler(loginSuccessHandler);
        jsonUsernamePasswordAuthenticationFilter.setAuthenticationFailureHandler(loginFailureHandler);

        return jsonUsernamePasswordAuthenticationFilter;
    }

    @Bean
    public AuthenticationManager authenticationManager() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(new PasswordEncoderConfig().passwordEncoder());
        return new ProviderManager(provider);
    }

}