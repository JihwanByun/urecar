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
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Entity
@ToString(exclude = {"member"})
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Report {

    @Id
    @GeneratedValue
    @Column(name = "REPORT_ID")
    private long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

    @Column(length = 1_000)
    private String content;
    private String type;

    @Column(nullable = false)
    private String firstImage;
    private String secondImage;


    private LocalDateTime createdAt;

    @Column(nullable = false)
    private double latitude;
    @Column(nullable = false)
    private double longitude;

    @Enumerated(EnumType.STRING)
    private ProcessStatus processStatus;

    @Builder
    public Report(Member member, String content, String firstImage,
            LocalDateTime createdAt, double latitude, double longitude, ProcessStatus processStatus) {
        this.member = member;
        this.content = content;
        this.firstImage = firstImage;
        this.createdAt = createdAt;
        this.latitude = latitude;
        this.longitude = longitude;
        this.processStatus = processStatus;
    }

    public void updateSecondImage(String secondImage) {
        this.secondImage = secondImage;
    }

}
