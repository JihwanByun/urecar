package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.dto.CreateReportRequestDto;
import org.springframework.web.multipart.MultipartFile;

public interface ReportService {

    void createReport(CreateReportRequestDto requestDto, MultipartFile file);

}
