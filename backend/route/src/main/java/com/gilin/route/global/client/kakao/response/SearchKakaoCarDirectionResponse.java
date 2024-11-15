package com.gilin.route.global.client.kakao.response;

import java.util.ArrayList;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.gilin.route.global.dto.Coordinate;

public record SearchKakaoCarDirectionResponse(
        @JsonProperty("trans_id") String transId,
        List<RouteResponse> routes
) {

    public record RouteResponse (
            @JsonProperty("result_code") int resultCode,
            @JsonProperty("result_msg") String resultMsg,
            RouteSummary summary,
            List<RouteSection> sections
    ){

        public List<Coordinate> toCoordinates() {
            List<Coordinate> allCoordinates = new ArrayList<>();
            for (RouteSection section : sections) {
                allCoordinates.addAll(section.toCoordinates());
            }
            return allCoordinates;
        }
    }

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
    ) {
        public List<Coordinate> toCoordinates() {
            List<Coordinate> coordinates = new ArrayList<>();
            for (RouteRoad road : roads) {
                List<Double> vertexes = road.vertexes();
                for (int i = 0; i < vertexes.size(); i += 2) {
                    coordinates.add(new Coordinate(vertexes.get(i), vertexes.get(i + 1)));
                }
            }
            return coordinates;
        }
    }

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
