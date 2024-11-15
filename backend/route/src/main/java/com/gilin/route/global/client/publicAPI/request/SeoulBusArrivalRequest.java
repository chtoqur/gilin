package com.gilin.route.global.client.publicAPI.request;

public record SeoulBusArrivalRequest(
        String serviceKey,
        String stId
) {
}
