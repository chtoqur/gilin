package com.gilin.route.domain.route.dto.response;

public enum TravelType {
    WALK,
    BUS,
    METRO,
    TAXI,
    BICYCLE;

    public static TravelType fromTrafficType(int trafficType) {
        return switch (trafficType) {
            case 1 -> METRO;
            case 2 -> BUS;
            case 3 -> WALK;
            default -> TAXI;
        };
    }
}
