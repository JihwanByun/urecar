package com.ssafy.a303.backend.security.jwt;

import java.time.Duration;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
public class JwtRepository {

    private final RedisTemplate<String, Object> redisTemplate;

    public JwtRepository(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public void save(String key, String value, long expirationMinutes){
        ValueOperations<String, Object> values = redisTemplate.opsForValue();
        values.set(key, value, Duration.ofSeconds(expirationMinutes));
    }

    public Object findByKey(Object key) {
        ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        return valueOperations.get(key);
    }

    public boolean hasKey(String key) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }

    public void delete(String key) {
        redisTemplate.delete(key);
    }

}

