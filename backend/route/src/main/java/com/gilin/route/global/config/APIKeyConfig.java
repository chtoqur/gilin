package com.gilin.route.global.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class APIKeyConfig {
    private final String[] ODSayKeys;
    private final String[] SeoulKeys;

    public APIKeyConfig(@Value("${apikey.odsays}") String[] ODSayKeys,
                        @Value("${apikey.seouls}") String[] SeoulKeys) {
        this.ODSayKeys = ODSayKeys;
        this.SeoulKeys = SeoulKeys;
    }

    public String getODSayKey() {
        return ODSayKeys[0];
    }

    public String getSeoulKey() { return SeoulKeys[0]; }
}