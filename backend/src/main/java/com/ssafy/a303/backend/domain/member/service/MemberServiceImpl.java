package com.ssafy.a303.backend.domain.member.service;

import com.ssafy.a303.backend.domain.member.dto.MemberDeleteRequestDto;
import com.ssafy.a303.backend.domain.member.dto.MemberUpdateRequestDto;
import com.ssafy.a303.backend.domain.member.dto.NotificationTokenDto;
import com.ssafy.a303.backend.domain.member.dto.SignupRequestDto;
import com.ssafy.a303.backend.domain.member.entity.Address;
import com.ssafy.a303.backend.domain.member.entity.Member;
import com.ssafy.a303.backend.domain.member.entity.Role;
import com.ssafy.a303.backend.domain.member.repository.MemberRepository;
import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public MemberServiceImpl(MemberRepository memberRepository, PasswordEncoder passwordEncoder) {
        this.memberRepository = memberRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void saveMember(SignupRequestDto signupRequestDto) {
        memberRepository.save(
                Member.builder()
                        .email(signupRequestDto.getEmail())
                        .password(passwordEncoder.encode(signupRequestDto.getPassword()))
                        .name(signupRequestDto.getName())
                        .tel(signupRequestDto.getTel())
                        .address(
                                Address.builder()
                                        .address(signupRequestDto.getAddress().getAddress())
                                        .addressDetail(signupRequestDto.getAddress().getAddressDetail())
                                        .zipCode(signupRequestDto.getAddress().getZipCode())
                                        .build()
                        )
                        .role(Role.USER)
                .build()
        );
    }

    @Override
    public Member getMemberByEmail(String email) {
        return memberRepository.findByEmail(email);
    }

    @Override
    public boolean isExistEmail(String email) {
        return memberRepository.existsByEmail(email);
    }

    @Override
    public void deleteMember(MemberDeleteRequestDto memberDeleteRequestDto) {
        Member member = memberRepository.findById(memberDeleteRequestDto.getMemberId()).orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID));
        member.removeMember();
        memberRepository.save(member);
    }

    @Override
    public void setNotificationToken(NotificationTokenDto notificationTokenDto) {
        Member member = memberRepository.findById(notificationTokenDto.getMemberId()).orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_MEMBER_ID));
        member.setNotificationToken(notificationTokenDto.getToken());
        memberRepository.save(member);
    }

    @Override
    public void updateMember(MemberUpdateRequestDto memberUpdateRequestDto) {
        Member member = memberRepository.findByEmail(memberUpdateRequestDto.getEmail());
        member.setPassword(passwordEncoder.encode(memberUpdateRequestDto.getPassword()));
        member.setTel(memberUpdateRequestDto.getTel());
        memberRepository.save(member);
    }

}
