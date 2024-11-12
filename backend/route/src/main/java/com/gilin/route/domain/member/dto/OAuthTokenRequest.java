package com.gilin.route.domain.member.dto;

public record OAuthTokenRequest(
        String accessToken,
        String refreshToken
) {
}
