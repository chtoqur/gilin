package com.gilin.route.domain.metro.service;

import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.PollyLinePos;
import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class MetroServiceImpl implements MetroService {


    private final RedisTemplate<String, Object> redisTemplate;
    private final ListOperations<String, Object> listOperations;
    private final HashOperations<String, String, String> hashOperations;

    @Autowired
    public MetroServiceImpl(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.listOperations = redisTemplate.opsForList();
        this.hashOperations = redisTemplate.opsForHash();
    }

    /**
     * @param startId 시작역 코드
     * @param endId   도착역 코드
     * @return PollyLine 을 그리기 위한 좌표 리스트
     */
    @Override
    public PollyLineResponseDto getMetroPollyLine(Integer startId, Integer endId) {
        StringBuilder sb = new StringBuilder();
        sb.append(startId)
          .append('_')
          .append(endId)
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
        return PollyLineResponseDto.builder()
                                   .pollyLinePosList(posList)
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
}
