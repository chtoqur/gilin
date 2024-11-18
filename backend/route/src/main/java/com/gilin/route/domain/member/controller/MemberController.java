package com.gilin.route.domain.member.controller;

import com.gilin.route.domain.member.dto.Authenticated;
import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;
import com.gilin.route.domain.member.dto.response.PlaceResponse;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.service.MemberService;
import com.gilin.route.global.error.GilinException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.util.List;
import java.util.Objects;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping(value = "/user", produces = MediaType.APPLICATION_JSON_VALUE)
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
    public ResponseEntity<LoginResponse> oauthLogin(
        @RequestBody OAuthLoginRequest oAuthLoginRequest) {
        return ResponseEntity.ok(memberService.login(oAuthLoginRequest));
    }


    @PostMapping("/register")
    @Operation(summary = "OAuth 회원가입", description = "OAuth에서 받은 토큰과 사용자 정보를 사용하여 회원가입합니다.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "회원가입 및 로그인 성공",
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = LoginResponse.class))),
        @ApiResponse(responseCode = "409", description = "이미 가입한 회원")
    })
    public ResponseEntity<LoginResponse> oauthRegister(
        @RequestBody OAuthRegisterRequest oAuthRegisterRequest) {
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
    public ResponseEntity<?> updatePlace(@Authenticated Member member,
        @RequestBody MemberPlacePutRequest request) {
        if (Objects.isNull(member)) {
            throw new GilinException(HttpStatus.UNAUTHORIZED, "");
        }
        return ResponseEntity.ok(memberService.updatePlace(member, request));
    }

    @PostMapping("/test")
    @Operation(summary = "테스트 유저 토큰 발급", description = "테스트 유저 토큰 발급")
    public ResponseEntity<LoginResponse> test() {
        return ResponseEntity.ok(memberService.testLogin(1L));
    }

    @GetMapping("/place")
    @Operation(summary = "장소 정보 가져오기", description = "사용자의 장소 정보를 가져옵니다. JWT 토큰이 필요합니다.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "가져오기 성공"),
        @ApiResponse(responseCode = "401", description = "인증 실패", content = @Content(mediaType = "application/json"))
    })
    public ResponseEntity<List<PlaceResponse>> getPlace(@Authenticated Member member) {
        if (Objects.isNull(member)) {
            throw new GilinException(HttpStatus.UNAUTHORIZED, "");
        }
        return ResponseEntity.ok(memberService.getPlace(member));
    }

    @PutMapping("/name")
    @Operation(summary = "닉네임 바꾸기", description = "닉네임을 바꿉니다. JWT 토큰이 필요합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "닉네임 바꾸기 성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패", content = @Content(mediaType = "application/json"))
    })
    public ResponseEntity<String> changeName(@Authenticated Member member, @RequestParam String newName) {
        if (Objects.isNull(member)){
            throw new GilinException(HttpStatus.UNAUTHORIZED, "회원 정보 불러오기 실패");
        }
        return ResponseEntity.ok(memberService.changeName(member, newName));
    }
}
