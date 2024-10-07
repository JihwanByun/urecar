package com.ssafy.a303.backend.domain.report.service;

public interface GeoCoderService {

    String getSeoulBorough(double longitude, double latitude) throws Exception;
}
