package com.ssafy.a303.backend.report.service;

import com.ssafy.a303.backend.report.dto.CreateReportRequestDto;

public interface ReportService {

    void createReport(CreateReportRequestDto requestDto);

}
