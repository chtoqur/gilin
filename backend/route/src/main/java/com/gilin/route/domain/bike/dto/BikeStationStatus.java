package com.gilin.route.domain.bike.dto;

import lombok.Builder;

import java.util.Map;

@Builder
public record BikeStationStatus (
    String stationId,
    String stationName,
    Integer parkingBikeTotCnt
){

}
