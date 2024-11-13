package com.gilin.route.domain.member.dto.response;

public record TokenResponse(
        String accessToken,
        String refreshToken
) {
}
