package com.gilin.route.global.client.publicAPI;

import com.gilin.route.global.client.publicAPI.request.GyeonggiBusArrivalRequest;
import com.gilin.route.global.client.publicAPI.response.gyeonggi.GyeonggiBusArrivalResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(url = "http://apis.data.go.kr/6410000/busarrivalservice" , name = "BusClient2")
public interface GyeonggiBusArrivalClient {
    @GetMapping("/getBusArrivalList")
    GyeonggiBusArrivalResponse getBusArrivalList(@SpringQueryMap GyeonggiBusArrivalRequest gyeonggiBusArrivalRequest);
}