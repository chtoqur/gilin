package com.gilin.route.global.client.kakao.request;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class SearchKakaoCarDirectionRequest {
    private String origin;
    private String destination;
    private String waypoints;
    private String priority;
    private String avoid;
    private Integer roadevent;
    private Boolean alternatives;
    private Boolean roadDetails;
    private Integer carType;
    private String carFuel;
    private Boolean carHipass;
    private Boolean summary;
}
