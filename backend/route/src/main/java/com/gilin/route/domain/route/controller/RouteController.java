package com.gilin.route.domain.route.controller;

import com.gilin.route.domain.route.dto.response.RouteResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class RouteController {

    @GetMapping
    public ResponseEntity<RouteResponse> getRoute(
            @RequestParam(defaultValue = "127.1032167") double sx,
            @RequestParam(defaultValue = "37.5441833") double sy,
            @RequestParam(defaultValue = "127.09355") double ex,
            @RequestParam(defaultValue = "37.53615") double ey
    ) {
        return ResponseEntity.ok(new RouteResponse());
    }
}
