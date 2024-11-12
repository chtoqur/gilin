package com.gilin.route.domain.route.service;

import com.gilin.route.domain.bus.service.BusService;
import com.gilin.route.domain.metro.service.MetroService;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.global.client.odsay.ODSayClient;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.config.APIKeyConfig;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.EnumSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class RouteService {

    private final ODSayClient odSayClient;
    private final APIKeyConfig apiKeyConfig;
    private final BusService busService;
    private final MetroService metroService;

    public RouteResponse getRoute(Double sx, Double sy, Double ex, Double ey, EnumSet<TravelType> travelTypes) {
        if (!travelTypes.contains(TravelType.BUS) && !travelTypes.contains(TravelType.METRO)) {
            //TODO- 걷기, 따릉이, 택시 만 있는 경우 추가
            return null;
        }
        var request = new SearchPubTransPathRequest(apiKeyConfig.getODSayKey(), sx, sy, ex, ey);
        SearchPubTransPathResponse response = odSayClient.searchPubTransPathT(request);
        Optional<SearchPubTransPathResponse.Result.Path> path = Optional.empty();
        if (travelTypes.contains(TravelType.BUS) && travelTypes.contains(TravelType.METRO)) {
            path = response.getResult().getPath().stream().findFirst();
        } else if (travelTypes.contains(TravelType.METRO)) {
            path = response.getResult().getPath().stream()
                    .filter(path1 -> path1.getPathType() == 1)
                    .findFirst();
        } else if (travelTypes.contains(TravelType.BUS)) {
            path = response.getResult().getPath().stream()
                    .filter(path1 -> path1.getPathType() == 2)
                    .findFirst();
        }

        return path.map(this::of).orElse(null);
    }

    private RouteResponse of(SearchPubTransPathResponse.Result.Path response) {
        RouteResponse.Infoo infoo = RouteResponse.Infoo.of(response.getInfo());
        List<RouteResponse.SubPathh> subPathhs = response.getSubPath().stream()
                .map(this::handleSubPath)
                .toList();
        //TODO- 중간중간 걷기 추가

        return new RouteResponse(infoo, subPathhs);
    }

    private RouteResponse.SubPathh handleSubPath(SearchPubTransPathResponse.Result.SubPath subPath) {
        return switch (subPath.getTrafficType()){
            case 1 -> new RouteResponse.SubPathh(); //TODO- metroService 종호형 수정 예쩡
            case 2 -> busService.convertToSubPathh(subPath);
            default -> new RouteResponse.SubPathh();
        };
    }

}
