package com.gilin.route.domain.bus.dto;

import com.gilin.route.global.dto.Coordinate;

public record BusCoordinate(
        Double longitude, // 경도 x
        Double latitude // 위도 y
) {
    public double distanceFrom(BusCoordinate other) {
        double latDiff = other.latitude - latitude;
        double lngDiff = other.longitude - longitude;
        return Math.sqrt(Math.pow(latDiff, 2) + Math.pow(lngDiff, 2));
    }
    public Coordinate toCoordinate() {
        return new Coordinate(longitude, latitude);
    }
}
