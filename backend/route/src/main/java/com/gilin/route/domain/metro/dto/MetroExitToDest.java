package com.gilin.route.domain.metro.dto;

import lombok.Builder;

@Builder
public record MetroExitToDest(
    Integer exitNum,
    Integer distance,
    Integer time
) {

}
