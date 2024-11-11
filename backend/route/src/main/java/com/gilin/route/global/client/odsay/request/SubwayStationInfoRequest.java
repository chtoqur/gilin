package com.gilin.route.global.client.odsay.request;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SubwayStationInfoRequest {

    private String apiKey;
    private String output;
    private Integer lang;
    private Integer stationID;
}
