package com.gilin.route.domain.metro.dto;

import lombok.Builder;

@Builder
public record MetroLinkDto(String startName, Integer startId, Double startX, Double startY,String endName, Integer endId, Double endX, Double endY) {

}
