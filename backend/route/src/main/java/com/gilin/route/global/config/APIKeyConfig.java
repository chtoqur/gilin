package com.gilin.route.global.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class APIKeyConfig {

    private final String[] ODSayKeys;
    private final String[] publicKeys;

    public APIKeyConfig(@Value("${apikey.odsays}") String[] ODSayKeys,
                        @Value("${apikey.public}") String[] publicKeys
    ) {
        this.ODSayKeys = ODSayKeys;
        this.publicKeys = publicKeys;
    }

    public String getODSayKey() {
        return ODSayKeys[0];
    }

    public String getPublicKey() {
        return publicKeys[0];
    }
}