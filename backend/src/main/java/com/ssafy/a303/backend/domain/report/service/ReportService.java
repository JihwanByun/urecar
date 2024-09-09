package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.dto.CreateReportRequestDto;

public interface ReportService {

    void createReport(CreateReportRequestDto requestDto);

}
