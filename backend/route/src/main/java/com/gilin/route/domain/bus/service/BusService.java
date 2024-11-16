package com.gilin.route.domain.bus.service;

import com.gilin.route.domain.bus.dto.BusArrivalResponse;
import com.gilin.route.global.dto.Coordinate;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;

import java.util.List;

public interface BusService {

    RouteResponse.SubPathh convertToSubPathh(SearchPubTransPathResponse.Result.SubPath subPath);

    List<Coordinate> getPathGraph(Long routeId, Coordinate startStation, Coordinate endStation);

    List<BusArrivalResponse> getArrivalTime(String stationId, String arsId, List<String> routeId);
}
