package com.gilin.route.global.client.odsay;

import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.request.SubwayStationInfoRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.odsay.response.SubwayStationInfoResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(url = "https://api.odsay.com/v1/api", name = "ODSayClient")
public interface ODSayClient {

    @GetMapping("/searchPubTransPathT")
    SearchPubTransPathResponse searchPubTransPathT(
        @SpringQueryMap SearchPubTransPathRequest searchPubTransPathRequest);

    @GetMapping("/subwayStationInfo")
    SubwayStationInfoResponse subwayStationInfo(
        @SpringQueryMap SubwayStationInfoRequest subwayStationInfoRequest);
}
