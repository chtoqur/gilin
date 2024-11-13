package com.gilin.route.domain.route.service;

import com.gilin.route.domain.bus.service.BusService;
import com.gilin.route.domain.metro.service.MetroService;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.RouteResponse.SubPathh;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.domain.walk.service.WalkService;
import com.gilin.route.global.client.odsay.ODSayClient;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.config.APIKeyConfig;
import com.gilin.route.global.dto.Coordinate;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class RouteService {

    private final ODSayClient odSayClient;
    private final APIKeyConfig apiKeyConfig;
    private final BusService busService;
    private final MetroService metroService;
    private final WalkService walkService;

    public RouteResponse getRoute(Double sx, Double sy, Double ex, Double ey,
        EnumSet<TravelType> travelTypes) {
        if (!travelTypes.contains(TravelType.BUS) && !travelTypes.contains(TravelType.METRO)) {
            //TODO- 걷기, 따릉이, 택시 만 있는 경우 추가
            return null;
        }
        boolean isAll =
            travelTypes.contains(TravelType.BUS) && travelTypes.contains(TravelType.METRO);
        boolean isMetro = travelTypes.contains(TravelType.METRO);
        int searchPathType = isAll ? 0 : (isMetro ? 1 : 2);

        var request = new SearchPubTransPathRequest(apiKeyConfig.getODSayKey(), sx, sy, ex, ey,
            searchPathType);
        SearchPubTransPathResponse response = odSayClient.searchPubTransPathT(request);
        Optional<SearchPubTransPathResponse.Result.Path> path = response.getResult()
                                                                        .getPath()
                                                                        .stream()
                                                                        .findFirst();

        return of(path.orElseThrow(), new Coordinate(sx, sy), new Coordinate(ex, ey));
    }

    private RouteResponse of(SearchPubTransPathResponse.Result.Path response, Coordinate start,
        Coordinate end) {
        RouteResponse.Infoo infoo = RouteResponse.Infoo.of(response.getInfo());
        List<SubPath> subPathList = response.getSubPath();
        List<SubPathh> subPathhList = new ArrayList<>();
        for (int i = 0; i < subPathList.size(); i++) {
            SubPath subPath = subPathList.get(i);
            // 걷기 타입
            if (subPath.getTrafficType() == 3) {
                SubPath prevSubPath = null;
                SubPath nextSubPath = null;
                if (i != 0) {
                    prevSubPath = subPathList.get(i - 1);
                }
                if (i != subPathList.size() - 1) {
                    nextSubPath = subPathList.get(i + 1);
                }
                subPathhList.add(handleSubPath(prevSubPath, nextSubPath, start, end));
            } else {
                subPathhList.add(handleSubPath(subPath));
            }
        }

        return new RouteResponse(infoo, subPathhList);
    }

    private RouteResponse.SubPathh handleSubPath(
        SearchPubTransPathResponse.Result.SubPath subPath) {
        return switch (subPath.getTrafficType()) {
            case 1 -> metroService.convertToSubPathh(subPath);
            case 2 -> busService.convertToSubPathh(subPath);
            default -> new RouteResponse.SubPathh();
        };
    }

    private RouteResponse.SubPathh handleSubPath(
        SearchPubTransPathResponse.Result.SubPath prevSubPath
        , SearchPubTransPathResponse.Result.SubPath nextSubPath,
        Coordinate start,
        Coordinate end
    ) {
        return walkService.convertToSubPathh(prevSubPath, nextSubPath, start, end);
    }

}

