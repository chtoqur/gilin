package com.gilin.route.domain.metro.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.metro.dto.MetroExitToDest;
import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.MetroPositionDto;
import com.gilin.route.domain.metro.dto.StationArrivalDto;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.RouteResponse.SubPathh;
import com.gilin.route.domain.walk.dto.WalkInfo;
import com.gilin.route.domain.walk.service.WalkService;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.client.openApi.OpenApiClient;
import com.gilin.route.global.client.openApi.TopsisAPIUtil;
import com.gilin.route.global.client.openApi.dto.response.MetroPositionResponse;
import com.gilin.route.global.client.openApi.dto.response.MetroPositionResponse.RealtimePosition;
import com.gilin.route.global.client.openApi.dto.response.StationArrivalResponse;
import com.gilin.route.global.client.openApi.dto.response.StationArrivalResponse.RealtimeArrival;
import com.gilin.route.global.dto.Coordinate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class MetroServiceImpl implements MetroService {


    private final RedisTemplate<String, Object> redisTemplate;
    private final ListOperations<String, Object> listOperations;
    private final HashOperations<String, String, String> hashOperations;
    private final ObjectMapper objectMapper;
    private final WalkService walkService;
    private final OpenApiClient openApiClient;
    private final TopsisAPIUtil topsisAPIUtil;

    @Autowired
    public MetroServiceImpl(RedisTemplate<String, Object> redisTemplate,
        ObjectMapper objectMapper, WalkService walkService, OpenApiClient openApiClient,
        TopsisAPIUtil topsisAPIUtil) {
        this.redisTemplate = redisTemplate;
        this.listOperations = redisTemplate.opsForList();
        this.hashOperations = redisTemplate.opsForHash();
        this.objectMapper = objectMapper;
        this.walkService = walkService;
        this.openApiClient = openApiClient;
        this.topsisAPIUtil = topsisAPIUtil;
    }

    /**
     * @param startId 시작역 코드
     * @param endId   도착역 코드
     * @return PollyLine 을 그리기 위한 좌표 리스트
     */
    @Override
    public List<Coordinate> getMetroPollyLine(Integer startId, Integer endId) {
        Integer start = Math.min(startId, endId);
        Integer end = Math.max(startId, endId);
        List<Coordinate> retList = new ArrayList<>();
        while (start < end) {
            StringBuilder sb = new StringBuilder();
            sb.append(start)
              .append('_')
              .append(start + 1)
              .append(":graphPos");
            List<Object> posDataList = listOperations.range(sb.toString(), 0, -1);
            List<Coordinate> posList = new ArrayList<>();
            for (Object data : posDataList) {
                String string = (String) data;
                String cleaned = string.replaceAll("[()]", "");
                String[] split = cleaned.split(",");
                Double x = Double.parseDouble(split[0].trim());
                Double y = Double.parseDouble(split[1].trim());
                posList.add(new Coordinate(x, y));
            }
            retList.addAll(posList);
            start++;
        }
        // 역방향일 경우 뒤집어서 전달
        if (startId > endId) {
            Collections.reverse(retList);
        }
        return retList;
    }

    /**
     * @param startId 시작역 코드
     * @param endId   도착역 코드
     * @return 지하철 연결 정보 (역 이름, 코드, 위경도)
     */
    @Override
    public MetroLinkDto getMetroLink(Integer startId, Integer endId) {
        StringBuilder sb = new StringBuilder();
        String key = sb.append(startId)
                       .append('_')
                       .append(endId)
                       .toString();
        Map<String, String> entries = hashOperations.entries(key);
        return MetroLinkDto.builder()
                           .startId(Integer.valueOf(entries.get("startId")))
                           .startName(entries.get("\uFEFFstartName"))
                           .startX(Double.valueOf(entries.get("startX")))
                           .startY(Double.valueOf(entries.get("startY")))
                           .endId(Integer.valueOf(entries.get("endId")))
                           .endName(entries.get("endName"))
                           .endX(Double.valueOf(entries.get("endX")))
                           .endY(Double.valueOf(entries.get("endY")))
                           .build();
    }

    @Override
    public MetroExitToDest getClosestExit(Integer startStationId, Coordinate dest, Member member) {
        MetroExitToDest closestExit = null;
        double minDistance = Double.MAX_VALUE;

        for (int i = 1; i <= 20; i++) {
            String key = "exit" + startStationId + ":" + i;
            String jsonValue = (String) redisTemplate.opsForValue()
                                                     .get(key);
            if (jsonValue == null) {
                break;
            }

            try {
                Coordinate exitCoordinate = objectMapper.readValue(jsonValue, Coordinate.class);

                WalkInfo walkInfo = walkService.getWalkGraphPath(exitCoordinate, dest, member);
                if (walkInfo.distance() < minDistance) {
                    minDistance = walkInfo.distance();
                    closestExit = MetroExitToDest.builder()
                                                 .exitNum(i)
                                                 .distance(walkInfo.distance())
                                                 .time(walkInfo.time())
                                                 .build();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return closestExit;
    }

    @Override
    public SubPathh convertToSubPathh(SubPath subPath) {
        if (subPath.getTrafficType() != 1) {
            return null;
        }
        Integer startId = subPath.getStartID();
        Integer endId = subPath.getEndID();
        return RouteResponse.SubPathh.of(subPath, getMetroPollyLine(startId, endId));
    }

    @Override
    public List<StationArrivalDto> getStationArrival(String stationName, String nextStationName) {
        stationName = topsisAPIUtil.convertStationName(stationName);
        nextStationName = topsisAPIUtil.convertStationName(nextStationName);
        List<StationArrivalDto> retList = new ArrayList<>();
        StationArrivalResponse response = openApiClient.getRealTimeStationArrival(stationName);
        if (response.getRealtimeArrivalList() == null) {
            return retList;
        }
        for (RealtimeArrival realtimeArrival : response.getRealtimeArrivalList()) {
            if (realtimeArrival.getTrainLineNm()
                               .contains(nextStationName)) {
                int time = Integer.parseInt(realtimeArrival.getBarvlDt());
                // 일부 역은 도착 예정 시간을 제공하지 않아 0으로 반환함
                if (time == 0) {
                    // 전역, [2] 전역, [4] 전역 형식을 로되어있기 때문에
                    int number = 1;
                    // 숫자 부분을 추출하는 정규식
                    Pattern pattern = Pattern.compile("\\d+");
                    Matcher matcher = pattern.matcher(realtimeArrival.getArvlMsg2());
                    // 숫자가 해당 숫자만큼 전에 있는것, 없다면 바로 전역
                    if (matcher.find()) {
                        number = Integer.parseInt(matcher.group());
                    }
                    // 한 역당 2분으로 계산
                    time += 120 * number;
                }
                retList.add(StationArrivalDto.builder()
                                             .stationName(realtimeArrival.getStatnNm())
                                             .line(topsisAPIUtil.convertLineName(
                                                 realtimeArrival.getSubwayId()))
                                             .trainNo(realtimeArrival.getBtrainNo())
                                             .trainLineNm(realtimeArrival.getTrainLineNm())
                                             .time(time)
                                             .build());
                if (retList.size() >= 2) {
                    break;
                }
            }
        }

        return retList;
    }

    @Override
    public MetroPositionDto getMetroPosition(String trainNo, String lineName) {
        MetroPositionResponse response = openApiClient.getRealTimePosition(lineName);
        for (RealtimePosition position : response.getRealtimePositionList()) {
            if (position.getTrainNo()
                        .equals(trainNo)) {
                return MetroPositionDto.builder()
                                       .line(lineName)
                                       .stationName(position.getStatnNm())
                                       .trainNo(position.getTrainNo())
                                       .trainLineNm(position.getSubwayNm())
                                       .status(MetroPositionDto.stat(position.getTrainSttus()))
                                       .build();
            }
        }

        return null;
    }
}
