package com.gilin.route.domain.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;

@Builder
public record LoginResponse(
        String accessToken,
        String refreshToken,
        @Schema(example = "김서영")
        String name,
        @Schema(example = "W")
        String gender,
        Integer age
) {
}
