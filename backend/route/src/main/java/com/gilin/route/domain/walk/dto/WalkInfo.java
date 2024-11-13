package com.gilin.route.domain.walk.dto;

import com.gilin.route.global.dto.Coordinate;
import java.util.List;
import lombok.Builder;

@Builder
public record WalkInfo(
    Integer distance,
    Integer time,
    List<Coordinate> coordinates
) {

}
