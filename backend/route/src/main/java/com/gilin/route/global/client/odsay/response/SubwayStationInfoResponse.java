package com.gilin.route.global.client.odsay.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@NoArgsConstructor
@ToString
public class SubwayStationInfoResponse {

    private Result result;

    @Getter
    @NoArgsConstructor
    public static class Result {

        private String stationName;
        private int stationID;
        private int type;
        private String laneName;
        private String laneCity;

        @JsonProperty("CityCode")
        private int cityCode;

        private double x;
        private double y;
        private ExObj exOBJ;
        private PrevObj prevOBJ;
        private NextObj nextOBJ;
        private DefaultInfo defaultInfo;
        private UseInfo useInfo;
        private ExitInfo exitInfo;

        @Getter
        @NoArgsConstructor
        public static class ExObj {

            private List<Station> station;
        }

        @Getter
        @NoArgsConstructor
        public static class PrevObj {

            private List<Station> station;
        }

        @Getter
        @NoArgsConstructor
        public static class NextObj {

            private List<Station> station;
        }

        @Getter
        @NoArgsConstructor
        public static class DefaultInfo {

            private String address;

            @JsonProperty("new_address")
            private String newAddress;

            private String tel;

            @JsonProperty("lostcenterTel")
            private String lostcenterTel;
        }

        @Getter
        @NoArgsConstructor
        public static class UseInfo {

            private int platform;
            private int meetingPlace;
            private int restroom;
            private int offDoor;
            private int crossOver;
            private int publicPlace;
            private int handicapCount;
            private int parkingCount;
            private int bicycleCount;
            private int civilCount;
            private int wheelchairLift;
            private int elevator;
        }

        @Getter
        @NoArgsConstructor
        public static class ExitInfo {

            private List<Gate> gate;

            @Getter
            @NoArgsConstructor
            public static class Gate {

                private String gateNo;
                private List<String> gateLink;
                private List<BusStop> busstop;

                @Getter
                @NoArgsConstructor
                public static class BusStop {

                    private String stopID;
                    private List<Bus> bus;
                    private String stopName;

                    @Getter
                    @NoArgsConstructor
                    public static class Bus {

                        private String busNo;
                        private String type;
                        private String blID;
                        private String busCityName;
                    }
                }
            }
        }

        @Getter
        @NoArgsConstructor
        public static class Station {

            private String stationName;
            private int stationID;
            private int type;
            private String laneName;
            private String laneCity;
        }
    }
}
