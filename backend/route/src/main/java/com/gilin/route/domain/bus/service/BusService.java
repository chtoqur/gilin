package com.gilin.route.domain.bus.service;

import com.gilin.route.domain.bus.dto.Coordinate;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;

import java.util.List;

public interface BusService {
    RouteResponse.SubPathh convertToSubPathh(SearchPubTransPathResponse.Result.SubPath subPath);
}
