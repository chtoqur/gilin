package com.gilin.route.domain.bus.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gilin.route.domain.bus.dto.BusArrivalResponse;
import com.gilin.route.domain.bus.dto.BusCoordinate;
import com.gilin.route.global.client.publicAPI.GyeonggiBusArrivalClient;
import com.gilin.route.global.client.publicAPI.SeoulBusArrivalClient;
import com.gilin.route.global.client.publicAPI.request.GyeonggiBusArrivalRequest;
import com.gilin.route.global.client.publicAPI.request.SeoulBusStationArrivalRequest;
import com.gilin.route.global.client.publicAPI.response.gyeonggi.BusArrivalList;
import com.gilin.route.global.client.publicAPI.response.gyeonggi.GyeonggiBusArrivalResponse;
import com.gilin.route.global.client.publicAPI.response.seoul.ServiceResult;
import com.gilin.route.global.client.publicAPI.response.seoul.StationItemList;
import com.gilin.route.global.config.APIKeyConfig;
import com.gilin.route.global.dto.Coordinate;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

@Slf4j
@Service
@RequiredArgsConstructor
public final class BusServiceImpl implements BusService {

    private final RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper;
    private final APIKeyConfig apiKeyConfig;
    private final SeoulBusArrivalClient seoulBusArrivalClient;
    private final GyeonggiBusArrivalClient gyeonggiBusArrivalClient;

    @Override
    public RouteResponse.SubPathh convertToSubPathh(
        SearchPubTransPathResponse.Result.SubPath subPath) {
        if (subPath.getTrafficType() != 2) {
            return null;
        }
        if (subPath.getStartStationCityCode() > 1310) { // 서울 경기 외 지역
            return null;
        }
        Long routeId = Long.parseLong(subPath.getLane()
                                             .get(0)
                                             .getBusLocalBlID());
        Coordinate startStation = new Coordinate(subPath.getStartX(), subPath.getStartY());
        Coordinate endStation = new Coordinate(subPath.getEndX(), subPath.getEndY());
        List<Coordinate> pathGraph = getPathGraph(routeId, startStation, endStation);
        return RouteResponse.SubPathh.of(subPath, pathGraph);
    }

    public List<Coordinate> getPathGraph(Long routeId, Coordinate startStation,
        Coordinate endStation) {
        String json = redisTemplate.opsForValue()
                                   .get(routeId.toString());
        if (Objects.isNull(json)) {
            return null;
        }

        List<BusCoordinate> fullPath;
        try {
            fullPath = objectMapper.readValue(json, new TypeReference<List<BusCoordinate>>() {

            });
        } catch (JsonProcessingException e) {
            return null;
        }

        return getPathGraph(fullPath.stream().map(BusCoordinate::toCoordinate).toList(), startStation, endStation);
    }

    private List<Coordinate> getPathGraph(List<Coordinate> fullPath, Coordinate startStation,
        Coordinate endStation) {
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
        if (startIdx > endIdx) {
            List<Coordinate> reversedSubList = new ArrayList<>(fullPath.subList(endIdx, startIdx + 1));
            Collections.reverse(reversedSubList);
            subPath.addAll(reversedSubList);
        } else {
            subPath.addAll(fullPath.subList(startIdx, endIdx + 1));
        }
        subPath.add(endStation);

        return subPath;
    }

    @Override
    public List<BusArrivalResponse> getArrivalTime(String stationId, String arsId, List<String> routeIds) {
        var ggRequest = new GyeonggiBusArrivalRequest(apiKeyConfig.getPublicKey(), stationId);
        GyeonggiBusArrivalResponse ggResponse = gyeonggiBusArrivalClient.getBusArrivalList(ggRequest);
        var seoulRequest = new SeoulBusStationArrivalRequest(apiKeyConfig.getPublicKey(), arsId);
        ServiceResult<StationItemList> seoulResponse =  seoulBusArrivalClient.getStationByUid(seoulRequest);

        List<BusArrivalResponse> response = parseGGBus(ggResponse, routeIds);
        response.addAll(parseSeoulBus(seoulResponse, routeIds));

        return response;
    }

    private List<BusArrivalResponse> parseGGBus(GyeonggiBusArrivalResponse response, List<String> routeIds) {
        if (Objects.isNull(response)
                || Objects.isNull(response.msgHeader())
                || "0".equals(response.msgHeader().resultCode())) {
            return new ArrayList<>();
        }

        List<BusArrivalList> busArrivalList = response.msgBody().busArrivalList();
        List<BusArrivalResponse> arrivalResponses = new ArrayList<>();

        for (BusArrivalList arrival : busArrivalList) {
            if (routeIds.contains(arrival.routeId())) {
                arrivalResponses.add(new BusArrivalResponse(arrival.routeId(), arrival.predictTime1(), -1));
            }
        }

        return arrivalResponses;
    }

    private List<BusArrivalResponse> parseSeoulBus(ServiceResult<StationItemList> response, List<String> routeIds) {
        if (response == null || response.msgBody() == null || response.msgBody().itemList() == null) {
            return Collections.emptyList();
        }

        return response.msgBody().itemList().stream()
                .filter(item -> routeIds.contains(item.busRouteId()))
                .flatMap(item -> Stream.of(
                        createBusArrivalResponse(item.busRouteId(), item.arrmsg1(), item.rtNm()),
                        createBusArrivalResponse(item.busRouteId(), item.arrmsg2(), item.rtNm())
                ))
                .filter(Objects::nonNull) // Null 제거
                .toList();
    }

    private BusArrivalResponse createBusArrivalResponse(String routeId, String arrmsg, String busNumber) {
        if (arrmsg == null || arrmsg.isBlank()) {
            return null;
        }

        try {
            if (arrmsg.contains("곧 도착")) {
                return new BusArrivalResponse(routeId, 0, 1);
            }

            Pattern pattern = Pattern.compile("(?:(\\d+)분)?\\s*(?:(\\d+)초)?후\\[(\\d+)번째 전\\]");
            Matcher matcher = pattern.matcher(arrmsg);

            if (matcher.find()) {
                String minutes = matcher.group(1);
                String seconds = matcher.group(2);
                String stations = matcher.group(3);

                Integer predictTimeSecond = (minutes != null ? Integer.parseInt(minutes) * 60 : 0) +
                        (seconds != null ? Integer.parseInt(seconds) : 0);
                Integer remainStation = Integer.parseInt(stations);

                return new BusArrivalResponse(busNumber, predictTimeSecond, remainStation);
            }
        } catch (Exception e) {
            return null;
        }
        return null;
    }
}
