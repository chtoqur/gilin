package com.gilin.route.domain.member.dto;

public record TokenResponse(
        String accessToken,
        String refreshToken
) {
}
