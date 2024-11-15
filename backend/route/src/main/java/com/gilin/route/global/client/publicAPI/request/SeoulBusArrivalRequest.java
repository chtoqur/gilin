package com.gilin.route.global.client.publicAPI.request;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class SeoulBusArrivalRequest{
    private final String serviceKey;
    private final String stId;
}
