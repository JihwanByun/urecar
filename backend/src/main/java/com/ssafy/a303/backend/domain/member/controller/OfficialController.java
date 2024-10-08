package com.ssafy.a303.backend.domain.member.controller;

import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportListResponseDto;
import com.ssafy.a303.backend.domain.member.dto.AnalysisSuccessReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import com.ssafy.a303.backend.domain.member.service.OfficialService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/officials")
public class OfficialController {

    private final OfficialService officialService;

    public OfficialController(OfficialService officialService) {
        this.officialService = officialService;
    }

    @GetMapping
    public ResponseEntity<List<AnalysisSuccessReportListResponseDto>> getAnalysisSuccessReports() {
        return ResponseEntity.ok().body(officialService.getAnalysisSuccessReports());
    }

    @PostMapping
    public ResponseEntity<Void> selectReportAccept(@RequestBody ReportDecisionRequestDTO reportDecisionRequestDTO) {
        officialService.decideReportOutcome(reportDecisionRequestDTO);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/reports/{id}")
    public ResponseEntity<AnalysisSuccessReportResponseDto> getAnalysisSuccessReportById(@PathVariable Long id) {
        return ResponseEntity.ok().body(officialService.getAnalysisSuccessReport(id));
    }

}
