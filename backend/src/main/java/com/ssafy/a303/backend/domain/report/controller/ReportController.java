package com.ssafy.a303.backend.domain.report.controller;

import com.ssafy.a303.backend.domain.report.dto.ReportCreateRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportUpdateRequestDto;
import com.ssafy.a303.backend.domain.report.service.ReportService;
import com.ssafy.a303.backend.exception.ErrorCode;
import org.springframework.http.HttpStatus;
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

    @PostMapping
    public ResponseEntity<?> createReport(
            @RequestPart(value = "dto") ReportCreateRequestDto reportCreateRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        reportService.createReport(reportCreateRequestDto, file);

        try {
            reportService.isIllegalParkingZone(reportCreateRequestDto.getLongitude(), reportCreateRequestDto.getLatitude());
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ErrorCode.IMAGE_SAVE_FAILED);
        }

        return ResponseEntity.ok().build();
    }

    @PostMapping("/secondImage")
    public ResponseEntity<Void> updateReport(
            @RequestPart(value = "dto") ReportUpdateRequestDto reportUpdateRequestDto,
            @RequestPart(value = "file") MultipartFile file
    ) {
        reportService.updateReport(reportUpdateRequestDto, file);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{reportId}")
    public ResponseEntity<ReportResponseDto> getReport(@PathVariable Long reportId) {
        return ResponseEntity.ok().body(reportService.getReport(reportId));
    }

    @PostMapping("/gallery")
    public ResponseEntity<GalleryResponseDto> getGallery(@RequestBody GalleryRequestDto galleryRequestDto) {
        return ResponseEntity.ok().body(reportService.getGallery(galleryRequestDto.getMemberId()));
    }

}
