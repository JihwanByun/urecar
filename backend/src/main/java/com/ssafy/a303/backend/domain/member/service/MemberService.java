package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.entity.Member;

public interface MemberService {

    Member getMemberByEmail(String email);

}
