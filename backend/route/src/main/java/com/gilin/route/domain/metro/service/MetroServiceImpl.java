package com.gilin.route.domain.metro.service;


import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class MetroServiceImpl implements MetroService{

    @Override
    public List<PollyLineResponseDto> getMetroPollyLine(Integer startId, Integer endId) {
        return List.of();
    }
}
