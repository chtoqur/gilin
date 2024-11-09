package com.gilin.route.domain.metro.controller;


import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.PollyLineResponseDto;
import com.gilin.route.domain.metro.service.MetroService;
import java.util.List;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
    public List<PollyLineResponseDto> metroLine(Integer startId, Integer endId) {
        return metroService.getMetroPollyLine(startId, endId);
    }

}
