package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;

public interface MemberService {
    LoginResponse login(OAuthLoginRequest oAuthLoginRequest);
    LoginResponse reissue(String refreshToken);
    LoginResponse register(OAuthRegisterRequest oAuthRegisterRequest);
}
