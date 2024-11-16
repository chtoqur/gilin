package com.gilin.route.domain.metro.controller;


import com.gilin.route.domain.metro.dto.MetroLinkDto;
import com.gilin.route.domain.metro.dto.MetroPositionDto;
import com.gilin.route.domain.metro.dto.StationArrivalDto;
import com.gilin.route.domain.metro.service.MetroService;
import com.gilin.route.global.dto.Coordinate;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
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

    @Operation(
        summary = "지하철 경로 조회",
        description = "지하철 노선 ID로 시작점과 끝점 사이의 경로 정보를 반환합니다.",
        responses = {
            @ApiResponse(responseCode = "200", description = "경로 정보 조회 성공", content = @Content(schema = @Schema(implementation = MetroLinkDto.class))),
            @ApiResponse(responseCode = "400", description = "잘못된 요청 파라미터")
        }
    )
    @GetMapping("/link")
    public MetroLinkDto metro(
        @Parameter(description = "출발 지하철 ID", required = true) @RequestParam Integer startId,
        @Parameter(description = "도착 지하철 ID", required = true) @RequestParam Integer endId
    ) {
        return metroService.getMetroLink(startId, endId);
    }

    @Operation(
        summary = "지하철 폴리라인 정보 조회",
        description = "지하철 노선의 시작점과 끝점 사이의 경로를 폴리라인(Coordinate) 형태로 반환합니다.",
        responses = {
            @ApiResponse(responseCode = "200", description = "폴리라인 정보 조회 성공", content = @Content(schema = @Schema(implementation = Coordinate.class))),
            @ApiResponse(responseCode = "400", description = "잘못된 요청 파라미터")
        }
    )
    @GetMapping("/link/line")
    public List<Coordinate> metroLine(
        @Parameter(description = "출발 지하철 ID", required = true) @RequestParam Integer startId,
        @Parameter(description = "도착 지하철 ID", required = true) @RequestParam Integer endId
    ) {
        return metroService.getMetroPollyLine(startId, endId);
    }

    @Operation(
        summary = "역 도착 정보 조회",
        description = "현재 역과 다음 역의 정보를 바탕으로 도착 정보를 반환합니다.",
        responses = {
            @ApiResponse(responseCode = "200", description = "역 도착 정보 조회 성공", content = @Content(schema = @Schema(implementation = StationArrivalDto.class))),
            @ApiResponse(responseCode = "400", description = "잘못된 요청 파라미터")
        }
    )
    @GetMapping("/station/arrival")
    public List<StationArrivalDto> metroStationArrival(
        @Parameter(description = "현재 역 이름", example = "역삼") @RequestParam(defaultValue = "역삼") String stationName,
        @Parameter(description = "다음 역 이름", example = "강남") @RequestParam(defaultValue = "강남") String nextStationName
    ) {
        return metroService.getStationArrival(stationName, nextStationName);
    }

    @Operation(
        summary = "지하철 위치 정보 조회",
        description = "열차 번호와 노선 이름으로 현재 지하철 위치 정보를 반환합니다.",
        responses = {
            @ApiResponse(responseCode = "200", description = "지하철 위치 정보 조회 성공", content = @Content(schema = @Schema(implementation = MetroPositionDto.class))),
            @ApiResponse(responseCode = "400", description = "잘못된 요청 파라미터")
        }
    )
    @GetMapping("/pos")
    public MetroPositionDto metroPosition(
        @Parameter(description = "열차 번호", example = "0479", required = true) @RequestParam(defaultValue = "0479") String trainNo,
        @Parameter(description = "지하철 노선 이름", example = "1호선", required = true) @RequestParam(defaultValue = "1호선") String lineName
    ) {
        return metroService.getMetroPosition(trainNo, lineName);
    }
}

