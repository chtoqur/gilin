package com.gilin.route.domain.bike.service;

import com.gilin.route.domain.bike.dto.BikeInfo;
import com.gilin.route.domain.bike.dto.BikeStationStatus;
import com.gilin.route.global.client.kakao.KakaoClient;
import com.gilin.route.global.client.kakao.request.SearchKakaoCarDirectionRequest;
import com.gilin.route.global.client.kakao.response.SearchKakaoCarDirectionResponse;
import com.gilin.route.global.dto.Coordinate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.geo.*;
import org.springframework.data.redis.connection.RedisGeoCommands;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.domain.geo.Metrics;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class BikeServiceImpl implements BikeService {

    private final KakaoClient kakaoClient;
    @Value("${apikey.kakaos}")
    private String apiKey;
    private final StringRedisTemplate redisTemplate;


    private static final int SEARCH_RADIUS_METERS = 300;
    private static final Distance SEARCH_RADIUS = new Distance(SEARCH_RADIUS_METERS, Metrics.METERS);

    @Value("${spring.data.redis.geokey}")
    private String GEO_KEY;

    @Override
    public List<BikeStationStatus> searchNearbyBikeStations(Coordinate point) {

        GeoResults<RedisGeoCommands.GeoLocation<String>> geoResults = queryGeoLocations(point, SEARCH_RADIUS, null);

        if (geoResults == null || geoResults.getContent().isEmpty()) {
            return List.of();
        }

        return geoResults.getContent().stream()
                .map(result -> getStationStatus(result.getContent().getName()))
                .flatMap(Optional::stream)
                .collect(Collectors.toList());
    }

    @Override
    public BikeStationStatus searchNearestBikeStation(Coordinate point) {

        GeoResults<RedisGeoCommands.GeoLocation<String>> geoResults = queryGeoLocations(point, SEARCH_RADIUS, 1);

        if (geoResults == null || geoResults.getContent().isEmpty()) {
            return null;
        }

        String stationName = geoResults.getContent().get(0).getContent().getName();
        return getStationStatus(stationName).orElse(null);
    }


    private GeoResults<RedisGeoCommands.GeoLocation<String>> queryGeoLocations(Coordinate point, Distance radius, Integer limit) {

        RedisGeoCommands.GeoRadiusCommandArgs args = RedisGeoCommands.GeoRadiusCommandArgs.newGeoRadiusArgs()
                .includeDistance()
                .sortAscending();

        if (limit != null) {
            args.limit(limit);
        }

        Circle searchArea = new Circle(new Point(point.x(), point.y()), radius);
        return redisTemplate.opsForGeo().radius(GEO_KEY, searchArea, args);
    }


    public Optional<BikeStationStatus> getStationStatus(String stationId) {
        Map<Object, Object> stationData = redisTemplate.opsForHash().entries(stationId);

        return Optional.of(stationData)
                .filter(data -> !data.isEmpty())
                .map(data -> BikeStationStatus.builder()
                        .stationId(stationId)
                        .stationName((String) data.get("stationName"))
                        .parkingBikeTotCnt(Integer.parseInt((String) data.get("parkingBikeTotCnt")))
                        .build());
    }

    @Override
    public BikeInfo getBikeInfo(Coordinate start, Coordinate end) {
        SearchKakaoCarDirectionRequest searchKakaoCarDirectionRequest = SearchKakaoCarDirectionRequest.builder()
                .origin(start.toCoordinateString())
                .destination(end.toCoordinateString())
                .priority("TIME")
                .avoid("ferries|toll|motorway|uturn")
                .carType(7)
                .alternatives(false)
                .build();

        SearchKakaoCarDirectionResponse response = kakaoClient.searchKakaoCarDirection(searchKakaoCarDirectionRequest, "KakaoAK " + apiKey);
        SearchKakaoCarDirectionResponse.RouteResponse route = response.routes().get(0);

        return BikeInfo.builder()
                .distance(route.summary().distance())
                .time(calculateEstimatedBikeTime(route))
                .coordinates(route.toCoordinates())
                .build();
    }


    public int calculateEstimatedBikeTime(SearchKakaoCarDirectionResponse.RouteResponse route) {
        double averageBikeSpeedMetersPerSecond = 15_000.0 / 3600.0;

        int totalDuration = 0;

        for (SearchKakaoCarDirectionResponse.RouteSection section : route.sections()) {
            for (SearchKakaoCarDirectionResponse.RouteRoad road : section.roads()) {
                int roadDistance = road.distance(); // m 단위 거리
                totalDuration += (int) Math.ceil(roadDistance / averageBikeSpeedMetersPerSecond);
            }
        }

        return totalDuration;
    }

}
