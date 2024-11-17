package com.gilin.route.domain.walk.dto.response;


import lombok.Builder;

/**
 * 회원의 걷기 속도 (m/s)
 *
 * @param average 평균 속도
 * @param max     최고기록
 */
@Builder
public record WalkHistoryResponseDto(
    Double average,
    Double max
) {

}
