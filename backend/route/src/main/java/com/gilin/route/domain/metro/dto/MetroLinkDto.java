package com.gilin.route.domain.metro.dto;

import lombok.Builder;

/**
 * @param startName 시작역 이름
 * @param startId   시작역 코드
 * @param startX    시작역 X좌표
 * @param startY    시작역 Y좌표
 * @param endName   도착역 이름
 * @param endId     도착역 코드
 * @param endX      도착역 X좌표
 * @param endY      도착역 Y좌표
 */
@Builder
public record MetroLinkDto(
    String startName,
    Integer startId,
    Double startX,
    Double startY,
    String endName,
    Integer endId,
    Double endX,
    Double endY
) {

}
