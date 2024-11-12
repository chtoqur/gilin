package com.gilin.route.domain.member.controller;

import com.gilin.route.domain.member.dto.OAuthTokenRequest;
import com.gilin.route.domain.member.dto.TokenResponse;
import com.gilin.route.domain.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController("/user")
@RequiredArgsConstructor
public class MemeberController {

    private final MemberService memberService;

    public ResponseEntity<TokenResponse> oauthLogin(@RequestBody OAuthTokenRequest oAuthTokenRequest) {
        return ResponseEntity.ok(memberService.login(oAuthTokenRequest));
    }
}
