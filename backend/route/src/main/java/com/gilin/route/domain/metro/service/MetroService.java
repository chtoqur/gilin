package com.gilin.route.domain.metro.service;

import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.PollyLineResponseDto;

public interface MetroService {

    PollyLineResponseDto getMetroPollyLine(Integer startId, Integer endId);

    MetroLinkDto getMetroLink(Integer startId, Integer endId);
}
