package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.entity.Report;
import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import com.ssafy.a303.backend.domain.member.repository.MemberRepository;
import com.ssafy.a303.backend.domain.report.dto.CreateReportRequestDto;
import com.ssafy.a303.backend.domain.report.repository.ReportRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class ReportServiceImpl implements ReportService {

    final MemberRepository memberRepository;
    final ReportRepository reportRepository;

    public ReportServiceImpl(MemberRepository memberRepository, ReportRepository reportRepository) {
        this.memberRepository = memberRepository;
        this.reportRepository = reportRepository;
    }

    @Transactional
    public void createReport(CreateReportRequestDto requestDto) {
        Report report = Report.builder()
                .member(memberRepository.findById(requestDto.getMemberId())
                        .orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID)))
                .content(requestDto.getContent())
                .firstImage(requestDto.getFirstImage())
                .longitude(requestDto.getLongitude())
                .latitude(requestDto.getLatitude())
                .build();

        reportRepository.save(report);
    }

}
