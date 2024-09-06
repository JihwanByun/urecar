package com.ssafy.a303.backend.report.entity;

import com.ssafy.a303.backend.member.entity.Member;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
import org.hibernate.annotations.CreationTimestamp;

@Getter
@Entity
@ToString(exclude = {"member"})
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Report {

    @Id
    @GeneratedValue
    @Column(name = "REPORT_ID")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

    @Column(length = 1_000)
    private String content;

    @Column(nullable = false)
    private String firstImage;
    private String secondImage;
    private String video;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private double latitude;
    @Column(nullable = false)
    private double longitude;

    @Builder
    public Report(Member member, String content, String firstImage, String video, LocalDateTime createdAt, double latitude, double longitude) {
        this.member = member;
        this.content = content;
        this.firstImage = firstImage;
        this.video = video;
        this.createdAt = createdAt;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public void updateSecondImage(String secondImage) {
        this.secondImage = secondImage;
    }

}
