package com.gilin.route.domain.metro.dto;

import java.util.List;
import lombok.Builder;

/**
 * @param pollyLinePosList PollyLine 을 그리기 위한 좌표 정보 리스트
 */
@Builder
public record PollyLineResponseDto(
    List<PollyLinePos> pollyLinePosList
) {

}
