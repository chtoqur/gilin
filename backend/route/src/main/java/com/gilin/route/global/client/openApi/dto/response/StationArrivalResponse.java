package com.gilin.route.global.client.openApi.dto.response;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StationArrivalResponse {

    private ErrorMessage errorMessage;
    private List<RealtimeArrival> realtimeArrivalList;

    @Getter
    @Setter
    public static class ErrorMessage {

        private int status;
        private String code;
        private String message;
        private String link;
        private String developerMessage;
        private int total;
    }

    @Getter
    @Setter
    public static class RealtimeArrival {

        private String subwayId;
        private String subwayNm;
        private String updnLine;
        private String trainLineNm;
        private String subwayHeading;
        private String statnFid;
        private String statnTid;
        private String statnId;
        private String statnNm;
        private String trainCo;
        private String trnsitCo;
        private String ordkey;
        private String subwayList;
        private String statnList;
        private String btrainSttus;
        private String barvlDt;
        private String btrainNo;
        private String bstatnId;
        private String bstatnNm;
        private String recptnDt;
        private String arvlMsg2;
        private String arvlMsg3;
        private String arvlCd;
        private String lstcarAt;
    }
}
