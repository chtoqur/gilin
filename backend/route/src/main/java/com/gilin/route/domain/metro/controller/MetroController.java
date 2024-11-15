package com.gilin.route.domain.metro.controller;


import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.MetroPositionDto;
import com.gilin.route.domain.metro.dto.StationArrivalDto;
import com.gilin.route.domain.metro.service.MetroService;
import com.gilin.route.global.dto.Coordinate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/metro")
@RequiredArgsConstructor
public class MetroController {

    private final MetroService metroService;

    @GetMapping("/link")
    public MetroLinkDto metro(Integer startId, Integer endId) {
        return metroService.getMetroLink(startId, endId);
    }

    @GetMapping("/link/line")
    public List<Coordinate> metroLine(Integer startId, Integer endId) {
        return metroService.getMetroPollyLine(startId, endId);
    }

    @GetMapping("/station/arrival")
    public List<StationArrivalDto> metroStationArrival(
        @RequestParam(defaultValue = "역삼") String stationName,
        @RequestParam(defaultValue = "강남") String nextStationName
    ) {
        return metroService.getStationArrival(stationName, nextStationName);
    }

    @GetMapping("/pos")
    public MetroPositionDto metroPosition(
        @RequestParam(defaultValue = "0479") String trainNo,
        @RequestParam(defaultValue = "1호선") String lineName
    ) {
        return metroService.getMetroPosition(trainNo, lineName);
    }
}
