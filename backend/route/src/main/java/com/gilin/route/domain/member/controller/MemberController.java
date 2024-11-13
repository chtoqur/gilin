package com.gilin.route.domain.member.controller;

import com.gilin.route.domain.member.dto.Authenticated;
import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;
import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.service.MemberService;
import com.gilin.route.global.error.GilinException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/login")
    @Operation(summary = "OAuth 로그인", description = "OAuth에서 받은 액세스 토큰을 사용하여 로그인합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = LoginResponse.class))),
            @ApiResponse(responseCode = "401", description = "회원가입 필요 또는 인증 실패",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = ErrorResponse.class)))
    })
    public ResponseEntity<LoginResponse> oauthLogin(@RequestBody OAuthLoginRequest oAuthLoginRequest) {
        return ResponseEntity.ok(memberService.login(oAuthLoginRequest));
    }


    @PostMapping("/register")
    @Operation(summary = "OAuth 회원가입", description = "OAuth에서 받은 토큰과 사용자 정보를 사용하여 회원가입합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "회원가입 및 로그인 성공",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = LoginResponse.class))),
            @ApiResponse(responseCode = "409", description = "이미 가입한 회원")
    })
    public ResponseEntity<LoginResponse> oauthRegister(@RequestBody OAuthRegisterRequest oAuthRegisterRequest) {
        return ResponseEntity.ok(memberService.register(oAuthRegisterRequest));
    }

    @PostMapping("/reissue")
    @Operation(summary = "토큰 재발급", description = "리프레시 토큰을 사용하여 새로운 액세스 토큰과 리프레시 토큰을 발급받습니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "토큰 재발급 성공",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = LoginResponse.class))),
            @ApiResponse(responseCode = "401", description = "유효하지 않은 리프레시 토큰")
    })
    public ResponseEntity<LoginResponse> reissue(@RequestBody String refreshToken) {
        return ResponseEntity.ok(memberService.reissue(refreshToken));
    }

    @PutMapping("/place")
    @Operation(summary = "장소 정보 업데이트", description = "사용자의 장소 정보를 업데이트합니다. JWT 토큰이 필요합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "업데이트 성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패",
                    content = @Content(mediaType = "application/json"))
    })
    public ResponseEntity<?> updatePlace(@Authenticated Member member, @RequestBody MemberPlacePutRequest request) {
        if (Objects.isNull(member)) throw new GilinException(HttpStatus.UNAUTHORIZED, "");
        memberService.updatePlace(member, request);
        return ResponseEntity.ok(null);
    }
}
