package com.gilin.route.domain.bike.dto;

import com.gilin.route.global.dto.Coordinate;
import lombok.Builder;

import java.util.List;

@Builder
public record BikeInfo(
        Integer distance,
        Integer time,
        List<Coordinate> coordinates
) {
}
