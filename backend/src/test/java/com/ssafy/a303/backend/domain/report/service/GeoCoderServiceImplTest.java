package com.ssafy.a303.backend.domain.report.service;

import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.web.client.RestTemplate;

import static org.junit.jupiter.api.Assertions.*;


@SpringBootTest
class GeoCoderServiceImplTest {

    @Mock
    private RestTemplate restTemplate;


    @Test
    public void testGetSeoulBorough() throws Exception {

        //given
        String url = "https://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&format=json&type=both&zipcode=true&simple=false&key=5AD60FBD-952F-3953-9FCC-6E9694A17B63&point=126.978, 37.566";

        //when
        String response = restTemplate.getForObject(url, String.class);

        //then
        assertNotNull(response);

        System.out.println("Response: "+ response);

    }
}