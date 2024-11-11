package com.gilin.route.global.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class APIKeyConfig {

    private final String[] ODSayKeys;
    private final String[] TMapKeys;
    private final String[] SeoulKeys;
    private final String[] KakaoKeys;

    public APIKeyConfig(@Value("${apikey.odsays}") String[] ODSayKeys,
        @Value("${apikey.tmap}") String[] TMapKeys) {
    public APIKeyConfig(@Value("${apikey.odsays}") String[] ODSayKeys,
                        @Value("${apikey.seouls}") String[] SeoulKeys,
                        @Value("${apikey.kakaos}") String[] KakaoKeys) {
        this.ODSayKeys = ODSayKeys;
        this.TMapKeys = TMapKeys;
        this.SeoulKeys = SeoulKeys;
        this.KakaoKeys = KakaoKeys;
    }

    public String getODSayKey() {
        return ODSayKeys[0];

    }

    public String getTMapKey() {
        return TMapKeys[0];
    }

    public String getSeoulKey() { return SeoulKeys[0]; }

    public String getKakaoKey() { return KakaoKeys[0]; }
}