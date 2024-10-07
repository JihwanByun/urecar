package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.OngoingReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import com.ssafy.a303.backend.domain.report.entity.Report;
import com.ssafy.a303.backend.domain.report.handler.ImageHandler;
import com.ssafy.a303.backend.domain.report.repository.ReportRepository;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class OfficialServiceImpl implements OfficialService {

    private final ReportRepository reportRepository;

    public OfficialServiceImpl(ReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    @Override
    public List<OngoingReportResponseDto> getOngoingReports() {
        List<Report> reports = reportRepository.getReportsByProcessStatus(ProcessStatus.ANALYSIS_SUCCESS);
        List<OngoingReportResponseDto> responseDtos = new ArrayList<>();
        for (Report report : reports) {
            responseDtos.add(
                    OngoingReportResponseDto.builder()
                            .reportId(report.getId())
                            .memberName(report.getMember().getName())
                            .latitude(report.getLatitude())
                            .longitude(report.getLongitude())
                            .content(report.getContent())
                            .firstImage(ImageHandler.urlToBytes(report.getFirstImage()))
                            .build()
            );
        }

        return responseDtos;
    }

    @Override
    public void decideReportOutcome(ReportDecisionRequestDTO requestDto) {
        Report report = reportRepository.getReportById(requestDto.getReportId());
        report.decideReportOutcome(requestDto.getDecision() ? ProcessStatus.ACCEPTED : ProcessStatus.UNACCEPTED);
        reportRepository.save(report);
    }

}
