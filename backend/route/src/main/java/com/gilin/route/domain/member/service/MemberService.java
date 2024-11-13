package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.request.OAuthTokenRequest;
import com.gilin.route.domain.member.dto.response.TokenResponse;

public interface MemberService {
    TokenResponse login(OAuthTokenRequest oAuthTokenRequest);
    TokenResponse reissue(String refreshToken);
}
