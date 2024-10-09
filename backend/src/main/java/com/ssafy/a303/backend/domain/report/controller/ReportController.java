package com.ssafy.a303.backend.domain.report.controller;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.a303.backend.domain.report.dto.ReportCreateRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportCreateResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.SearchedReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.SearchedReportsRequestDto;
import com.ssafy.a303.backend.domain.report.dto.SecondReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.uploadSecondReportImageRequestDto;
import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import com.ssafy.a303.backend.domain.report.service.ReportService;

import io.micrometer.core.annotation.Timed;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

    @Timed(value = "first_image_upload.method.time", description = "Time taken to execute create report method")
    @PostMapping
    public ResponseEntity<ReportCreateResponseDto> createReport(
            @RequestPart(value = "dto") ReportCreateRequestDto reportCreateRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        ReportCreateResponseDto responseDto = reportService.createReport(reportCreateRequestDto, file);

        reportService.isIllegalParkingZone(reportCreateRequestDto.getLongitude(), reportCreateRequestDto.getLatitude());
        return ResponseEntity.ok().body(responseDto);
    }

    @Timed(value = "second_image_upload.method.time", description = "Time taken to execute add second image method")
    @PostMapping("/secondImage")
    public ResponseEntity<SecondReportResponseDto> uploadSecondReportImage(
            @RequestPart(value = "dto") uploadSecondReportImageRequestDto uploadSecondReportImageRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        return ResponseEntity.ok().body(reportService.uploadSecondReportImage(uploadSecondReportImageRequestDto, file));
    }

    @GetMapping("/detail/{reportId}")
    public ResponseEntity<ReportResponseDto> getReport(@PathVariable Long reportId) {
        return ResponseEntity.ok().body(reportService.getReport(reportId));
    }

    @PostMapping("/gallery")
    public ResponseEntity<GalleryResponseDto> getGallery(@RequestBody GalleryRequestDto galleryRequestDto) {
        return ResponseEntity.ok().body(reportService.getGallery(galleryRequestDto.getMemberId()));
    }

}
