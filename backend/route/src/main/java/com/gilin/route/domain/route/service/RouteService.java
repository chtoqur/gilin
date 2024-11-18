package com.gilin.route.domain.route.service;

import com.gilin.route.domain.bike.service.BikeService;
import com.gilin.route.domain.bus.service.BusService;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.metro.service.MetroService;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.RouteResponse.SubPathh;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.domain.taxi.service.TaxiService;
import com.gilin.route.domain.walk.service.WalkService;
import com.gilin.route.global.client.odsay.ODSayClient;
import com.gilin.route.global.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.config.APIKeyConfig;
import com.gilin.route.global.dto.Coordinate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class RouteService {

    private final ODSayClient odSayClient;
    private final APIKeyConfig apiKeyConfig;
    private final BusService busService;
    private final MetroService metroService;
    private final WalkService walkService;
    private final TaxiService taxiService;
    private final BikeService bikeService;

    /**
     * 전체 추천 경로 도출
     *
     * @param sx
     * @param sy
     * @param ex
     * @param ey
     * @param travelTypes
     * @return
     */
    public RouteResponse getRoute(Double sx, Double sy, Double ex, Double ey,
                                  EnumSet<TravelType> travelTypes, Member member) {
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

        return of(path.orElseThrow(), new Coordinate(sx, sy), new Coordinate(ex, ey), travelTypes.contains(TravelType.BICYCLE), member);
    }

    /**
     * ODSay API의 결과를 기준으로 도보 경로 추가하여 산출
     *
     * @param response
     * @param start
     * @param end
     * @return
     */
    private RouteResponse of(SearchPubTransPathResponse.Result.Path response, Coordinate start,
                             Coordinate end, boolean useBicycles, Member member) {
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
                subPathhList.addAll(handleSubPath(prevSubPath, nextSubPath, start, end, useBicycles, member));
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

    private List<RouteResponse.SubPathh> handleSubPath(
            SearchPubTransPathResponse.Result.SubPath prevSubPath
            , SearchPubTransPathResponse.Result.SubPath nextSubPath,
            Coordinate start,
            Coordinate end,
            boolean useBike,
            Member member
    ) {
        log.debug(">>> handleSubPath");
        List<RouteResponse.SubPathh> walkSubPathhList = new ArrayList<>();
        List<RouteResponse.SubPathh> subPathhList = new ArrayList<>();
        RouteResponse.SubPathh walkSubPathh = walkService.convertToSubPathh(prevSubPath, nextSubPath, start, end, member);
        walkSubPathhList.add(walkSubPathh);
        if (!useBike || (prevSubPath != null && nextSubPath != null)) {
            return walkSubPathhList;
        }

        log.debug(start.x() + " " + start.y() + " " + end.x() + " " + end.y());
        RouteResponse.SubPathh bikeSubPathh = bikeService.getBikeSubPathh(start, end);
        log.debug(">>> bikeSubPathh {}", bikeSubPathh);
        if (bikeSubPathh == null) {
            return walkSubPathhList;
        }
        subPathhList.add(walkService.convertToSubPathh(prevSubPath, null, start, new Coordinate(bikeSubPathh.getStartX(), bikeSubPathh.getStartY()), member));
        subPathhList.add(bikeSubPathh);
        subPathhList.add(walkService.convertToSubPathh(null, nextSubPath, new Coordinate(bikeSubPathh.getEndX(), bikeSubPathh.getEndY()), end, member));
        int bikeSubPathhTime = 0;
        for (RouteResponse.SubPathh subPathh : subPathhList) {
            bikeSubPathhTime += subPathh.getSectionTime();
        }
        log.debug(">>> BIKECHECK: " + bikeSubPathhTime + " " + walkSubPathh.getSectionTime());
        return (bikeSubPathhTime + 5 < walkSubPathh.getSectionTime()) ? subPathhList : walkSubPathhList;
    }

}

