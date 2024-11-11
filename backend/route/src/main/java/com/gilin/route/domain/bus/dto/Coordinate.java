package com.gilin.route.domain.bus.dto;

public record Coordinate(
        Double x, // 경도 x longitude
        Double y // 위도 y latitude
) {
    public double distanceFrom(Coordinate other) {
        double latDiff = other.y - y;
        double lngDiff = other.x - x;
        return Math.sqrt(Math.pow(latDiff, 2) + Math.pow(lngDiff, 2));
    }
}
