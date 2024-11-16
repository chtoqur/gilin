package com.gilin.route.domain.bus.dto;

public record BusArrivalResponse(
        String busName,
        Integer predictTimeSecond,
        Integer remainStation
) {
}
