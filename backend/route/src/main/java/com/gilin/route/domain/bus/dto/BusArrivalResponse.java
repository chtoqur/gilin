package com.gilin.route.domain.bus.dto;

public record BusArrivalResponse(
        String routeId,
        Integer predictTimeSecond,
        Integer remainStation
) {
}
