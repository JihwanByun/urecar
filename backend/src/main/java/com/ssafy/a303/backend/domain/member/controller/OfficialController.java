package com.ssafy.a303.backend.domain.member.controller;

import com.ssafy.a303.backend.domain.member.dto.OngoingReportResponseDto;
import com.ssafy.a303.backend.domain.member.dto.ReportDecisionRequestDTO;
import com.ssafy.a303.backend.domain.member.service.OfficialService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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
    public ResponseEntity<List<OngoingReportResponseDto>> getOngoingReports() {
        return ResponseEntity.ok().body(officialService.getOngoingReports());
    }

    @PostMapping
    public ResponseEntity<Void> selectReportAccept(@RequestBody ReportDecisionRequestDTO reportDecisionRequestDTO) {
        officialService.decideReportOutcome(reportDecisionRequestDTO);
        return ResponseEntity.ok().build();
    }

}
