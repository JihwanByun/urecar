package com.ssafy.a303.backend.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {

    /* 200 */
    SUCCESS(200, "OK", "요청에 성공하였습니다."),

    /* 400 */
    NOT_FOUND_MEMBER_ID(404, "NOT_FOUND_MEMBER_ID", "회원 정보를 찾을 수 없습니다.");

    private final int status;
    private final String code;
    private final String message;

    ErrorCode(final int status, final String code, final String message) {
        this.status = status;
        this.code = code;
        this.message = message;
    }

}
