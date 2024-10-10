package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.member.dto.NotificationRequestDto;
import com.ssafy.a303.backend.domain.member.entity.Member;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ImageInfoDto;
import com.ssafy.a303.backend.domain.report.dto.ReportCreateResponseDto;
import com.ssafy.a303.backend.domain.report.dto.SearchedReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.SearchedReportsRequestDto;
import com.ssafy.a303.backend.domain.report.dto.SecondReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.uploadSecondReportImageRequestDto;
import com.ssafy.a303.backend.domain.report.entity.*;
import com.ssafy.a303.backend.domain.report.handler.ImageHandler;
import com.ssafy.a303.backend.domain.report.repository.IllegalParkingZoneRepository;
import com.ssafy.a303.backend.domain.report.repository.OutboxReportRepository;
import com.ssafy.a303.backend.domain.report.repository.ReportRepository;
import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import com.ssafy.a303.backend.domain.member.repository.MemberRepository;
import com.ssafy.a303.backend.domain.report.dto.ReportCreateRequestDto;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

@Service
@Slf4j
public class ReportServiceImpl implements ReportService {

    private final RestTemplate restTemplate;
    private final MemberRepository memberRepository;
    private final ReportRepository reportRepository;
    private final OutboxReportRepository outboxReportRepository;
    private final IllegalParkingZoneRepository illegalParkingZoneRepository;
    //    private final GeoCoderServiceImpl geoCoderService;

    public ReportServiceImpl(MemberRepository memberRepository, ReportRepository reportRepository,
            OutboxReportRepository outboxReportRepository, IllegalParkingZoneRepository illegalParkingZoneRepository,
            GeoCoderServiceImpl geoCoderService, RestTemplate restTemplate) {
        this.memberRepository = memberRepository;
        this.reportRepository = reportRepository;
        this.outboxReportRepository = outboxReportRepository;
        this.illegalParkingZoneRepository = illegalParkingZoneRepository;
//        this.geoCoderService =geoCoderService;
        this.restTemplate = restTemplate;
    }

    @Override
    public ReportResponseDto getReport(Long reportId) {
        Report report = reportRepository.getReportById(reportId);
        return ReportResponseDto.builder()
                .reportId(report.getId())
                .content(report.getContent())
                .datetime(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                .type(report.getType())
                .firstImage(ImageHandler.urlToBytes(report.getFirstImage()))
                .processStatus(report.getProcessStatus())
                .build();
    }

    @Override
    @Transactional
    public ReportCreateResponseDto createReport(ReportCreateRequestDto requestDto, MultipartFile file) {
        ImageInfoDto imageInfoDto = ImageHandler.save(requestDto.getMemberId(), file);
        Report report = saveReport(requestDto, imageInfoDto);
        saveOutboxReport(report);

        return ReportCreateResponseDto.builder()
                .reportId(report.getId())
                .type(report.getType())
                .datetime(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                .firstImage(ImageHandler.urlToBytes(report.getFirstImage()))
                .processStatus(report.getProcessStatus())
                .build();
    }

    private Report saveReport(ReportCreateRequestDto requestDto, ImageInfoDto imageInfoDto) {
        Report report = Report.builder()
                .member(memberRepository.findById(requestDto.getMemberId())
                        .orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID)))
                .firstImage(imageInfoDto.getFullPathName())
                .createdAt(imageInfoDto.getCreateDateTime())
                .longitude(requestDto.getLongitude())
                .latitude(requestDto.getLatitude())
                .type(requestDto.getType())
                .processStatus(ProcessStatus.ONGOING)
                .build();

        return reportRepository.save(report);
    }

    private void saveOutboxReport(Report report) {
        Member member = memberRepository.findById(report.getMember().getId())
                .orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID));

        OutboxReport outboxReport = OutboxReport.builder()
                .report(report)
                .member(member)
                .firstImage(report.getFirstImage())
                .secondImage(report.getSecondImage() == null ? null : report.getSecondImage())
                .outboxStatus(report.getSecondImage() == null ? OutboxStatus.FIRST_WAIT : OutboxStatus.SECOND_WAIT)
                .token(member.getNotificationToken())
                .build();

        outboxReportRepository.save(outboxReport);
    }

    @Override
    @Transactional
    public SecondReportResponseDto uploadSecondReportImage(uploadSecondReportImageRequestDto requestDto, MultipartFile file) {
        ImageInfoDto imageInfoDto = ImageHandler.save(requestDto.getMemberId(), file);
        Report report = saveSecondImageInReport(requestDto, imageInfoDto);
        saveOutboxReport(report);

        return SecondReportResponseDto.builder()
                .reportId(report.getId())
                .officialName(report.getOfficialName() == null ? "처리중" : report.getOfficialName())
                .firstImage(ImageHandler.urlToBytes(report.getFirstImage()))
                .datetime(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                .processStatus(report.getProcessStatus())
                .content(report.getContent())
                .type(report.getType())
                .build();
    }

    private Report saveSecondImageInReport(uploadSecondReportImageRequestDto requestDto, ImageInfoDto imageInfoDto) {
        Report report = reportRepository.getReportById(requestDto.getReportId());

        if (Math.abs(report.getLongitude() - requestDto.getLongitude()) >= 0.001 ||
                Math.abs(report.getLatitude() - requestDto.getLatitude()) >= 0.001) {
            throw new CustomException(ErrorCode.SECOND_IMAGE_ANALYSIS_FAILED);
        }

        report.updateSecondImage(imageInfoDto.getFullPathName(), requestDto.getContent());
        return report;
    }

    @Override
    public GalleryResponseDto getGallery(long memberId) {
        List<Report> reports = reportRepository.findAllByMemberId(memberId);
        List<byte[]> imageUrls = new ArrayList<>();
        for (Report report : reports) {
            imageUrls.add(ImageHandler.urlToBytes(report.getFirstImage()));
        }
        return GalleryResponseDto.builder().imageUrls(imageUrls).build();
    }

    @Override
    public List<SearchedReportResponseDto> searchReports(SearchedReportsRequestDto searchedReportsRequestDto) {
        LocalDateTime startDateTime = searchedReportsRequestDto.getStartDate().atStartOfDay();
        LocalDateTime endDateTime = searchedReportsRequestDto.getEndDate().atTime(LocalTime.MAX);
        List<Report> reports = reportRepository.findReportsByMemberIdAndProcessStatusAndCreatedAtBetween(
                searchedReportsRequestDto.getMemberId(),
                searchedReportsRequestDto.getProcessStatus(),
                startDateTime,
                endDateTime
        );

        List<SearchedReportResponseDto> dtos = new ArrayList<>();
        for(Report report : reports) {
            dtos.add(
                    SearchedReportResponseDto.builder()
                            .reportId(report.getId())
                            .type(report.getType())
                            .datetime(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                            .processStatus(report.getProcessStatus())
                            .build()
            );
        }
        return dtos;
    }

    @Override
    public void isIllegalParkingZone(double longitude, double latitude) {
        double latMargin = 0.00018; // 약 20미터
        double longMargin = 0.00018 / Math.cos(Math.toRadians(latitude)); // 위도에 따른 경도 차이

        double latitudeMin = latitude - latMargin;
        double latitudeMax = latitude + latMargin;
        double longitudeMin = longitude - longMargin;
        double longitudeMax = longitude + longMargin;

        //long startTime1 = System.currentTimeMillis();
        List<DistinctIllegalParkingZone> isNearTheIllegalParkingLocation = illegalParkingZoneRepository.findWithin20MetersWithDistinctIndex(longitudeMin, longitudeMax, latitudeMin, latitudeMax);
        if(isNearTheIllegalParkingLocation == null || isNearTheIllegalParkingLocation.isEmpty()) {
            throw new CustomException(ErrorCode.REPORT_POINT_CHECK_FAILED);
        }
       //long endTime1 = System.currentTimeMillis();
        //System.out.println("전처리 후 Execution Time: " + (endTime1 - startTime1) + " ms");

//        long startTime = System.currentTimeMillis();
//        List<IllegalParkingZone> isNearTheIllegalParkingLocation1 = illegalParkingZoneRepository.findWithin20Meters(longitudeMin, longitudeMax, latitudeMin, latitudeMax);
//        if(isNearTheIllegalParkingLocation1 == null || isNearTheIllegalParkingLocation1.isEmpty()) {
//            throw new CustomException(ErrorCode.REPORT_POINT_CHECK_FAILED);
//        }
//        long endTime = System.currentTimeMillis();
//        System.out.println("전처리 전 Execution Time: " + (endTime - startTime) + " ms");


//        String response = geoCoderService.getSeoulBorough(longitude,latitude);
//        System.out.println(response);
    }

    @Override
    public void sendOneMinuteNotification(long reportId) {
        Report report = reportRepository.getReportById(reportId);
        String apiUrl = "http://notification:8082/notifications/one-minute";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<NotificationRequestDto> requestEntity = new HttpEntity<>(
                NotificationRequestDto.builder()
                        .result(true)
                        .memberId(report.getMember().getId())
                        .reportId(report.getId())
                        .token(report.getMember().getNotificationToken())
                        .build(), headers);
        restTemplate.exchange(
                apiUrl,
                HttpMethod.POST,
                requestEntity,
                String.class
        );
    }

}
