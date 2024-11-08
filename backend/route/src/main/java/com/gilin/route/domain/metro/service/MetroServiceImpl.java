package com.gilin.route.domain.metro.service;

import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class MetroServiceImpl implements MetroService{


    private final RedisTemplate<String, Object>  redisTemplate;
    private final ListOperations<String, Object> listOperations;
    private final HashOperations<String, String, String> hashOperations;

    @Autowired
    public MetroServiceImpl(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.listOperations = redisTemplate.opsForList();
        this.hashOperations = redisTemplate.opsForHash();
    }

    @Override
    public List<PollyLineResponseDto> getMetroPollyLine(Integer startId, Integer endId) {
        StringBuilder sb = new StringBuilder();
        sb.append(startId).append('_').append(endId);
//        return listOperations.range(sb.toString(), 0, -1);
        System.out.println(listOperations.range(sb.toString(), 0, -1));
        return List.of();
    }

    @Override
    public MetroLinkDto getMetroLink(Integer startId, Integer endId) {
        StringBuilder sb = new StringBuilder();
        String key = sb.append(startId).append('_').append(endId).toString();
        Map<String, String> entries = hashOperations.entries(key);
        return  MetroLinkDto.builder()
                            .startId(Integer.valueOf(entries.get("startId")))
                            .startName(entries.get("startName"))
                            .startX(Double.valueOf(entries.get("startX")))
                            .startY(Double.valueOf(entries.get("startY")))
                            .endId(Integer.valueOf(entries.get("endId")))
                            .endName(entries.get("endName"))
                            .endX(Double.valueOf(entries.get("endX")))
                            .endY(Double.valueOf(entries.get("endY")))
                            .build();
    }
}
