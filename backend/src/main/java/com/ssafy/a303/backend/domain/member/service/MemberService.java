package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.SignupRequestDto;
import com.ssafy.a303.backend.domain.member.entity.Member;

public interface MemberService {

    void saveMember(SignupRequestDto signupRequestDto);

    Member getMemberByEmail(String email);

    boolean isExistEmail(String email);

}
