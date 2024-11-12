package com.gilin.route.domain.metro.service;

import com.gilin.route.domain.metro.dto.MetroExitToDest;
import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import com.gilin.route.global.dto.Coordinate;

public interface MetroService {

    PollyLineResponseDto getMetroPollyLine(Integer startId, Integer endId);

    MetroLinkDto getMetroLink(Integer startId, Integer endId);

    MetroExitToDest getClosestExit(Integer startStationId, Coordinate dest);
}
