package com.ssafy.a303.backend.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.a303.backend.domain.member.repository.MemberRepository;
import com.ssafy.a303.backend.domain.member.service.MemberServiceImpl;
import com.ssafy.a303.backend.security.filter.JsonUsernamePasswordAuthenticationFilter;
import com.ssafy.a303.backend.security.filter.JwtAuthenticationFilter;
import com.ssafy.a303.backend.security.filter.JwtExceptionFilter;
import com.ssafy.a303.backend.security.handler.JwtAccessDeniedHandler;
import com.ssafy.a303.backend.security.handler.LoginFailureHandler;
import com.ssafy.a303.backend.security.handler.LoginSuccessHandler;
import com.ssafy.a303.backend.security.jwt.JwtRepository;
import com.ssafy.a303.backend.security.jwt.JwtService;
import com.ssafy.a303.backend.security.jwt.JwtUtil;
import com.ssafy.a303.backend.security.user.AuthenticationProviderImpl;
import com.ssafy.a303.backend.security.user.UserDetailsServiceImpl;
import java.util.Arrays;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    public SecurityFilterChain configure(HttpSecurity http, JwtRepository jwtRepository, MemberRepository memberRepository)
            throws Exception {

        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .formLogin(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        http
                .authorizeHttpRequests(
                        authorize -> authorize
                                .requestMatchers("/swagger", "/swagger-ui.html", "/swagger-ui/*", "/api-docs", "/api-docs/*",
                                        "/v3/api-docs/*").permitAll()
                                .requestMatchers(HttpMethod.POST, "/login", "/signup").permitAll()
                                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                                .anyRequest().permitAll()
                );

        http
                .addFilterBefore(jsonUsernamePasswordAuthenticationFilter(jwtRepository, memberRepository), UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(jwtAuthenticationFilter(jwtRepository, memberRepository), UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(new JwtExceptionFilter(), JwtAuthenticationFilter.class);

        http
                .exceptionHandling((exceptionHandling) ->
                        exceptionHandling.accessDeniedHandler(new JwtAccessDeniedHandler())
                );

        http
                .logout((logout) -> logout.permitAll().logoutSuccessHandler(logoutSuccessHandler(jwtRepository)));

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
    public JsonUsernamePasswordAuthenticationFilter jsonUsernamePasswordAuthenticationFilter(JwtRepository jwtRepository, MemberRepository memberRepository) {
        JsonUsernamePasswordAuthenticationFilter jsonUsernamePasswordAuthenticationFilter
                = new JsonUsernamePasswordAuthenticationFilter(
                new ObjectMapper(), new AuthenticationProviderImpl(new UserDetailsServiceImpl(memberRepository), passwordEncoder()));
        jsonUsernamePasswordAuthenticationFilter.setAuthenticationSuccessHandler(new LoginSuccessHandler(new JwtService(jwtRepository), new MemberServiceImpl()));
        jsonUsernamePasswordAuthenticationFilter.setAuthenticationFailureHandler(new LoginFailureHandler());
        jsonUsernamePasswordAuthenticationFilter.setAuthenticationManager(authenticationManager(memberRepository));
        return jsonUsernamePasswordAuthenticationFilter;
    }

    @Bean
    public AuthenticationManager authenticationManager(MemberRepository memberRepository) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(new UserDetailsServiceImpl(memberRepository));
        provider.setPasswordEncoder(passwordEncoder());
        return new ProviderManager(provider);
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(JwtRepository jwtRepository, MemberRepository memberRepository) {
        return new JwtAuthenticationFilter(new MemberServiceImpl(), new JwtService(jwtRepository),
                new UserDetailsServiceImpl(memberRepository));
    }

    @Bean
    public LogoutSuccessHandler logoutSuccessHandler(JwtRepository jwtRepository) {
        JwtService jwtService = new JwtService(jwtRepository);
        return (request, response, authentication) -> {
            jwtService.saveLogoutAccessToken(request.getHeader("Authorization"));
            jwtService.deleteRefreshToken(JwtUtil.getLoginEmail(request.getHeader("Authorization")));
        };
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}