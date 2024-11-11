package com.gilin.route;

import com.gilin.route.global.client.kakao.KakaoClient;
import com.gilin.route.global.client.kakao.request.SearchKakaoCarDirectionRequest;
import com.gilin.route.global.client.kakao.response.SearchKakaoCarDirectionResponse;
import com.gilin.route.global.client.odsay.ODSayClient;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.seoul.SeoulClient;
import com.gilin.route.global.client.seoul.response.FetchPublicBikeStationResponse;
import com.gilin.route.global.config.APIKeyConfig;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.persistence.criteria.CriteriaBuilder.In;
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
    private final SeoulClient seoulClient;
    private final APIKeyConfig apiKeyConfig;
    private final BusService busService;
    private final TMapClient tMapClient;
    private final KakaoClient kakaoClient;

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

    @GetMapping("/pedestrian/path")
    @Operation(description = "T Map 호출입니다. ")
    public ResponseEntity<PedestrianPathResponse> pedestrianPath(
        @RequestParam(defaultValue = "126.92365493654832") double sx,
        @RequestParam(defaultValue = "37.556770374096615") double sy,
        @RequestParam(defaultValue = "126.92432158129688") double ex,
        @RequestParam(defaultValue = "37.55279861528311") double ey,
        @RequestParam(defaultValue = "10001") Integer endPoiId,
        @RequestParam(defaultValue = "60") Integer speed,
        @RequestParam(defaultValue = "출발지") String startName,
        @RequestParam(defaultValue = "도착지") String endName

    ) {
        return ResponseEntity.ok(tMapClient.getPedestrianPath(PedestrianPathRequest.builder()
                                                                                   .startX(sx)
                                                                                   .startY(sy)
                                                                                   .speed(speed)
                                                                                   .endPoiId(
                                                                                       endPoiId)
                                                                                   .endX(ex)
                                                                                   .endY(ey)
                                                                                   .startName(
                                                                                       startName)
                                                                                   .endName(endName)
                                                                                   .searchOption(0)
                                                                                   .build(),
            apiKeyConfig.getTMapKey()));
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

    @GetMapping("/kakao/carDirections")
    @Operation(description = "카카오모빌리티 자동차 길찾기 호출입니다.")
    public ResponseEntity<SearchKakaoCarDirectionResponse> kakaoCarDirections(
            @RequestParam(defaultValue = "126.963760") double sx,
            @RequestParam(defaultValue = "37.477111") double sy,
            @RequestParam(defaultValue = "127.039528") double ex,
            @RequestParam(defaultValue = "37.501363") double ey
    ) {
        SearchKakaoCarDirectionRequest req =
                SearchKakaoCarDirectionRequest.builder()
                        .origin(sx+","+sy)
                        .destination(ex+","+ey)
                        .build();
        return ResponseEntity.ok(kakaoClient.searchKakaoCarDirection(
                req, "KakaoAK "+apiKeyConfig.getKakaoKey()
        ));
    }

}
