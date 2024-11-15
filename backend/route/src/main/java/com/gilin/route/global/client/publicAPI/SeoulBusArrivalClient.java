package com.gilin.route.global.client.publicAPI;

import com.gilin.route.global.client.publicAPI.request.SeoulBusArrivalRequest;
import com.gilin.route.global.client.publicAPI.response.seoul.ServiceResult;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(url = "http://ws.bus.go.kr/api/rest/arrive" , name = "BusClient1")
public interface SeoulBusArrivalClient {
    @GetMapping("/getLowArrInfoByStId")
    ServiceResult getArrInfoByRouteAll(@SpringQueryMap SeoulBusArrivalRequest seoulBusArrivalRequest);
}