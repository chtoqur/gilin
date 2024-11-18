package com.gilin.route.domain.taxi.dto;

import com.gilin.route.global.dto.Coordinate;
import java.util.List;
import lombok.Builder;

@Builder
public record TaxiInfo(
    Integer price,
    Integer distance,
    Integer time,
    List<Coordinate> coordinates,
    String address
) {

}
