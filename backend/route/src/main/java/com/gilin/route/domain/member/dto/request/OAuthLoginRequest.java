package com.gilin.route.domain.member.dto.request;

import com.gilin.route.domain.member.entity.OAuthType;
import io.swagger.v3.oas.annotations.media.Schema;

public record OAuthLoginRequest(
        @Schema(example = "KAKAO")
        OAuthType oAuthType,
        String accessToken,
        String refreshToken
) {
}
