package com.gilin.route.domain.bus.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gilin.route.domain.bus.dto.Coordinate;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public final class BusServiceImpl implements BusService {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper;

    @Override
    public RouteResponse.SubPathh convertToSubPathh(SearchPubTransPathResponse.Result.SubPath subPath) {
        if (subPath.getTrafficType() != 2) return null;
        if (subPath.getStartStationCityCode() > 1310) { // 서울 경기 외 지역
            return null;
        }
        Long routeId = Long.parseLong(subPath.getLane().get(0).getBusLocalBlID());
        Coordinate startStation = new Coordinate(subPath.getStartX(), subPath.getStartY());
        Coordinate endStation = new Coordinate(subPath.getEndX(), subPath.getEndY());
        List<Coordinate> pathGraph = getPathGraph(routeId, startStation, endStation);

        return RouteResponse.SubPathh.of(subPath, pathGraph);
    }

    public List<Coordinate> getPathGraph(Long routeId, Coordinate startStation, Coordinate endStation) {
        String json = redisTemplate.opsForValue().get(routeId.toString());
        if (Objects.isNull(json)) return null;

        List<Coordinate> fullPath;
        try {
            fullPath = objectMapper.readValue(json,  new TypeReference<List<Coordinate>>() {});
        } catch (JsonProcessingException e) {
            return null;
        }

        return getPathGraph(fullPath, startStation, endStation);
    }

    private List<Coordinate> getPathGraph(List<Coordinate> fullPath, Coordinate startStation, Coordinate endStation) {
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
