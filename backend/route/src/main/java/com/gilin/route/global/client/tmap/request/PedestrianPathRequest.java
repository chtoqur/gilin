package com.gilin.route.global.client.tmap.request;

import lombok.Builder;
import lombok.Getter;

@Getter
public class PedestrianPathRequest {

    private Double startX;
    private Double startY;
    private Double endX;
    private Double endY;
    private Integer speed;
    private Integer endPoiId;
    private String startName;
    private String endName;
    private Integer searchOption;

    @Builder
    public PedestrianPathRequest(Double startX, Double startY, Double endX, Double endY,
        String startName, String endName, Integer searchOption, Integer speed, Integer endPoiId) {
        this.startX = startX;
        this.startY = startY;
        this.endX = endX;
        this.endY = endY;
        this.speed = speed;
        this.endPoiId = endPoiId;
        this.startName = startName;
        this.endName = endName;
        this.searchOption = searchOption;
    }


}
