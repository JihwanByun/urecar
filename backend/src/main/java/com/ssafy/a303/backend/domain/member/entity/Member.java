package com.ssafy.a303.backend.domain.member.entity;

import com.ssafy.a303.backend.domain.report.entity.Report;
import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Member {

    @Id
    @GeneratedValue
    @Column(name = "MEMBER_ID")
    private int id;

    @Column(nullable = false)
    private String email;
    @Column(nullable = false)
    private String password;
    @Column(nullable = false)
    private String name;
    @Column(nullable = false)
    private String tel;
    @Column(nullable = false)
    private Role role;

    @Embedded
    private Address address;

    @OneToMany(mappedBy = "member")
    List<Report> reports = new ArrayList<>();

    @ColumnDefault("false")
    private boolean isDeleted;

    @Builder
    public Member(String email, String password, String name, String tel, Address address, Role role) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.tel = tel;
        this.address = address;
        this.role = role;
    }

}