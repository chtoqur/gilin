package com.gilin.route;

import com.gilin.route.domain.bus.dto.Coordinate;
import com.gilin.route.domain.bus.service.BusService;
import com.gilin.route.global.client.odsay.ODSayClient;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.request.SubwayStationInfoRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.odsay.response.SubwayStationInfoResponse;
import com.gilin.route.global.config.APIKeyConfig;
import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
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
    private final APIKeyConfig apiKeyConfig;
    private final BusService busService;

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

    @GetMapping("/odsay/station")
    @Operation(description = "오디세이 호출입니다. https://lab.odsay.com/guide/releaseReference#subwayStationInfo")
    public ResponseEntity<SubwayStationInfoResponse> odsaySubwayStationInfo(
        @RequestParam(defaultValue = "130") Integer stationID
    ) {
        return ResponseEntity.ok(odSayClient.subwayStationInfo(
            SubwayStationInfoRequest.builder()
                                    .apiKey(apiKeyConfig.getODSayKey())
                                    .lang(0)
                                    .output("json")
                                    .stationID(stationID)
                                    .build()
        ));
    }

    @GetMapping("/bus/subPath")
    @Operation(description = "서브 패스 잘 가져오나 확인하기 -> 광나루역에서 강변역 2000-1 번 버스")
    public ResponseEntity<List<Coordinate>> subPath(
        @RequestParam(defaultValue = "240000007") Long routeId,
        @RequestParam(defaultValue = "127.1032167") double sx,
        @RequestParam(defaultValue = "37.5441833") double sy,
        @RequestParam(defaultValue = "127.09355") double ex,
        @RequestParam(defaultValue = "37.53615") double ey
    ) {
        Coordinate startStation = new Coordinate(sx, sy);
        Coordinate endStation = new Coordinate(ex, ey);
        return ResponseEntity.ok(busService.getPathGraph(routeId, startStation, endStation));
    }
}
