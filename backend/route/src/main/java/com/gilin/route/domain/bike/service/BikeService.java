package com.gilin.route.domain.bike.service;

import com.gilin.route.domain.bike.dto.BikeInfo;
import com.gilin.route.domain.bike.dto.BikeStationStatus;
import com.gilin.route.global.dto.Coordinate;

import java.util.List;

public interface BikeService {
    List<BikeStationStatus> searchNearbyBikeStations(Coordinate point);

    BikeStationStatus searchNearestBikeStation(Coordinate point);

    BikeInfo getBikeInfo(Coordinate start, Coordinate end);
}
