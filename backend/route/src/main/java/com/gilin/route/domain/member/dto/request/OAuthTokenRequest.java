package com.gilin.route.domain.member.dto;

import com.gilin.route.domain.member.entity.OAuthType;
import io.swagger.v3.oas.annotations.media.Schema;

public record OAuthTokenRequest(
        @Schema(example = "KAKAO")
        OAuthType oAuthType,
        String accessToken,
        String refreshToken
) {
}
