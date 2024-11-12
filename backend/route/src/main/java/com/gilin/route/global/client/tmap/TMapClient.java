package com.gilin.route.global.client.tmap;

import com.gilin.route.global.client.tmap.request.PedestrianPathRequest;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(url = "https://apis.openapi.sk.com/tmap", name = "TMapClient")
public interface TMapClient {

    @PostMapping("/routes/pedestrian?version=1")
    PedestrianPathResponse getPedestrianPath(
        @SpringQueryMap PedestrianPathRequest request,
        @RequestHeader("appKey") String appKey
    );


}
