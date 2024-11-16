package com.gilin.route.domain.bus.controller;

import com.gilin.route.domain.bus.dto.BusArrivalResponse;
import com.gilin.route.domain.bus.service.BusService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
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

    @Operation(
            summary = "버스 도착 시간 조회",
            description = "정류소 ID와 노선 ID 리스트를 사용하여 특정 정류소의 버스 도착 정보를 조회합니다. 대한사회복지회",
            parameters = {
                    @Parameter(name = "stationId", description = "정류소 고유 ID", required = true, example = "122000201"),
                    @Parameter(name = "arsId", description = "정류소 ARS ID", required = true, example = "23305"),
                    @Parameter(name = "routeIds", description = "조회할 노선 ID 리스트", required = true, example = "[\"104000014\", \"100100025\", \"104000006\"]")
            },
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "버스 도착 정보가 성공적으로 반환되었습니다.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = BusArrivalResponse.class)
                            )
                    ),
                    @ApiResponse(responseCode = "400", description = "잘못된 요청 파라미터입니다."),
                    @ApiResponse(responseCode = "500", description = "서버 내부 오류입니다.")
            }
    )
    @GetMapping("/arrivalTime")
    public ResponseEntity<List<BusArrivalResponse>> getArrivalTime(
            @RequestParam("stationId") String stationId,
            @RequestParam("arsId") String arsId,
            @RequestParam("routeIds") List<String> routeIds) {
        return ResponseEntity.ok(busService.getArrivalTime(stationId, arsId, routeIds));
    }
}
