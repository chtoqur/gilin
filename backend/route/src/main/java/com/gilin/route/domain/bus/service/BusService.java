package com.gilin.route.domain.bus.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gilin.route.domain.bus.dto.Coordinate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public final class BusService {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper;

    public List<Coordinate> getSubPath(Long routeId, Coordinate startStation, Coordinate endStation) {
        String json = redisTemplate.opsForValue().get(routeId.toString());
        if (Objects.isNull(json)) return null;

        List<Coordinate> fullPath;
        try {
            fullPath = objectMapper.readValue(json,  new TypeReference<List<Coordinate>>() {});
        } catch (JsonProcessingException e) {
            return null;
        }

        return getSubPath(fullPath, startStation, endStation);
    }

    private List<Coordinate> getSubPath(List<Coordinate> fullPath, Coordinate startStation, Coordinate endStation) {
        int startIdx = 0, endIdx = 0;
        double minToStart = Double.MAX_VALUE, minToEnd = Double.MAX_VALUE;

        for (int i = 0; i < fullPath.size(); i++) {
            Coordinate currCoordinate = fullPath.get(i);
            double distanceFromStart = startStation.distanceFrom(currCoordinate);
            double distanceFromEnd = endStation.distanceFrom(currCoordinate);

            if (distanceFromStart < minToStart) {
                minToStart = startStation.distanceFrom(currCoordinate);
                startIdx = i;
            }
            if (distanceFromEnd < minToEnd) {
                minToEnd = endStation.distanceFrom(currCoordinate);
                endIdx = i;
            }
        }
        List<Coordinate> subPath = new ArrayList<>();
        subPath.add(startStation);
        subPath.addAll(fullPath.subList(startIdx, endIdx + 1));
        subPath.add(endStation);

        return subPath;
    }
}
