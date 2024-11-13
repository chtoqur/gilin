package com.gilin.route.domain.member.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalTime;

public record MemberPlacePutRequest(
        @Schema(description = "장소 유형 (1: 집, 2: 회사, 3: 학교, 4: 기타)", example = "1", allowableValues = {"1", "2", "3", "4"})
        Integer type,
        Double x,
        Double y,
        @Schema(description = "장소의 주소", example = "서울특별시 중구 세종대로 110")
        String address,
        LocalTime arrivalTime
) {
}
