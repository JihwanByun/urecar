package com.ssafy.a303.backend.domain.report.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

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
    public String getSeoulBorough(double longitude, double latitude) {

        String requestUrl = UriComponentsBuilder.fromHttpUrl(url)
                .queryParam("key",geocoderKey)
                .queryParam("point", longitude + ", " + latitude)
                .toUriString();

        String response = restTemplate.getForObject(requestUrl, String.class);

        return response;
    }

}
