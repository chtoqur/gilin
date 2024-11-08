package com.gilin.route.domain.bus.dto;

public record Coordinate(
        Double latitude,
        Double longitude
) {
    public double distanceFrom(Coordinate other) {
        double latDiff = other.latitude - latitude;
        double lngDiff = other.longitude - longitude;
        return Math.sqrt(Math.pow(latDiff, 2) + Math.pow(lngDiff, 2));
    }
}
