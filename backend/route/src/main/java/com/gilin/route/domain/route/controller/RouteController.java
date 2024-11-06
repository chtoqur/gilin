package com.gilin.route.domain.route.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class RouteController {

    @GetMapping
    public ResponseEntity<String> getRoute() {
        return ResponseEntity.ok("hi");
    }
}
