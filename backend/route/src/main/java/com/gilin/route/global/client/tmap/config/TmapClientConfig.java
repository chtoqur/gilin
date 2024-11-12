package com.gilin.route.global.client.tmap.config;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class TmapClientConfig {

    @Value("${apikey.tmap}")
    private String apiKey;

    @Bean
    public RequestInterceptor getRequestInterceptor() {
        return requestTemplate -> requestTemplate.header("appKey", apiKey);
    }
}
