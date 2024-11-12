package com.gilin.route.domain.route.dto.response;

import com.gilin.route.global.dto.Coordinate;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.List;

@Getter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class RouteResponse {

    private Infoo info;
    private List<SubPathh> subPath;

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Infoo {

        @Schema(description = "도보를 제외한 총 이동 거리", example = "10075")
        private double trafficDistance;
        @Schema(description = "총 도보 이동 거리", example = "654")
        private int totalWalk;
        @Schema(description = "총 소요시간", example = "32")
        private int totalTime;
        @Schema(description = "총 요금", example = "1550")
        private int payment;
        @Schema(description = "버스 환승 카운트", example = "1")
        private int busTransitCount;
        @Schema(description = "지하철 환승 카운트", example = "1")
        private int subwayTransitCount;
        @Schema(description = "최초 출발역/정류장", example = "광나루역.극동아파트")
        private String firstStartStation;
        @Schema(description = "최종 도착역/정류장", example = "역삼")
        private String lastEndStation;
        @Schema(description = "총 정류장 합", example = "10")
        private int totalStationCount;
        @Schema(description = "버스 정류장 합", example = "3")
        private int busStationCount;
        @Schema(description = "지하철 정류장 합", example = "7")
        private int subwayStationCount;
        @Schema(description = "총 거리", example = "10729")
        private double totalDistance;
        @Schema(description = "전체 배차간격 시간(분)", example = "13")
        private int totalIntervalTime;

        static public Infoo of(SearchPubTransPathResponse.Result.Info info) {
            return new Infoo(info.getTrafficDistance(), info.getTotalWalk(), info.getTotalTime(), info.getPayment(),
                    info.getBusTransitCount(), info.getSubwayTransitCount(), info.getFirstStartStation(),
                    info.getLastEndStation(), info.getTotalStationCount(), info.getBusStationCount(),
                    info.getSubwayStationCount(), info.getTotalDistance(), info.getTotalIntervalTime());
        }
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SubPathh {

        @Schema(description = "이동 수단 종류 (도보, 버스, 지하철)")
        private TravelType travelType;
        @Schema(description = "경로 그래프")
        private List<Coordinate> pathGraph;
        @Schema(description = "이동 거리", example = "1375")
        private double distance;
        @Schema(description = "이동 소요 시간", example = "9")
        private int sectionTime;
        @Schema(description = "이동하여 정차하는 정거장 수", example = "3")
        private Integer stationCount;
        @Schema(description = "교통 수단 정보")
        private List<Lanee> lane;
        @Schema(description = "평균 배차간격(분)", example = "8")
        private int intervalTime;
        @Schema(description = "승차 정류장/역명", example = "광나루역.극동아파트")
        private String startName;
        @Schema(description = "승차 정류장/역 X 좌표", example = "127.103257")
        private double startX;
        @Schema(description = "승차 정류장/역 Y 좌표", example = "37.544185")
        private double startY;
        @Schema(description = "하차 정류장/역명", example = "강변역B")
        private String endName;
        @Schema(description = "하차 정류장/역 X 좌표", example = "127.093713")
        private double endX;
        @Schema(description = "하차 정류장/역 Y 좌표", example = "37.536111")
        private double endY;
        @Schema(description = "방면 정보", example = "역삼")
        private String way;
        @Schema(description = "방면 정보 코드", example = "2")
        private Integer wayCode;
        @Schema(description = "지하철 빠른 환승 위치", example = "null")
        private String door;
        @Schema(description = "출발 정류장/역 코드", example = "109018")
        private int startID;
        @Schema(description = "출발 정류장 ID", example = "104000076")
        private String startLocalStationID;
        @Schema(description = "출발 정류장 고유번호", example = "05169")
        private String startArsID;
        @Schema(description = "도착 정류장/역 코드", example = "108819")
        private int endID;
        @Schema(description = "도착 정류장 ID", example = "104000280")
        private String endLocalStationID;
        @Schema(description = "도착 정류장 고유번호", example = "74096")
        private String endArsID;
        @Schema(description = "지하철 들어가는 출구 번호", example = "1")
        private String startExitNo;
        @Schema(description = "지하철 들어가는 출구 X 좌표", example = "127.0948042173518")
        private Double startExitX;
        @Schema(description = "지하철 들어가는 출구 Y 좌표", example = "37.53527302648372")
        private Double startExitY;
        @Schema(description = "지하철 나가는 출구 번호", example = "8")
        private String endExitNo;
        @Schema(description = "지하철 나가는 출구 X 좌표", example = "127.03723438525931")
        private Double endExitX;
        @Schema(description = "지하철 나가는 출구 Y 좌표", example = "37.50112209922957")
        private Double endExitY;
        private PassStopListt passStopList;

        public static SubPathh of(SearchPubTransPathResponse.Result.SubPath s,
            List<Coordinate> pathGraph) {
            return new SubPathh(
                TravelType.fromTrafficType(s.getTrafficType()),
                pathGraph, s.getDistance(), s.getSectionTime(), s.getStationCount(),
                s.getLane()
                 .stream()
                 .map(Lanee::of)
                 .toList(),
                s.getIntervalTime(), s.getStartName(), s.getStartX(), s.getStartY(),
                s.getEndName(), s.getEndX(), s.getEndY(), s.getWay(),
                s.getWayCode(), s.getDoor(), s.getStartID(), s.getStartLocalStationID(),
                s.getStartArsID(), s.getEndID(), s.getEndLocalStationID(), s.getEndArsID(),
                s.getStartExitNo(), s.getStartExitX(), s.getStartExitY(), s.getEndExitNo(),
                s.getEndExitX(), s.getEndExitY(),
                new PassStopListt(s.getPassStopList()
                                   .getStations()
                                   .stream()
                                   .map(Stationn::of)
                                   .toList())
            );
        }
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Lanee {

        @Schema(description = "지하철 노선명")
        private String name;
        @Schema(description = "버스 번호", example = "95")
        private String busNo;
        @Schema(description = "버스 타입", example = "1")
        private Integer type;
        @Schema(description = "버스 코드", example = "8507")
        private Integer busID;
        @Schema(description = "지역 버스노선 ID", example = "222000052")
        private String busLocalBlID;
        @Schema(description = "지하철 노선 번호", example = "2")
        private Integer subwayCode;

        public static Lanee of(SearchPubTransPathResponse.Result.Lane lane) {
            return new Lanee(lane.getName(), lane.getBusNo(), lane.getType(), lane.getBusID(),
                lane.getBusLocalBlID(), lane.getSubwayCode());
        }
    }

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PassStopListt {

        private List<Stationn> stations;
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Stationn {

        @Schema(description = "정류장 순번", example = "0")
        private int index;
        @Schema(description = "정류장 ID", example = "109018")
        private int stationID;
        @Schema(description = "정류장 명칭", example = "광나루역.극동아파트")
        private String stationName;
        @Schema(description = "지역 정류장 ID", example = "104000076")
        private String localStationID;
        @Schema(description = "정류장 고유번호", example = "05169")
        private String arsID;
        @Schema(description = "정류장 X좌표", example = "127.103257")
        private String x;
        @Schema(description = "정류장 Y좌표", example = "37.544185")
        private String y;
        @Schema(description = "미정차 정류장 여부", example = "N")
        private String isNonStop;

        public static Stationn of(SearchPubTransPathResponse.Result.Station station) {
            return new Stationn(station.getIndex(), station.getStationID(),
                station.getStationName(),
                station.getLocalStationID(), station.getArsID(), station.getX(), station.getY(),
                station.getIsNonStop());
        }
    }
}
