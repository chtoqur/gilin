package com.gilin.route.domain.metro.dto;


import lombok.Builder;

/**
 * @param x x 좌표
 * @param y y 좌표
 */
@Builder
public record PollyLinePos(
    Double x,
    Double y
) {

}
