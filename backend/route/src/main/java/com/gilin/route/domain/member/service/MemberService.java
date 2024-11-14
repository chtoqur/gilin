package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;
import com.gilin.route.domain.member.dto.response.PlaceResponse;
import com.gilin.route.domain.member.entity.Member;

import java.util.List;

public interface MemberService {
    LoginResponse login(OAuthLoginRequest oAuthLoginRequest);
    LoginResponse reissue(String refreshToken);
    LoginResponse register(OAuthRegisterRequest oAuthRegisterRequest);
    LoginResponse testLogin(Long memberId);
    void updatePlace(Member member, MemberPlacePutRequest request);
    List<PlaceResponse> getPlace(Member member);
}
