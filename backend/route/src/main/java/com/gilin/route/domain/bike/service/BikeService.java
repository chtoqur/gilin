package com.gilin.route.domain.bike.service;

import com.gilin.route.domain.bike.dto.BikeInfo;
import com.gilin.route.domain.bike.dto.BikeStationStatus;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.global.dto.Coordinate;

import java.util.List;

public interface BikeService {
    RouteResponse.SubPathh getBikeSubPathh(Coordinate start, Coordinate end);

    List<BikeStationStatus> searchNearbyBikeStations(Coordinate point);

    BikeStationStatus searchNearestBikeStation(Coordinate point);

    BikeInfo getBikeInfo(Coordinate start, Coordinate end);
}
