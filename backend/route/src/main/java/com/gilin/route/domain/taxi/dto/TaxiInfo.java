package com.gilin.route.domain.taxi.dto;

import com.gilin.route.global.dto.Coordinate;
import lombok.Builder;

import java.util.List;

@Builder
public record TaxiInfo(
        Integer price,
        Integer distance,
        Integer time,
        List<Coordinate> coordinates
) {
}
