package com.ssafy.a303.backend.domain.report.entity;

public enum ProcessStatus {

/*
    1차 사진 분석중: ONGOING,
    1차 사진 분석 완료: FIRST_ANALYSIS_SUCCESS,
    1차 사진 요건 불충족: CANCELLED_FIRST_FAILED,
    2차 사진 요건 불충족: CANCELLED_SECOND_FAILED,
    심사중: ANALYSIS_SUCCESS,
    수용: ACCEPTED,
    불수용: UNACCEPTED
 */

    ONGOING,
    FIRST_ANALYSIS_SUCCESS,
    CANCELLED_FIRST_FAILED,
    CANCELLED_SECOND_FAILED,
    ANALYSIS_SUCCESS,
    ACCEPTED,
    UNACCEPTED

}