package com.gilin.route.domain.route.controller;

import com.gilin.route.domain.member.dto.Authenticated;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.route.dto.response.RouteResponse;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.domain.route.service.RouteService;
import java.time.LocalDateTime;
import java.util.EnumSet;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(produces = MediaType.APPLICATION_JSON_VALUE)
public class RouteController {

    private final RouteService routeService;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<RouteResponse> getRoute(
        @RequestParam(defaultValue = "127.1032167") double sx,
        @RequestParam(defaultValue = "37.5441833") double sy,
        @RequestParam(defaultValue = "127.09355") double ex,
        @RequestParam(defaultValue = "37.53615") double ey,
        @RequestParam(defaultValue = "METRO,BUS,TAXI,BICYCLE,WALK") List<String> travelTypes,
        @RequestParam(required = false) LocalDateTime arrivalTime,
        @Authenticated Member member
    ) {
        EnumSet<TravelType> travelTypeSet = EnumSet.allOf(TravelType.class);
        try {
            travelTypeSet = travelTypes.stream()
                                       .map(TravelType::valueOf)
                                       .collect(Collectors.toCollection(
                                           () -> EnumSet.noneOf(TravelType.class)));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                                 .body(null);
        }
        return ResponseEntity.ok(routeService.getRoute(sx, sy, ex, ey, travelTypeSet, member));
    }
}