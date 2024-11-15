package com.gilin.route.domain.bus.controller;

import com.gilin.route.domain.bus.dto.BusArrivalResponse;
import com.gilin.route.domain.bus.service.BusService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@Slf4j
@RestController("/bus")
@RequiredArgsConstructor
public class BusController {

    private final BusService busService;

    @GetMapping("/arrivalTime")
    public ResponseEntity<List<BusArrivalResponse>> getArrivalTime(
            @RequestParam("stationId") String stationId,
            @RequestParam("routeIds") List<String> routeIds) {
        return ResponseEntity.ok(busService.getArrivalTime(stationId, routeIds));
    }
}
