package com.gilin.route.domain.walk.controller;


import com.gilin.route.domain.member.dto.Authenticated;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.walk.dto.request.WalkHistoryRequestDto;
import com.gilin.route.domain.walk.dto.response.WalkHistoryResponseDto;
import com.gilin.route.domain.walk.service.WalkService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/walk", produces = MediaType.APPLICATION_JSON_VALUE)
public class WalkController {

    private final WalkService walkService;

    @PostMapping
    @Operation(
        summary = "도보 기록 저장",
        description = "사용자의 도보 기록을 저장합니다.",
        responses = {
            @ApiResponse(
                responseCode = "204",
                description = "도보 기록 저장 성공, 응답 본문 없음"
            ),
            @ApiResponse(
                responseCode = "400",
                description = "잘못된 요청",
                content = @Content(schema = @Schema())
            ),
            @ApiResponse(
                responseCode = "401",
                description = "인증 실패",
                content = @Content(schema = @Schema())
            )
        }
    )
    public ResponseEntity<Void> walkHistorySave(
        @RequestBody WalkHistoryRequestDto request,
        @Authenticated Member member
    ) {
        walkService.saveWalkHistory(request, member);
        return ResponseEntity.noContent()
                             .build();
    }

    @GetMapping
    @Operation(
        summary = "도보 기록 조회",
        description = "현재 사용자(Member)의 도보 기록을 조회합니다. 평균 속력, 최고 속력이 m/s 단위로 표시됩니다.",
        responses = {
            @ApiResponse(
                responseCode = "200",
                description = "도보 기록 조회 성공",
                content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = WalkHistoryResponseDto.class)
                )
            ),
            @ApiResponse(
                responseCode = "401",
                description = "인증 실패",
                content = @Content(schema = @Schema())
            ),
            @ApiResponse(
                responseCode = "404",
                description = "도보 기록을 찾을 수 없음",
                content = @Content(schema = @Schema())
            )
        }
    )
    public ResponseEntity<WalkHistoryResponseDto> walkHistory(
        @Authenticated Member member
    ) {
        return ResponseEntity.ok(walkService.getWalkHistory(member));
    }


}
