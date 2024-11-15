package com.gilin.route.global.client.openApi.dto.response;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MetroPositionResponse {

    private ErrorMessage errorMessage;
    private List<RealtimePosition> realtimePositionList;

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
    public static class RealtimePosition {

        private String beginRow;
        private String endRow;
        private String curPage;
        private String pageRow;
        private int totalCount;
        private int rowNum;
        private int selectedCount;
        private String subwayId;
        private String subwayNm;
        private String statnId;
        private String statnNm;
        private String trainNo;
        private String lastRecptnDt;
        private String recptnDt;
        private String updnLine;
        private String statnTid;
        private String statnTnm;
        private String trainSttus;
        private String directAt;
        private String lstcarAt;
    }
}
