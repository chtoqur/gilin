package com.gilin.route.domain.route.dto.response;

import java.util.EnumSet;

public enum TravelType {
    METRO,
    BUS,
    TAXI,
    BICYCLE,
    WALK,
    TRANSFER;

    public static TravelType fromTrafficType(int trafficType) {
        return switch (trafficType) {
            case 1 -> METRO;
            case 2 -> BUS;
            case 3 -> WALK;
            case 4 -> BICYCLE;
            case 5 -> TRANSFER;
            default -> TAXI;
        };
    }

    public static EnumSet<TravelType> bitToTravelType(int bit) {
        EnumSet<TravelType> travelTypes = EnumSet.noneOf(TravelType.class);

        if ((bit & 0b00001) != 0) {
            travelTypes.add(METRO);
        }
        if ((bit & 0b00010) != 0) {
            travelTypes.add(BUS);
        }
        if ((bit & 0b00100) != 0) {
            travelTypes.add(TAXI);
        }
        if ((bit & 0b01000) != 0) {
            travelTypes.add(BICYCLE);
        }
        if ((bit & 0b10000) != 0) {
            travelTypes.add(WALK);
        }

        return travelTypes;
    }
}
