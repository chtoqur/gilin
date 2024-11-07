package com.gilin.route.global.client.seoul;

import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.seoul.response.FetchPublicBikeStationResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(url = "http://openapi.seoul.go.kr:8088", name = "SeoulClient")
public interface SeoulClient {

    @GetMapping("/{seoulApiKey}/json/bikeList/{start}/{end}")
    FetchPublicBikeStationResponse fetchPublicBikeStation(
            @PathVariable("seoulApiKey") String seoulApiKey,
            @PathVariable("start") int start,
            @PathVariable("end") int end);
}
