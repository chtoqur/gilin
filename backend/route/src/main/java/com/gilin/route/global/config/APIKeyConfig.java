package com.gilin.route.global.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class APIKeyConfig {

    private final String[] ODSayKeys;

    public APIKeyConfig(@Value("${apikey.odsays}") String[] ODSayKeys
    ) {
        this.ODSayKeys = ODSayKeys;
    }

    public String getODSayKey() {
        return ODSayKeys[0];

    }

}