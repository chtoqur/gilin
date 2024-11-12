package com.gilin.route.domain.walk.service;

import com.gilin.route.domain.walk.dto.WalkInfo;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.client.tmap.TMapClient;
import com.gilin.route.global.client.tmap.request.PedestrianPathRequest;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse.Feature;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse.Feature.LineStringGeometry;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse.Feature.PointGeometry;
import com.gilin.route.global.dto.Coordinate;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class WalkServiceImpl implements WalkService {

    final private TMapClient tMapClient;

    @Override
    public WalkInfo getWalkGraphPath(Coordinate start, Coordinate end) {
        List<Coordinate> path = new ArrayList<>();
        Integer totalDistance = 0;
        Integer totalTime = 0;
        PedestrianPathResponse pedestrianPath = tMapClient.getPedestrianPath(
            PedestrianPathRequest.builder()
                                 .startX(start.x())
                                 .startY(start.y())
                                 .endX(end.x())
                                 .endY(end.y())
                                 .speed(60)
                                 .startName("start")
                                 .endName("end")
                                 .build());

        for (Feature feature : pedestrianPath.getFeatures()) {
            if (feature.getProperties()
                       .getDistance() != null) {
                totalDistance += feature.getProperties()
                                        .getDistance();
            }
            if (feature.getProperties()
                       .getTotalTime() != null) {
                totalTime += feature.getProperties()
                                    .getTotalTime();
            }

            if (feature.getGeometry() instanceof LineStringGeometry lineStringGeometry) {
                for (List<Double> coordinate : lineStringGeometry.getCoordinates()) {
                    path.add(new Coordinate(coordinate.get(0), coordinate.get(1)));
                }
            } else if (feature.getGeometry() instanceof PointGeometry pointGeometry) {
                path.add(new Coordinate(pointGeometry.getCoordinates()
                                                     .get(0), pointGeometry.getCoordinates()
                                                                           .get(1)));
            }
        }
        return WalkInfo.builder()
                       .coordinates(path)
                       .distance(totalDistance)
                       .time(totalTime)
                       .build();
    }

    @Override
    public SubPath walkInfoToSubPath() {
        return null;
    }
}
