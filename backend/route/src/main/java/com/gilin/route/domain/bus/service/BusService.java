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

    public List<Coordinate> getSubPath(Long routeId, Coordinate startAt, Coordinate endAt) {
        String json = redisTemplate.opsForValue().get(routeId.toString());
        if (Objects.isNull(json)) return null;

        List<Coordinate> fullPath;
        try {
            fullPath = objectMapper.readValue(json,  new TypeReference<List<Coordinate>>() {});
        } catch (JsonProcessingException e) {
            return null;
        }

        return getSubPath(fullPath, startAt, endAt);
    }

    private List<Coordinate> getSubPath(List<Coordinate> fullPath, Coordinate startAt, Coordinate endAt) {
        int startIdx = 0, endIdx = 0;
        double minToStart = Double.MAX_VALUE, minToEnd = Double.MAX_VALUE;

        for (int i = 0; i < fullPath.size(); i++) {
            Coordinate currCoordinate = fullPath.get(i);
            double distanceFromStart = startAt.distanceFrom(currCoordinate);
            double distanceFromEnd = endAt.distanceFrom(currCoordinate);

            if (distanceFromStart < minToStart) {
                minToStart = startAt.distanceFrom(currCoordinate);
                startIdx = i;
            }
            if (distanceFromEnd < minToEnd) {
                minToEnd = endAt.distanceFrom(currCoordinate);
                endIdx = i;
            }
        }
        List<Coordinate> subPath = new ArrayList<>();
        subPath.add(startAt);
        subPath.addAll(fullPath.subList(startIdx, endIdx + 1));
        subPath.add(endAt);

        return subPath;
    }
}
