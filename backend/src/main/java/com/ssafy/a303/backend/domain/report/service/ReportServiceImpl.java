package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.member.entity.Member;
import com.ssafy.a303.backend.domain.report.dto.GalleryResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ImageInfoDto;
import com.ssafy.a303.backend.domain.report.dto.ReportResponseDto;
import com.ssafy.a303.backend.domain.report.dto.ReportUpdateRequestDto;
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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ReportServiceImpl implements ReportService {

    private final MemberRepository memberRepository;
    private final ReportRepository reportRepository;
    private final ImageHandler imageHandler;
    private final OutboxReportRepository outboxReportRepository;
    private final IllegalParkingZoneRepository illegalParkingZoneRepository;

    public ReportServiceImpl(MemberRepository memberRepository, ReportRepository reportRepository,
            OutboxReportRepository outboxReportRepository, IllegalParkingZoneRepository illegalParkingZoneRepository) {
        this.memberRepository = memberRepository;
        this.reportRepository = reportRepository;
        this.outboxReportRepository = outboxReportRepository;
        this.imageHandler = new ImageHandler();
        this.illegalParkingZoneRepository = illegalParkingZoneRepository;

    }

    @Override
    public ReportResponseDto getReport(Long reportId) {
        Report report = reportRepository.getReportById(reportId);
        return ReportResponseDto.builder()
                .reportId(report.getId())
                .content(report.getContent())
                .date(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                .type(report.getType()).
                firstImage(report.getFirstImage())
                .processStatus(report.getProcessStatus())
                .build();
    }

    @Override
    @Transactional
    public void createReport(ReportCreateRequestDto requestDto, MultipartFile file) {
        ImageInfoDto imageInfoDto = imageHandler.save(requestDto.getMemberId(), file);
        Report report = saveReport(requestDto, imageInfoDto);


        saveOutboxReport(report);


    }

    private Report saveReport(ReportCreateRequestDto requestDto, ImageInfoDto imageInfoDto) {
        Report report = Report.builder()
                .member(memberRepository.findById(requestDto.getMemberId()).orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID)))
                .firstImage(imageInfoDto.getFullPathName())
                .createdAt(imageInfoDto.getCreateDateTime())
                .longitude(requestDto.getLongitude())
                .latitude(requestDto.getLatitude())
                .processStatus(ProcessStatus.ONGOING)
                .build();

        return reportRepository.save(report);
    }

    private void saveOutboxReport(Report report) {
        Member member = memberRepository.findById(report.getMember().getId()).orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID));
        OutboxReport outboxReport = OutboxReport.builder()
                .report(report)
                .member(member)
                .firstImage(report.getFirstImage())
                .secondImage(report.getSecondImage() == null ? null : report.getSecondImage())
                .outboxStatus(OutboxStatus.FIRST_WAIT)
                .token(member.getNotificationToken())
                .build();

        outboxReportRepository.save(outboxReport);
    }

    @Override
    @Transactional
    public void updateReport(ReportUpdateRequestDto requestDto, MultipartFile file) {
        ImageInfoDto imageInfoDto = imageHandler.save(requestDto.getMemberId(), file);
        Report report = saveSecondImageInReport(requestDto, imageInfoDto);
        saveOutboxReport(report);
    }

    private Report saveSecondImageInReport(ReportUpdateRequestDto requestDto, ImageInfoDto imageInfoDto) {
        Report report = reportRepository.getReportById(requestDto.getReportId());
        report.updateSecondImage(imageInfoDto.getFullPathName());
        return report;
    }

    @Override
    public GalleryResponseDto getGallery(long memberId) {
        List<Report> reports = reportRepository.findAllByMemberId(memberId);
        List<String> imageUrls = new ArrayList<>();
        for(Report report : reports) {
            imageUrls.add(report.getFirstImage());
        }
        return GalleryResponseDto.builder().imageUrls(imageUrls).build();
    }

    @Override
    public void isIllegalParkingZone(double longitude, double latitude) {
        // 위치정보 가져오기
    List<IllegalParkingZone> isNearTheIllegalParkingLocation = illegalParkingZoneRepository.findWithin20Meters(longitude, latitude);

        if(isNearTheIllegalParkingLocation == null || isNearTheIllegalParkingLocation.isEmpty()) {
        throw new CustomException(ErrorCode.REPORT_SAVE_FAILED);
        }

    }

}
