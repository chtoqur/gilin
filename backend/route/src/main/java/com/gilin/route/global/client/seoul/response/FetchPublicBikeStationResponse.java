package com.gilin.route.global.client.seoul.response;

import java.util.List;

public record FetchPublicBikeStationResponse(
        RentBikeStatus rentBikeStatus
) {

    public record RentBikeStatus(
            Integer listTotalCount,
            Result result,
            List<BikeStation> row
    ){}

    public record Result(
            String code,
            String message
    ){}

    public record BikeStation(
            String rackTotCnt,
            String stationName,
            String parkingBikeTotCnt,
            String shared,
            String stationLatitude,
            String stationLongitude,
            String stationId
    ) {}
}
