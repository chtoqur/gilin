package com.gilin.route.domain.metro.service;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.metro.dto.MetroExitToDest;
import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.MetroPositionDto;
import com.gilin.route.domain.metro.dto.StationArrivalDto;
import com.gilin.route.domain.route.dto.response.RouteResponse.SubPathh;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.dto.Coordinate;
import java.util.List;

public interface MetroService {

    List<Coordinate> getMetroPollyLine(Integer startId, Integer endId);

    MetroLinkDto getMetroLink(Integer startId, Integer endId);

    MetroExitToDest getClosestExit(Integer startStationId, Coordinate dest, Member member);

    SubPathh convertToSubPathh(SubPath subPath);

    List<StationArrivalDto> getStationArrival(String stationName, String nextStationName);

    MetroPositionDto getMetroPosition(String trainNo, String lineName);
}
