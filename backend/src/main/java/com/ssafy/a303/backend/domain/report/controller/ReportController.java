package com.ssafy.a303.backend.domain.report.controller;

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
import java.time.LocalDate;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    @Timed(value = "first.image.upload.time", description = "Time taken to execute create report method")
    public ResponseEntity<ReportCreateResponseDto> createReport(
            @RequestPart(value = "dto") ReportCreateRequestDto reportCreateRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        reportService.isIllegalParkingZone(reportCreateRequestDto.getLongitude(), reportCreateRequestDto.getLatitude());
        ReportCreateResponseDto responseDto = reportService.createReport(reportCreateRequestDto, file);
        reportService.sendOneMinuteNotification(responseDto.getReportId());
        return ResponseEntity.ok().body(responseDto);
    }

    @PostMapping("/secondImage")
    @Timed(value = "second.image.upload.time", description = "Time taken to execute add second image method")
    public ResponseEntity<SecondReportResponseDto> uploadSecondReportImage(
            @RequestPart(value = "dto") uploadSecondReportImageRequestDto uploadSecondReportImageRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        return ResponseEntity.ok().body(reportService.uploadSecondReportImage(uploadSecondReportImageRequestDto, file));
    }

    @GetMapping
    public ResponseEntity<List<SearchedReportResponseDto>> searchReport(
            @RequestParam Long memberId,
            @RequestParam(required = false) ProcessStatus processStatus,
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate
            ) {
        return ResponseEntity.ok().body(reportService.searchReports(
                SearchedReportsRequestDto.builder()
                        .memberId(memberId)
                        .processStatus(processStatus)
                        .startDate(startDate)
                        .endDate(endDate)
                        .build()
        ));
    }

    @GetMapping("/detail/{reportId}")
    @Timed(value = "get.report")
    public ResponseEntity<ReportResponseDto> getReport(@PathVariable Long reportId) {
        return ResponseEntity.ok().body(reportService.getReport(reportId));
    }

    @PostMapping("/gallery")
    @Timed(value = "get.gallery")
    public ResponseEntity<GalleryResponseDto> getGallery(@RequestBody GalleryRequestDto galleryRequestDto) {
        return ResponseEntity.ok().body(reportService.getGallery(galleryRequestDto.getMemberId()));
    }

}
