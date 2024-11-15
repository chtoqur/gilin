package com.gilin.route.global.client.publicAPI;

import com.gilin.route.global.client.publicAPI.request.SeoulBusArrivalRequest;
import com.gilin.route.global.client.publicAPI.response.seoul.ServiceResult;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(url = "http://ws.bus.go.kr/api/rest/arrive" , name = "BusClient1")
public interface SeoulBusArrivalClient {
    @GetMapping("/getArrInfoByRouteAll")
    ServiceResult getArrInfoByRouteAll(@RequestBody SeoulBusArrivalRequest seoulBusArrivalRequest);
}