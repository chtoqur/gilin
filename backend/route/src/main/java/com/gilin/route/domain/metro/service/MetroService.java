package com.gilin.route.domain.metro.service;

import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import java.util.List;

public interface MetroService {

    List<PollyLineResponseDto> getMetroPollyLine(Integer startId, Integer endId);

}
