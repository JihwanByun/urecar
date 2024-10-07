package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.dto.ReportCreateRequestDto;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportCreateResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.uploadSecondReportImageRequestDto;
import org.springframework.web.multipart.MultipartFile;

public interface ReportService {

    ReportResponseDto getReport(Long reportId);

    ReportCreateResponseDto createReport(ReportCreateRequestDto requestDto, MultipartFile file);

    void uploadSecondReportImage(uploadSecondReportImageRequestDto uploadSecondReportImageRequestDto, MultipartFile file);

    GalleryResponseDto getGallery(long memberId);

    void isIllegalParkingZone(double longitude, double latitude) ;
}
