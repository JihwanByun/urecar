package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.dto.ReportCreateRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportUpdateRequestDto;
import org.springframework.web.multipart.MultipartFile;

public interface ReportService {

    ReportResponseDto getReport(Long reportId);

    void createReport(ReportCreateRequestDto requestDto, MultipartFile file);

    void updateReport(ReportUpdateRequestDto reportUpdateRequestDto, MultipartFile file);

    GalleryResponseDto getGallery(long memberId);

    boolean findLocation(double longitude, double latitude);
}
