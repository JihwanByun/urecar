package com.ssafy.a303.backend.domain.report.service;

import com.ssafy.a303.backend.domain.report.entity.Report;
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

    @Transactional
    public void uploadFirstImage(MultipartFile file) {


        //GPU 서버에 해당 이미지 분류 요청, 번호판 분석

        //받아온 위치정보 기반 DB내 불법 주정차 위치랑 근처인지 확인하기


    }

    @Transactional
    public void uploadSecondImage(MultipartFile file) {
        //이전 사진정보에 들어있는 위치랑 유사도 확인하기
        
    }



}
