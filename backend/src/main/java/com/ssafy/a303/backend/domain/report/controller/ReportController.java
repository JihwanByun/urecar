package com.ssafy.a303.backend.domain.report.controller;

import com.ssafy.a303.backend.domain.report.dto.CreateReportRequestDto;
import com.ssafy.a303.backend.domain.report.service.ReportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/reports")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @PostMapping
    public ResponseEntity<Void> createReport(
            @RequestPart(value = "dto") CreateReportRequestDto createReportRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        reportService.createReport(createReportRequestDto, file);
        return ResponseEntity.ok().build();
    }

}
