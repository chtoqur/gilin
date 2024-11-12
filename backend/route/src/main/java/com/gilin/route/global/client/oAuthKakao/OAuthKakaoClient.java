package com.gilin.route.global.client.oAuthKakao;

import com.gilin.route.domain.member.dto.KakaoInfoResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "oauthKakaoClient", url = "https://kapi.kakao.com")
public interface OAuthKakaoClient {
    @GetMapping(value = "/v2/user/me", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    KakaoInfoResponse getUser(@RequestHeader("Authorization") String accessToken);
}
