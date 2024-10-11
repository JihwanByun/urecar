package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportListResponseDto;
import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.NotificationRequestDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import com.ssafy.a303.backend.domain.member.entity.Member;
import com.ssafy.a303.backend.domain.report.entity.ProcessStatus;
import com.ssafy.a303.backend.domain.report.entity.Report;
import com.ssafy.a303.backend.domain.report.handler.ImageHandler;
import com.ssafy.a303.backend.domain.report.repository.ReportRepository;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

@Service
public class OfficialServiceImpl implements OfficialService {

    private final ReportRepository reportRepository;
    private final RestTemplate restTemplate;

    public OfficialServiceImpl(ReportRepository reportRepository, RestTemplate restTemplate) {
        this.reportRepository = reportRepository;
        this.restTemplate = restTemplate;
    }

    @Override
    public List<AnalysisSuccessReportListResponseDto> getAnalysisSuccessReports() {
        List<Report> reports = reportRepository.getReportsByProcessStatus(ProcessStatus.ANALYSIS_SUCCESS);
        List<AnalysisSuccessReportListResponseDto> responseDtos = new ArrayList<>();
        for (Report report : reports) {
            responseDtos.add(
                    AnalysisSuccessReportListResponseDto.builder()
                            .reportId(report.getId())
                            .memberName(report.getMember().getName())
                            .date(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                            .type(report.getType())
                            .build()
            );
        }

        return responseDtos;
    }

    @Override
    @Transactional
    public void decideReportOutcome(ReportDecisionRequestDTO requestDto) {
        Report report = reportRepository.getReportById(requestDto.getReportId());
        Member member = report.getMember();

        report.decideReportOutcome(
                requestDto.getMemberName(),
                requestDto.getDecision() ? ProcessStatus.ACCEPTED : ProcessStatus.UNACCEPTED);
        reportRepository.save(report);

        requestNotification(NotificationRequestDto.builder()
                .reportId(report.getId())
                .result(requestDto.getDecision())
                .memberId(member.getId())
                .token(member.getNotificationToken())
                .build());
    }

    private void requestNotification(NotificationRequestDto notificationRequestDto) {
        String apiUrl = "http://notification:8082/notifications/result";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<NotificationRequestDto> requestEntity = new HttpEntity<>(notificationRequestDto, headers);
        restTemplate.exchange(
                apiUrl,
                HttpMethod.POST,
                requestEntity,
                String.class
        );
    }

    @Override
    public AnalysisSuccessReportResponseDto getAnalysisSuccessReport(Long id) {
        Report report = reportRepository.getReportById(id);
        return AnalysisSuccessReportResponseDto.builder()
                .reportId(report.getId())
                .memberName(report.getMember().getName())
                .datetime(report.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")))
                .latitude(report.getLatitude())
                .longitude(report.getLongitude())
                .content(report.getContent())
                .type(report.getType())
                .firstImage(ImageHandler.urlToBytes(report.getFirstImage()))
                .build();
    }

}
