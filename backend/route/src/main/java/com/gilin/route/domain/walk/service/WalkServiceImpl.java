package com.gilin.route.domain.walk.service;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.route.dto.response.RouteResponse.SubPathh;
import com.gilin.route.domain.route.dto.response.TravelType;
import com.gilin.route.domain.walk.dto.WalkInfo;
import com.gilin.route.domain.walk.dto.request.WalkHistoryRequestDto;
import com.gilin.route.domain.walk.dto.response.WalkHistoryResponseDto;
import com.gilin.route.domain.walk.entity.WalkHistory;
import com.gilin.route.domain.walk.repository.WalkHistoryRepository;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.client.tmap.TMapClient;
import com.gilin.route.global.client.tmap.request.PedestrianPathRequest;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse.Feature;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse.Feature.LineStringGeometry;
import com.gilin.route.global.client.tmap.response.PedestrianPathResponse.Feature.PointGeometry;
import com.gilin.route.global.dto.Coordinate;
import jakarta.transaction.Transactional;
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
    final private WalkHistoryRepository walkHistoryRepository;

    @Override
    public WalkInfo getWalkGraphPath(Coordinate start, Coordinate end, Member member) {
        List<Coordinate> path = new ArrayList<>();
        Integer totalDistance = 0;
        Integer totalTime = 0;
        WalkHistoryResponseDto walkHistory = getWalkHistory(member);
        Double mps = walkHistory.average();
        PedestrianPathResponse pedestrianPath = tMapClient.getPedestrianPath(
            PedestrianPathRequest.builder()
                                 .startX(start.x())
                                 .startY(start.y())
                                 .endX(end.x())
                                 .endY(end.y())
                                 .speed((int) (mps * 3.6))
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
                path.add(new Coordinate(
                    pointGeometry.getCoordinates()
                                 .get(0),
                    pointGeometry.getCoordinates()
                                 .get(1)
                ));
            }
        }
        return WalkInfo.builder()
                       .coordinates(path)
                       .distance(totalDistance)
                       .time((int) (totalDistance / mps) / 60 + 1) // 분으로 변환
                       .build();
    }


    @Override
    public SubPathh convertToSubPathh(SubPath prevSubPath, SubPath nextSubPath, Coordinate start,
        Coordinate end, Member member) {
        Coordinate walkStart, walkEnd;

        if (prevSubPath == null) {
            walkStart = start;
        } else {
            walkStart = new Coordinate(prevSubPath.getEndX(), prevSubPath.getEndY());
        }

        if (nextSubPath == null) {
            walkEnd = end;
        } else {
            walkEnd = new Coordinate(nextSubPath.getStartX(), nextSubPath.getStartY());
        }
        WalkInfo info = getWalkGraphPath(walkStart, walkEnd, member);
        // 환승타입일 경우(앞 뒤가 모두 지하철)
        if (prevSubPath != null && nextSubPath != null
            && prevSubPath.getTrafficType() == 1 && nextSubPath.getTrafficType() == 1
        ) {
            return SubPathh.builder()
                           .distance(info.distance())
                           .sectionTime(info.time())
                           .pathGraph(new ArrayList<>())
                           .travelType(TravelType.TRANSFER)
                           .startX(walkStart.x())
                           .startY(walkStart.y())
                           .endX(walkEnd.x())
                           .endY(walkEnd.y())
                           .build();
        }
        return SubPathh.builder()
                       .distance(info.distance())
                       .sectionTime(info.time())
                       .pathGraph(info.coordinates())
                       .travelType(TravelType.WALK)
                       .startX(walkStart.x())
                       .startY(walkStart.y())
                       .endX(walkEnd.x())
                       .endY(walkEnd.y())
                       .build();
    }

    @Override
    @Transactional
    public void saveWalkHistory(WalkHistoryRequestDto request, Member member) {
        if (member == null) {
            return;
        }
        if (request.time() == 0 || request.distance() == 0) {
            throw new IllegalArgumentException("시간, 거리는 0이 될 수 없습니다.");
        }
        WalkHistory walkHistory = new WalkHistory(request.distance(), request.time(), member);
        walkHistoryRepository.save(walkHistory);
    }

    @Override
    public WalkHistoryResponseDto getWalkHistory(Member member) {
        if (member == null) {
            return WalkHistoryResponseDto.builder()
                                         .average(1.1d)
                                         .max(1.1d)
                                         .build();
        }
        List<WalkHistory> histories = walkHistoryRepository.findAllByMember(member);
        // 기록이 없을 경우 기본 속도 4m/s
        if (histories.isEmpty()) {
            return WalkHistoryResponseDto.builder()
                                         .average(1.1d)
                                         .max(1.1d)
                                         .build();
        }
        double max = 0d;
        double time = 0d;
        double distance = 0d;
        double curTime;
        double curDistance;
        for (WalkHistory history : histories) {
            curDistance = history.getDistance();
            curTime = history.getTime();
            double speed = curDistance / curTime;
            if (speed > max) {
                max = speed;
            }
            distance += curDistance;
            time += curTime;
        }

        return WalkHistoryResponseDto.builder()
                                     .max(max)
                                     .average(distance / time)
                                     .build();
    }
}
