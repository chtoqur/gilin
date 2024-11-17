package com.gilin.route.domain.walk.dto.request;


/**
 * @param distance 걷기 거리
 * @param time     걸은 시간
 */
public record WalkHistoryRequestDto(
    Integer distance,
    Integer time
) {

}
