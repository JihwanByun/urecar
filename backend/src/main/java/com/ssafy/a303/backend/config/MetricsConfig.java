package com.ssafy.a303.backend.config;

import io.micrometer.core.aop.TimedAspect;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MetricsConfig {
    @Bean
    public TimedAspect timedAspect() {
        return new TimedAspect();
    }
}
