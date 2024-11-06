package com.gilin.route.domain.route.client.odsay.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@NoArgsConstructor
@ToString
public class SearchPubTransPathResponse {
    private Result result;

    @Getter
    @NoArgsConstructor
    public static class Result {
        private int searchType;
        private int outTrafficCheck;
        private int busCount;
        private int subwayCount;
        private int subwayBusCount;
        private double pointDistance;
        private int startRadius;
        private int endRadius;
        private List<Path> path;

        @Getter
        @NoArgsConstructor
        public static class Path {
            private int pathType;
            private Info info;
            private List<SubPath> subPath;
        }

        @Getter
        @NoArgsConstructor
        public static class Info {
            private double trafficDistance;
            private int totalWalk;
            private int totalTime;
            private int payment;
            private int busTransitCount;
            private int subwayTransitCount;
            private String mapObj;
            private String firstStartStation;
            private String firstStartStationKor;
            private String firstStartStationJpnKata;
            private String lastEndStation;
            private String lastEndStationKor;
            private String lastEndStationJpnKata;
            private int totalStationCount;
            private int busStationCount;
            private int subwayStationCount;
            private double totalDistance;
            private int checkIntervalTime;
            private String checkIntervalTimeOverYn;
            private int totalIntervalTime;
        }

        @Getter
        @NoArgsConstructor
        public static class SubPath {
            private int trafficType;
            private double distance;
            private int sectionTime;
            private Integer stationCount;
            private List<Lane> lane;
            private int intervalTime;
            private String startName;
            private String startNameKor;
            private String startNameJpnKata;
            private double startX;
            private double startY;
            private String endName;
            private String endNameKor;
            private String endNameJpnKata;
            private double endX;
            private double endY;
            private String way;
            private Integer wayCode;
            private String door;
            private int startID;
            private Integer startStationCityCode;
            private Integer startStationProviderCode;
            private String startLocalStationID;
            private String startArsID;
            private int endID;
            private Integer endStationCityCode;
            private Integer endStationProviderCode;
            private String endLocalStationID;
            private String endArsID;
            private String startExitNo;
            private Double startExitX;
            private Double startExitY;
            private String endExitNo;
            private Double endExitX;
            private Double endExitY;
            private PassStopList passStopList;
        }

        @Getter
        @NoArgsConstructor
        public static class Lane {
            private String name;
            private String nameKor;
            private String nameJpnKata;
            private String busNo;
            private String busNoKor;
            private String busNoJpnKata;
            private Integer type;
            private Integer busID;
            private String busLocalBlID;
            private Integer busCityCode;
            private Integer busProviderCode;
            private Integer subwayCode;
            private Integer subwayCityCode;
        }

        @Getter
        @NoArgsConstructor
        public static class PassStopList {
            private List<Station> stations;
        }

        @Getter
        @NoArgsConstructor
        public static class Station {
            private int index;
            private int stationID;
            private String stationName;
            private String stationNameKor;
            private String stationNameJpnKata;
            private Integer stationCityCode;
            private Integer stationProviderCode;
            private String localStationID;
            private String arsID;
            private String x;
            private String y;
            private String isNonStop;
        }
    }

}
