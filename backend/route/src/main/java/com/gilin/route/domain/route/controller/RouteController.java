package com.gilin.route.domain.route.controller;

import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.domain.route.service.RouteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.EnumSet;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
public class RouteController {

    private final RouteService routeService;

    @GetMapping
    public ResponseEntity<RouteResponse> getRoute(
            @RequestParam(defaultValue = "127.1032167") double sx,
            @RequestParam(defaultValue = "37.5441833") double sy,
            @RequestParam(defaultValue = "127.09355") double ex,
            @RequestParam(defaultValue = "37.53615") double ey,
            @RequestParam(defaultValue = "METRO,BUS,TAXI,BICYCLE,WALK") List<String> travelTypes
            ) {
        try {
            EnumSet<TravelType> travelTypeSet = travelTypes.stream()
                    .map(TravelType::valueOf)
                    .collect(Collectors.toCollection(() -> EnumSet.noneOf(TravelType.class)));

            return ResponseEntity.ok(routeService.getRoute(sx, sy, ex, ey, travelTypeSet));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }
}