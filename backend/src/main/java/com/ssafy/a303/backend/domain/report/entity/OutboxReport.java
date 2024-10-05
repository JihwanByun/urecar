package com.ssafy.a303.backend.domain.report.entity;

import com.ssafy.a303.backend.domain.member.entity.Member;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class OutboxReport {

    @Id
    @GeneratedValue
    private long id;

    @Enumerated(EnumType.STRING)
    private OutboxStatus outboxStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "REPORT_ID")
    private Report report;

    @Column(nullable = false)
    private String firstImage;
    private String secondImage;

    private String token;

    @Builder
    public OutboxReport(Report report, Member member, String firstImage, String secondImage, OutboxStatus outboxStatus, String token) {
        this.report = report;
        this.member = member;
        this.firstImage = firstImage;
        this.secondImage = secondImage;
        this.outboxStatus = outboxStatus;
        this.token = token;
    }

}
