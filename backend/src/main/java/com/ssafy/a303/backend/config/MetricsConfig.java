package com.ssafy.a303.backend.config;

import io.micrometer.core.aop.TimedAspect;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.context.annotation.Bean;

@Configurable
public class MetricsConfig {
    @Bean
    public TimedAspect timedAspect() {
        return new TimedAspect();
    }
}
