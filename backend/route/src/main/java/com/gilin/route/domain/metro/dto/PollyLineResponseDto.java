package com.gilin.route.domain.metro.dto;

import java.util.List;

/**
 * @param pollyLinePosList PollyLine 을 그리기 위한 좌표 정보 리스트
 */
public record PollyLineResponseDto(List<PollyLinePos> pollyLinePosList) {

}
