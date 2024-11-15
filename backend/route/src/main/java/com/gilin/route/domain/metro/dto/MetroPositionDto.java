package com.gilin.route.domain.metro.dto;

/**
 * @param stationName 현재 위치한 역
 * @param line        호선 정보 (1호선, 2호선, ...)
 * @param trainLineNm 목적역 (당고개행, 사당행, ...)
 * @param trainNo     해당 열차 번호
 * @param status      현재 상태 (진입중, 출발,...)
 */
public record MetroPositionDto(
    String stationName,
    String line,
    String trainLineNm,
    Integer trainNo,
    String status
) {

}
