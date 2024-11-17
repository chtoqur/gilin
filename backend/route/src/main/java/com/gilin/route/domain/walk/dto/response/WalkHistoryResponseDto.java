package com.gilin.route.domain.walk.dto.response;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;

/**
 * 회원의 걷기 속도 (m/s)
 *
 * @param average 평균 속도
 * @param max     최고기록
 */
@Builder
public record WalkHistoryResponseDto(
    @Schema(name = "average", description = "평균 속력 (m/s)") Double average,
    @Schema(name = "max", description = "최고 속력 (m/s)") Double max
) {

}
