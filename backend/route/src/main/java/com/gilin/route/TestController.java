package com.gilin.route;

import com.gilin.route.global.client.odsay.ODSayClient;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.seoul.SeoulClient;
import com.gilin.route.global.client.seoul.response.FetchPublicBikeStationResponse;
import com.gilin.route.global.config.APIKeyConfig;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController("/test")
@RequiredArgsConstructor
public class TestController {

    private final ODSayClient odSayClient;
    private final SeoulClient seoulClient;
    private final APIKeyConfig apiKeyConfig;

    @GetMapping("/odsay/path")
    @Operation(description = "오디세이 호출입니다. https://lab.odsay.com/guide/releaseReference#searchPubTransPathT")
    public ResponseEntity<SearchPubTransPathResponse> odsayPath(
            @RequestParam(defaultValue = "126.963760") double sx,
            @RequestParam(defaultValue = "37.477111") double sy,
            @RequestParam(defaultValue = "127.039528") double ex,
            @RequestParam(defaultValue = "37.501363") double ey

    ) {
        return ResponseEntity.ok(odSayClient.searchPubTransPathT(
                SearchPubTransPathRequest.builder()
                        .apiKey(apiKeyConfig.getODSayKey())
                        .SX(sx)
                        .SY(sy)
                        .EX(ex)
                        .EY(ey)
                        .build()));
    }

    @GetMapping("/seoul/bikeStations")
    @Operation(description = "서울시 공공자전거 보관소 현황 호출입니다.")
    public ResponseEntity<FetchPublicBikeStationResponse> seoulBikeStations(
            @RequestParam(defaultValue = "1") int start,
            @RequestParam(defaultValue = "10") int end
    ) {
        return ResponseEntity.ok(seoulClient.fetchPublicBikeStation(
                apiKeyConfig.getSeoulKey(), start, end
        ));
    }
}
