package com.ssafy.a303.backend.domain.report.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.lang.reflect.Executable;

@Service
@Slf4j
@RequiredArgsConstructor
public class GeoCoderServiceImpl implements GeoCoderService {


    private final RestTemplate restTemplate;

    @Value("${geocoder.credentials.secret-access-key}")
    private String geocoderKey;

    @Value("${geocoder.url}")
    private String url;

    @Override
    public String getSeoulBorough(double longitude, double latitude) throws Exception {

        String requestUrl = UriComponentsBuilder.fromHttpUrl(url)
                .queryParam("key",geocoderKey)
                .queryParam("point", longitude + ", " + latitude)
                .toUriString();

        String response = restTemplate.getForObject(requestUrl, String.class);

        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode rootNode = objectMapper.readTree(response);

        String borough = rootNode.path("response")
                    .path("result")
                    .get(0)
                    .path("structure")
                    .path("level2")
                    .asText();

        System.out.println("자치구: " + borough);
        
        return borough;
    }

}
