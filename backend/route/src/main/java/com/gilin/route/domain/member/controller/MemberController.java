package com.gilin.route.domain.member.controller;

import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;
import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/login")
    @Operation(description = "OAuth 에서 받은 Token을 사용해 로그인 합니다.", summary = "OAuth 에서 받은 Token을 사용해 로그인 합니다.")
    public ResponseEntity<LoginResponse> oauthLogin(@RequestBody OAuthLoginRequest oAuthLoginRequest) {
        return ResponseEntity.ok(memberService.login(oAuthLoginRequest));
    }

    @PostMapping("/register")
    @Operation(description = "OAuth 에서 받은 Token과 사용자 정보로 회원가입 합니다.", summary = "OAuth 에서 받은 Token과 사용자 정보로 회원가입 합니다.")
    public ResponseEntity<LoginResponse> oauthRegister(@RequestBody OAuthRegisterRequest oAuthRegisterRequest) {

    }

    @PostMapping("/reissue")
    public ResponseEntity<LoginResponse> reissue(@RequestBody String refreshToken) {

        return ResponseEntity.ok(memberService.reissue(refreshToken));
    }

    @PutMapping("/place")
    @Operation(summary = "장소 정보 업데이트", description = "사용자의 장소 정보를 업데이트합니다. 이 엔드포인트는 인증이 필요합니다.")
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
