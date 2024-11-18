package com.gilin.route.domain.bike.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gilin.route.domain.bike.dto.BikeInfo;
import com.gilin.route.domain.bike.dto.BikeStationStatus;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.global.client.kakao.KakaoClient;
import com.gilin.route.global.client.kakao.request.SearchKakaoCarDirectionRequest;
import com.gilin.route.global.client.kakao.response.SearchKakaoCarDirectionResponse;
import com.gilin.route.global.dto.Coordinate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.geo.Circle;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.GeoResults;
import org.springframework.data.geo.Point;
import org.springframework.data.redis.connection.RedisGeoCommands;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.domain.geo.Metrics;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class BikeServiceImpl implements BikeService {

    private static final int SEARCH_RADIUS_METERS = 300;
    private static final Distance SEARCH_RADIUS = new Distance(SEARCH_RADIUS_METERS, Metrics.METERS);
    private final KakaoClient kakaoClient;
    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;
    @Value("${apikey.kakaos}")
    private String apiKey;
    @Value("${spring.data.redis.geokey}")
    private String GEO_KEY;


    /**
     * 주변 300m 이내의 공공자전거 보관소 중 가장 가까우면서 자전거 보유 대수가 3대 이상인 보관소에서
     * 도착지 좌표에서 가장 가까운 공공자전거 보관소까지의 자전거 경로 BikeInfo를 Return
     *
     * @param start
     * @param end
     * @return
     */
    @Override
    public RouteResponse.SubPathh getBikeSubPathh(Coordinate start, Coordinate end) {

        List<BikeStationStatus> startBikeStations = searchNearbyBikeStations(start);
        BikeStationStatus startBikeStation = null;
        BikeStationStatus endBikeStation = searchNearestBikeStation(end);

        if (startBikeStations.isEmpty() || endBikeStation == null) return null;

        for (BikeStationStatus bikeStationStatus : startBikeStations) {
            if (bikeStationStatus.parkingBikeTotCnt() >= 3) {
                startBikeStation = bikeStationStatus;
                break;
            }
        }

        if (startBikeStation == null) return null;

        BikeInfo bikeInfo = getBikeInfoBetweenStations(startBikeStation, endBikeStation);
        return RouteResponse.SubPathh.builder()
                .distance(bikeInfo.distance())
                .sectionTime(bikeInfo.time())
                .pathGraph(bikeInfo.coordinates())
                .travelType(TravelType.BICYCLE)
                .startX(startBikeStation.x())
                .startY(startBikeStation.y())
                .endX(endBikeStation.x())
                .endY(endBikeStation.y())
                .build();
    }

    /**
     * point 주변 SEARCH_RADIUS_METERS 이내의 따릉이 보관소의 상태 리스트 반환
     *
     * @param point
     * @return
     */
    @Override
    public List<BikeStationStatus> searchNearbyBikeStations(Coordinate point) {
        GeoResults<RedisGeoCommands.GeoLocation<String>> geoResults = queryGeoLocations(point, SEARCH_RADIUS, null);
        if (geoResults.getContent().isEmpty() || geoResults.getContent().isEmpty()) {
            return List.of();
        }

        return geoResults.getContent().stream()
                .map(result -> getStationStatus(result.getContent().getName()))
                .flatMap(Optional::stream)
                .collect(Collectors.toList());
    }


    /**
     * point 주변의 가장 가까운 공공자전거 보관함 위치를 return합니다.
     *
     * @param point
     * @return
     */
    @Override
    public BikeStationStatus searchNearestBikeStation(Coordinate point) {

        GeoResults<RedisGeoCommands.GeoLocation<String>> geoResults = queryGeoLocations(point, SEARCH_RADIUS, 1);

        if (geoResults == null || geoResults.getContent().isEmpty()) {
            return null;
        }

        String stationName = geoResults.getContent().get(0).getContent().getName();
        return getStationStatus(stationName).orElse(null);
    }


    /**
     * redis geo를 이용해 point 주변 radius 내 근접검색을 수행합니다.
     *
     * @param point
     * @param radius
     * @param limit
     * @return
     */
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


    /**
     * 해당 공공자전거 보관서의 상태를 불러옵니다.
     *
     * @param stationId
     * @return
     */
    public Optional<BikeStationStatus> getStationStatus(String stationId) {
        String stationData = redisTemplate.opsForValue().get(stationId);

        return Optional.ofNullable(stationData) // stationData가 null인지 체크
                .filter(data -> !data.isEmpty()) // 비어있는 데이터 필터링
                .flatMap(data -> {
                    try {
                        JsonNode jsonNode = objectMapper.readTree(data);

                        String stationName = jsonNode.get("stationName").asText();
                        int parkingBikeTotCnt = jsonNode.get("parkingBikeTotCnt").asInt();
                        double x = jsonNode.get("x").asDouble();
                        double y = jsonNode.get("y").asDouble();

                        return Optional.of(BikeStationStatus.builder()
                                .stationId(stationId)
                                .stationName(stationName)
                                .parkingBikeTotCnt(parkingBikeTotCnt)
                                .x(x)
                                .y(y)
                                .build());
                    } catch (Exception e) {
                        e.printStackTrace();
                        return Optional.empty();
                    }
                });
    }

    /**
     * 두 공공자전거 보관소 사이의 자전거 경로를 구해서 return한다.
     *
     * @param start
     * @param end
     * @return
     */
    public BikeInfo getBikeInfoBetweenStations(BikeStationStatus start, BikeStationStatus end) {
        return getBikeInfo(new Coordinate(start.x(), start.y()), new Coordinate(end.x(), end.y()));
    }

    /**
     * 카카오의 자동차 경로 탐색을 기반으로 자전거 경로를 탐색합니다.
     *
     * @param start
     * @param end
     * @return
     */
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


    /**
     * 카카오의 자동차 길찾기 기반으로 시속 15km로 이동할 때 얼마나 걸리는지 예상 시간을 계산합니다.
     *
     * @param route
     * @return
     */
    public int calculateEstimatedBikeTime(SearchKakaoCarDirectionResponse.RouteResponse route) {
        double averageBikeSpeedMetersPerSecond = 15_000.0 / 3600.0;

        int totalDuration = 0;

        for (SearchKakaoCarDirectionResponse.RouteSection section : route.sections()) {
            for (SearchKakaoCarDirectionResponse.RouteRoad road : section.roads()) {
                int roadDistance = road.distance();
                totalDuration += (int) Math.ceil(roadDistance / averageBikeSpeedMetersPerSecond);
            }
        }

        return totalDuration;
    }

}
