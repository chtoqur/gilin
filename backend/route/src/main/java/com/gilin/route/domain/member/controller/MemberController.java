package com.gilin.route.domain.member.controller;

import com.gilin.route.domain.member.dto.request.OAuthTokenRequest;
import com.gilin.route.domain.member.dto.response.TokenResponse;
import com.gilin.route.domain.member.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/login")
    @Operation(description = "OAuth 에서 받은 Token을 사용해 로그인/회원가입 합니다.", summary = "OAuth 에서 받은 Token을 사용해 로그인/회원가입 합니다.")
    public ResponseEntity<TokenResponse> oauthLogin(@RequestBody OAuthTokenRequest oAuthTokenRequest) {
        return ResponseEntity.ok(memberService.login(oAuthTokenRequest));
    }

    @PostMapping("/reissue")
    public ResponseEntity<TokenResponse> reissue(@RequestBody String refreshToken) {
        return ResponseEntity.ok(memberService.reissue(refreshToken));
    }
}
