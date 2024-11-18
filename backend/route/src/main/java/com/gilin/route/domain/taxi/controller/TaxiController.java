package com.gilin.route.domain.taxi.controller;


import com.gilin.route.domain.taxi.dto.TaxiInfo;
import com.gilin.route.domain.taxi.service.TaxiService;
import com.gilin.route.global.dto.Coordinate;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@AllArgsConstructor
@RequestMapping(value = "/taxi", produces = MediaType.APPLICATION_JSON_VALUE)
public class TaxiController {

    private final TaxiService taxiService;

    @GetMapping
    ResponseEntity<TaxiInfo> getTaxiInfo(
        @RequestParam(defaultValue = "127.104880") Double startX,
        @RequestParam(defaultValue = "37.545736") Double startY,
        @RequestParam(defaultValue = "127.039528") Double endX,
        @RequestParam(defaultValue = "37.501363") Double endY
    ) {
        return ResponseEntity.ok(taxiService.getTaxiInfo(new Coordinate(startX, startY),
            new Coordinate(endX, endY)));
    }

}
