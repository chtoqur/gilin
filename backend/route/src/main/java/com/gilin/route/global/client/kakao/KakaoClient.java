package com.gilin.route.global.client.kakao;

import com.gilin.route.global.client.kakao.request.SearchKakaoCarDirectionRequest;
import com.gilin.route.global.client.kakao.response.SearchKakaoCarDirectionResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(url = "https://apis-navi.kakaomobility.com/v1", name = "KakaoClient")
public interface KakaoClient {

    @GetMapping("/directions")
    SearchKakaoCarDirectionResponse searchKakaoCarDirection(
            @SpringQueryMap SearchKakaoCarDirectionRequest searchKakaoCarDirectionRequest,
            @RequestHeader(name = "Authorization") String apiCSK
    );
}