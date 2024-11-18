package com.gilin.route.domain.member.dto.response;

import com.gilin.route.domain.member.entity.MemberPlace;
import jakarta.persistence.Column;

import java.time.LocalTime;

public record PlaceResponse(
    int type,
    Double x,
    Double y,
    String address,
    LocalTime arrivalTime,
    String name
) {
    public static PlaceResponse of(MemberPlace mp) {
        return new PlaceResponse(mp.getType(), mp.getX(), mp.getY(), mp.getAddress(), mp.getArrivalTime(), mp.getPlaceName());
    }
}
