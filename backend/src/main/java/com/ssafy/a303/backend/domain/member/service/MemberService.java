package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.MemberDeleteRequestDto;
import com.ssafy.a303.backend.domain.member.dto.MemberUpdateRequestDto;
import com.ssafy.a303.backend.domain.member.dto.NotificationTokenDto;
import com.ssafy.a303.backend.domain.member.dto.SignupRequestDto;
import com.ssafy.a303.backend.domain.member.entity.Member;

public interface MemberService {

    void saveMember(SignupRequestDto signupRequestDto);

    Member getMemberByEmail(String email);

    boolean isExistEmail(String email);

    void deleteMember(MemberDeleteRequestDto memberDeleteRequestDto);

    void setNotificationToken(NotificationTokenDto notificationTokenDto);

    void updateMember(MemberUpdateRequestDto memberUpdateRequestDto);
}
