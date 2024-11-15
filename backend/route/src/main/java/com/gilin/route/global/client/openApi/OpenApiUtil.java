package com.gilin.route.global.client.openApi;


import jakarta.annotation.PostConstruct;
import java.util.HashMap;
import org.springframework.stereotype.Component;

@Component
public class OpenApiUtil {

    private final HashMap<String, String> stationNameMap = new HashMap<>();
    private final HashMap<Integer, String> metroLineMap = new HashMap<>();

    @PostConstruct
    public void init() {
        stationNameInit();
        metroLaneInit();
    }

    public String convert(String stationName) {
        String name = stationNameMap.get(stationName);
        if (name == null) {
            return stationName;
        }
        return name;
    }

    public String convert(Integer line) {
        return metroLineMap.get(line);
    }


    private void stationNameInit() {
        stationNameMap.put("쌍용", "쌍용(나사렛대)");
        stationNameMap.put("총신대입구", "총신대입구(이수)");
        stationNameMap.put("신정", "신정(은행정)");
        stationNameMap.put("오목교", "오목교(목동운동장앞)");
        stationNameMap.put("군자", "군자(능동)");
        stationNameMap.put("아차산", "아차산(어린이대공원후문)");
        stationNameMap.put("광나루", "광나루(장신대)");
        stationNameMap.put("천호", "천호(풍납토성)");
        stationNameMap.put("굽은다리", "굽은다리(강동구민회관앞)");
        stationNameMap.put("올림픽공원", "올림픽공원(한국체대)");
        stationNameMap.put("응암순환", "응암순환(상선)");
        stationNameMap.put("새절", "새절(신사)");
        stationNameMap.put("증산", "증산(명지대앞)");
        stationNameMap.put("월드컵경기장", "월드컵경기장(성산)");
        stationNameMap.put("대흥", "대흥(서강대앞)");
        stationNameMap.put("안암", "안암(고대병원앞)");
        stationNameMap.put("월곡", "월곡(동덕여대)");
        stationNameMap.put("상월곡", "상월곡(한국과학기술연구원)");
        stationNameMap.put("화랑대", "화랑대(서울여대입구)");
        stationNameMap.put("공릉", "공릉(서울산업대입구)");
        stationNameMap.put("어린이대공원", "어린이대공원(세종대)");
        stationNameMap.put("숭실대입구", "숭실대입구(살피재)");
        stationNameMap.put("상도", "상도(중앙대앞)");
        stationNameMap.put("몽촌토성", "몽촌토성(평화의문)");
        stationNameMap.put("남한산성입구", "남한산성입구(성남법원,검찰청)");
        stationNameMap.put("신촌", "신촌(경의중앙선)");
    }

    private void metroLaneInit() {
        metroLineMap.put(1001, "1호선");
        metroLineMap.put(1002, "2호선");
        metroLineMap.put(1003, "3호선");
        metroLineMap.put(1004, "4호선");
        metroLineMap.put(1005, "5호선");
        metroLineMap.put(1006, "6호선");
        metroLineMap.put(1007, "7호선");
        metroLineMap.put(1008, "8호선");
        metroLineMap.put(1009, "9호선");
        metroLineMap.put(1061, "중앙선");
        metroLineMap.put(1063, "경의중앙선");
        metroLineMap.put(1065, "공항철도");
        metroLineMap.put(1067, "경춘선");
        metroLineMap.put(1075, "수의분당선");
        metroLineMap.put(1077, "신분당선");
        metroLineMap.put(1092, "우이신설선");
        metroLineMap.put(1093, "서해선");
        metroLineMap.put(1081, "경강선");
        metroLineMap.put(1032, "GTX-A");
    }
}
