package com.gilin.route.global.client.publicAPI.request;

public record GyeonggiBusArrivalRequest(
    String serviceKey,
    String stationId
) {}