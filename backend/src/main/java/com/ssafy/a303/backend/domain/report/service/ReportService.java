package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.dto.ReportCreateRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportCreateResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportUpdateRequestDto;
import org.springframework.web.multipart.MultipartFile;

public interface ReportService {

    ReportResponseDto getReport(Long reportId);

    ReportCreateResponseDto createReport(ReportCreateRequestDto requestDto, MultipartFile file);

    void updateReport(ReportUpdateRequestDto reportUpdateRequestDto, MultipartFile file);

    GalleryResponseDto getGallery(long memberId);

    void isIllegalParkingZone(double longitude, double latitude);
}
