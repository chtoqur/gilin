package com.gilin.route.domain.bike.dto;

import lombok.Builder;

@Builder
public record BikeStationStatus(
        String stationId,
        String stationName,
        Integer parkingBikeTotCnt,
        Double x,
        Double y
) {

}
