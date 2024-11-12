package com.gilin.route.global.client.odsay.request;


import lombok.Builder;
import lombok.Getter;

@Getter
public class SearchPubTransPathRequest {
    private String apiKey;
    private double SX;
    private double SY;
    private double EX;
    private double EY;
    private final int lang = 0;               // 국문
    private final String output = "json";
    private final int OPT = 0;                // 0 추천 경로, 1 타입별 정렬
    private final Integer SearchType = 0;     // 0 도시내, 1 도시간
    private int SearchPathType = 0;     // 0 모두, 1 지하철, 2 버스

    @Builder
    public SearchPubTransPathRequest(String apiKey, double SX, double SY, double EX, double EY, int searchPathType) {
        this.apiKey = apiKey;
        this.SX = SX;
        this.SY = SY;
        this.EX = EX;
        this.EY = EY;
        this.SearchPathType = searchPathType;
    }
}
