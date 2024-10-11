package com.ssafy.a303.backend.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {

    /* 200 */
    SUCCESS(200, "OK", "요청에 성공하였습니다."),

    /* 400 */
    TOKEN_NOT_BEARER(400, "TOKEN_NOT_BEARER", "토큰이 Bearer로 시작하지 않습니다."),
    ACCESS_TOKEN_REQUIRED(400, "ACCESS_TOKEN_REQUIRED", "Access Token으로 접근할 수 없습니다. Refresh Token이 필요합니다."),
    REFRESH_TOKEN_NOT_ALLOWED(400, "REFRESH_TOKEN_NOT_ALLOWED", "Refresh Token으로 접근할 수 없습니다. Access Token이 필요합니다."),
    SECOND_IMAGE_ANALYSIS_FAILED(400, "SECOND_IMAGE_ANALYSIS_FAILED", "위치 검증에 실패했습니다."),

    INVALID_TOKEN(401, "INVALID_TOKEN", "토큰이 올바르지 않습니다."),
    EXPIRED_TOKEN(401, "EXPIRED_TOKEN", "토큰이 만료되었습니다."),
    TOKEN_MISSING(401, "TOKEN_MISSING", "요청에 토큰이 없습니다. 토큰을 제공해 주세요."),
    LOGGED_OUT_ACCESS_TOKEN(401, "LOGGED_OUT_ACCESS_TOKEN", "로그아웃된 Access Token입니다."),
    UNAUTHENTICATED_EXPIRED_REFRESH_TOKEN(401, "UNAUTHENTICATED_EXPIRED_REFRESH_TOKEN", "만료된 리프레시 토큰입니다."),
    INVALID_LOGIN_VALUE(401, "INVALID_LOGIN_VALUE", "로그인 정보가 올바르지 않습니다."),

    UNAUTHORIZED_ACCESS(403, "UNAUTHORIZED_ACCESS", "해당 API를 사용할 권한이 없습니다."),

    NOT_FOUND_MEMBER_ID(404, "NOT_FOUND_MEMBER_ID", "회원 정보를 찾을 수 없습니다."),


    /* 500 */
    IMAGE_SAVE_FAILED(500, "IMAGE_SAVE_FAILED", "이미지 저장에 실패하였습니다."),
    CANT_FOUND_FOLDER(500, "CANT_FOUND_FOLDER", "폴더를 찾을 수 없습니다."),
    SECOND_IMAGE_SAVE_FAILED(500, "SECOND_IMAGE_SAVE_FAILED", "두 번째 이미지 저장에 실패하였습니다."),
    REPORT_SAVE_FAILED(500, "REPORT_SAVE_FAILED", "신고 저장에 실패하였습니다."),
    REPORT_POINT_CHECK_FAILED(500, "REPORT_POINT_CHECK_FAILED", "위치 비교에 실패하였습니다."),
    IMAGE_CHANGE_FAILED(500, "IMAGE_CHANGE_FAILED", "이미지 반환에 실패하였습니다."),
    NOT_PROPER_POSITION(500, "NOT_PROPER_POSITION", "불법 주정차 구역이 아닙니다."),
    NOT_FOUND_LOCATION(500, "NOT_FOUND_LOCATION", "해당 GPS 위치를 찾을 수 없습니다.");


    private final int status;
    private final String code;
    private final String message;

    ErrorCode(final int status, final String code, final String message) {
        this.status = status;
        this.code = code;
        this.message = message;
    }

}
