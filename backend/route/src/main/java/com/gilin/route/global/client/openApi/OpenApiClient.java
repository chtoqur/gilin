package com.gilin.route.global.client.openApi;

import com.gilin.route.global.client.openApi.dto.response.MetroPositionResponse;
import com.gilin.route.global.client.openApi.dto.response.StationArrivalResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(url = "http://swopenAPI.seoul.go.kr/api", name = "OpenAPIClient")
public interface OpenApiClient {

    @GetMapping("/subway/70474d506374653034375243467448/json/realtimePosition/0/100/{line}")
    MetroPositionResponse getRealTimePosition(
        @PathVariable("line") String line
    );

    @GetMapping("/subway/70474d506374653034375243467448/json/realtimeStationArrival/0/100/{stationName}")
    StationArrivalResponse getRealTimeStationArrival(
        @PathVariable("stationName") String stationName
    );
}
