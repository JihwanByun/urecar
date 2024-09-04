package com.ssafy.a303.backend.member;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class Member {

    @Id
    @GeneratedValue
    private int id;

    @Column
    private String name;

}
