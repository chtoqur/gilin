package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;
import com.gilin.route.domain.member.entity.Member;

public interface MemberService {
    LoginResponse login(OAuthLoginRequest oAuthLoginRequest);
    LoginResponse reissue(String refreshToken);
    LoginResponse register(OAuthRegisterRequest oAuthRegisterRequest);
    void updatePlace(Member member, MemberPlacePutRequest request);
}
