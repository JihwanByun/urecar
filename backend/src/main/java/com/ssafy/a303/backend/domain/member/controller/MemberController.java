package com.ssafy.a303.backend.domain.member.controller;

import com.ssafy.a303.backend.domain.member.dto.EmailCheckRequestDto;
import com.ssafy.a303.backend.domain.member.dto.MemberDeleteRequestDto;
import com.ssafy.a303.backend.domain.member.dto.MemberUpdateRequestDto;
import com.ssafy.a303.backend.domain.member.dto.NotificationTokenDto;
import com.ssafy.a303.backend.domain.member.dto.SignupRequestDto;
import com.ssafy.a303.backend.domain.member.service.MemberService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/members")
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @PostMapping("/signup")
    public ResponseEntity<Void> signup(@RequestBody SignupRequestDto signupRequestDto) {
        memberService.saveMember(signupRequestDto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/emailCheck")
    public ResponseEntity<Boolean> emailCheck(@RequestBody EmailCheckRequestDto emailCheckRequestDto) {
        return ResponseEntity.ok().body(memberService.isExistEmail(emailCheckRequestDto.getEmail()));
    }

    @PostMapping("/token")
    public ResponseEntity<Void> setNotificationToken(@RequestBody NotificationTokenDto notificationTokenDto) {
        memberService.setNotificationToken(notificationTokenDto);
        return ResponseEntity.ok().build();
    }

    @PutMapping
    public ResponseEntity<Void> update(@RequestBody MemberUpdateRequestDto memberUpdateRequestDto) {
        memberService.updateMember(memberUpdateRequestDto);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> delete(@RequestBody MemberDeleteRequestDto memberDeleteRequestDto) {
        memberService.deleteMember(memberDeleteRequestDto);
        return ResponseEntity.ok().build();
    }

}
