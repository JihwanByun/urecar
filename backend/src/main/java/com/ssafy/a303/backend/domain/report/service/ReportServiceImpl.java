package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.entity.Report;
import com.ssafy.a303.backend.domain.report.handler.ImageHandler;
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

    public ReportServiceImpl(MemberRepository memberRepository, ReportRepository reportRepository) {
        this.memberRepository = memberRepository;
        this.reportRepository = reportRepository;
        this.imageHandler = new ImageHandler();
    }

    @Transactional
    public void createReport(CreateReportRequestDto requestDto, MultipartFile file) {
        String fileName = imageHandler.save(requestDto.getMemberId(), file);
        Report report = Report.builder()
                .member(memberRepository.findById(requestDto.getMemberId())
                        .orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID)))
                .content(requestDto.getContent())
                .firstImage(fileName)
                .longitude(requestDto.getLongitude())
                .latitude(requestDto.getLatitude())
                .build();

        reportRepository.save(report);
    }

}
