package com.gilin.route.global.client.kakao.response;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

public record SearchKakaoCarDirectionResponse(
        @JsonProperty("trans_id") String transId,
        List<RouteResponse> routes
) {

    public record RouteResponse (
            @JsonProperty("result_code") int resultCode,
            @JsonProperty("result_msg") String resultMsg,
            RouteSummary summary,
            List<RouteSection> sections
    ){}

    public record RouteSummary(
            RouteLocation origin,
            RouteLocation destination,
            List<RouteLocation> waypoints,
            String priority,
            RouteBound bound,
            RouteFare fare,
            int distance,
            int duration
    ) {}

    public record RouteLocation(
            String name,
            double x,
            double y
    ) {}

    public record RouteBound(
            double minX,
            double minY,
            double maxX,
            double maxY
    ) {}

    public record RouteFare(
            int taxi,
            int toll
    ) {}

    public record RouteSection(
            int distance,
            int duration,
            RouteBound bound,
            List<RouteRoad> roads,
            List<RouteGuide> guides
    ) {}

    public record RouteRoad(
            String name,
            int distance,
            int duration,
            int trafficSpeed,
            int trafficState,
            List<Double> vertexes
    ) {}

    public record RouteGuide(
            String name,
            double x,
            double y,
            int distance,
            int duration,
            int type,
            String guidance,
            int roadIndex
    ) {}

}
