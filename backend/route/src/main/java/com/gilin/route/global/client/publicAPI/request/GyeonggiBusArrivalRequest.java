package com.gilin.route.global.client.publicAPI.request;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GyeonggiBusArrivalRequest {
    String serviceKey;
    String stationId;
}