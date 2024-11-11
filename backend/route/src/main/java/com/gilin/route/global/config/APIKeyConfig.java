package com.gilin.route.global.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class APIKeyConfig {

    private final String[] ODSayKeys;
    private final String[] TMapKeys;

    public APIKeyConfig(@Value("${apikey.odsays}") String[] ODSayKeys,
        @Value("${apikey.tmap}") String[] TMapKeys) {
        this.ODSayKeys = ODSayKeys;
        this.TMapKeys = TMapKeys;
    }

    public String getODSayKey() {
        return ODSayKeys[0];
        
    }

    public String getTMapKey() {
        return TMapKeys[0];
    }
}