package com.ssafy.a303.backend.domain.member.entity;

import lombok.Getter;

@Getter
public enum Role {

    USER("ROLE_USER");

    private final String role;

    Role(String role) {
        this.role = role;
    }

    public static String getRoleTitle(Role role) {
        return role.role;
    }

}
