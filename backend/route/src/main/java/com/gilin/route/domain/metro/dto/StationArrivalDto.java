package com.gilin.route.domain.metro.dto;

/**
 * @param stationName 검색한 역 이름
 * @param line        호선 정보 (1호선, 2호선, ...)
 * @param trainLineNm 목적역 (당고개행, 사당행, ...)
 * @param time        남은 시간 (분)
 * @param trainNo     해당 열차 번호
 */
public record StationArrivalDto(
    String stationName,
    String line,
    String trainLineNm,
    Integer time,
    Integer trainNo
) {

}
