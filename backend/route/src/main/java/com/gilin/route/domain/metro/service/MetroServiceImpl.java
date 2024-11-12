package com.gilin.route.domain.metro.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gilin.route.domain.metro.dto.MetroExitToDest;
import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.PollyLinePos;
import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import com.gilin.route.domain.walk.dto.WalkInfo;
import com.gilin.route.domain.walk.service.WalkService;
import com.gilin.route.global.dto.Coordinate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
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

    @Autowired
    public MetroServiceImpl(RedisTemplate<String, Object> redisTemplate,
        ObjectMapper objectMapper, WalkService walkService) {
        this.redisTemplate = redisTemplate;
        this.listOperations = redisTemplate.opsForList();
        this.hashOperations = redisTemplate.opsForHash();
        this.objectMapper = objectMapper;
        this.walkService = walkService;
    }

    /**
     * @param startId 시작역 코드
     * @param endId   도착역 코드
     * @return PollyLine 을 그리기 위한 좌표 리스트
     */
    @Override
    public PollyLineResponseDto getMetroPollyLine(Integer startId, Integer endId) {
        Integer start = Math.min(startId, endId);
        Integer end = Math.max(startId, endId);
        List<PollyLinePos> retList = new ArrayList<>();
        while (start < end) {
            StringBuilder sb = new StringBuilder();
            sb.append(start)
              .append('_')
              .append(start + 1)
              .append(":graphPos");
            List<Object> posDataList = listOperations.range(sb.toString(), 0, -1);
            List<PollyLinePos> posList = new ArrayList<>();
            for (Object data : posDataList) {
                String string = (String) data;
                String cleaned = string.replaceAll("[()]", "");
                String[] split = cleaned.split(",");
                Double x = Double.parseDouble(split[0].trim());
                Double y = Double.parseDouble(split[1].trim());
                posList.add(PollyLinePos.builder()
                                        .x(x)
                                        .y(y)
                                        .build());
            }
            retList.addAll(posList);
            start++;
        }
        return PollyLineResponseDto.builder()
                                   .pollyLinePosList(retList)
                                   .build();
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
    public MetroExitToDest getClosestExit(Integer startStationId, Coordinate dest) {
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

                WalkInfo walkInfo = walkService.getWalkGraphPath(exitCoordinate, dest);
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
}
