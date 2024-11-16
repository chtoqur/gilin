package com.gilin.route.global.client.publicAPI;

import com.gilin.route.global.client.publicAPI.request.SeoulBusArrivalRequest;
import com.gilin.route.global.client.publicAPI.request.SeoulBusStationArrivalRequest;
import com.gilin.route.global.client.publicAPI.response.seoul.LowArrInfoItemList;
import com.gilin.route.global.client.publicAPI.response.seoul.ServiceResult;
import com.gilin.route.global.client.publicAPI.response.seoul.StationItemList;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(url = "http://ws.bus.go.kr/api/rest" , name = "SeoulBusArrivalClient")
public interface SeoulBusArrivalClient {
    @GetMapping("/arrive/getLowArrInfoByStId")
    ServiceResult<LowArrInfoItemList> getArrInfoByRouteAll(@SpringQueryMap SeoulBusArrivalRequest seoulBusArrivalRequest);

    @GetMapping("/stationinfo/getStationByUid")
    ServiceResult<StationItemList> getStationByUid(@SpringQueryMap SeoulBusStationArrivalRequest seoulBusStationArrivalRequest);
}