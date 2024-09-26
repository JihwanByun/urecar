package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.dto.ImageInfoDto;
import com.ssafy.a303.backend.domain.report.entity.OutboxReport;
import com.ssafy.a303.backend.domain.report.entity.OutboxStatus;
import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import com.ssafy.a303.backend.domain.report.entity.Report;
import com.ssafy.a303.backend.domain.report.handler.ImageHandler;
import com.ssafy.a303.backend.domain.report.repository.OutboxReportRepository;
import com.ssafy.a303.backend.domain.report.repository.ReportRepository;
import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import com.ssafy.a303.backend.domain.member.repository.MemberRepository;
import com.ssafy.a303.backend.domain.report.dto.CreateReportRequestDto;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ReportServiceImpl implements ReportService {

    private final MemberRepository memberRepository;
    private final ReportRepository reportRepository;
    private final ImageHandler imageHandler;
    private final OutboxReportRepository outboxReportRepository;

    public ReportServiceImpl(MemberRepository memberRepository, ReportRepository reportRepository,
            OutboxReportRepository outboxReportRepository) {
        this.memberRepository = memberRepository;
        this.reportRepository = reportRepository;
        this.outboxReportRepository = outboxReportRepository;
        this.imageHandler = new ImageHandler();
    }

    @Transactional
    public void createReport(CreateReportRequestDto requestDto, MultipartFile file) {
        ImageInfoDto imageInfoDto = imageHandler.save(requestDto.getMemberId(), file);
        Report report = saveReport(requestDto, imageInfoDto);
        saveOutboxReport(report);
    }

    private Report saveReport(CreateReportRequestDto requestDto, ImageInfoDto imageInfoDto) {
        Report report = Report.builder()
                .member(memberRepository.findById(requestDto.getMemberId()).orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID)))
                .content(requestDto.getContent())
                .firstImage(imageInfoDto.getFullPathName())
                .createdAt(imageInfoDto.getCreateDateTime())
                .longitude(requestDto.getLongitude())
                .latitude(requestDto.getLatitude())
                .processStatus(ProcessStatus.ONGOING)
                .build();

        return reportRepository.save(report);
    }

    private void saveOutboxReport(Report report) {
        OutboxReport outboxReport = OutboxReport.builder()
                .report(report)
                .member(memberRepository.findById(report.getMember().getId()).orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID)))
                .firstImage(report.getFirstImage())
                .outboxStatus(OutboxStatus.FIRST_WAIT)
                .build();

        outboxReportRepository.save(outboxReport);
    }

}
