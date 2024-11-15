package com.gilin.route.domain.metro.dto;

import lombok.Builder;

/**
 * @param stationName 현재 위치한 역
 * @param line        호선 정보 (1호선, 2호선, ...)
 * @param trainLineNm 목적역 (당고개행, 사당행, ...)
 * @param trainNo     해당 열차 번호
 * @param status      현재 상태 (진입중, 출발,...)
 */
@Builder
public record MetroPositionDto(
    String stationName,
    String line,
    String trainLineNm,
    String trainNo,
    String status
) {

    public static String stat(String status) {
        //(0:진입 1:도착, 2:출발, 3:전역출발)
        switch (status) {
            case "0":
                return "진입";
            case "1":
                return "도착";
            case "2":
                return "출발";
            case "3":
                return "전역출발";
            default:
                return "오류";
        }

    }

}
