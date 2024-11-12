package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.OAuthTokenRequest;
import com.gilin.route.domain.member.dto.TokenResponse;

public interface MemberService {
    TokenResponse login(OAuthTokenRequest oAuthTokenRequest);
    TokenResponse reissue(String refreshToken);
}
