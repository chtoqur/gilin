package com.gilin.route.global.client.publicAPI.response.seoul;

public record ItemList(
        String arrmsg1,         // 첫번째 도착예정 버스의 도착정보 메시지
        String arrmsg2,         // 두번째 도착예정 버스의 도착정보 메시지
        String arsId,           // 정류소 번호
        int avgCf1,             // 첫번째 도착예정 버스의 이동평균 보정계수
        int avgCf2,             // 두번째 도착예정 버스의 이동평균 보정계수
        int brdrde_Num1,        // 첫번째 도착예정 버스의 내부 제공용 현재 뒷차 인원
        int brdrde_Num2,        // 두번째 도착예정 버스의 내부 제공용 현재 뒷차 인원
        int brerde_Div1,        // 첫번째 도착예정 버스의 내부 제공용 현재 뒷차 구분
        int brerde_Div2,        // 두번째 도착예정 버스의 내부 제공용 현재 뒷차 구분
        String busRouteAbrv,    // 노선 약칭
        String busRouteId,      // 노선 ID
        int busType1,           // 첫번째 도착예정 버스의 차량유형
        int busType2,           // 두번째 도착예정 버스의 차량유형
        String deTourAt,        // 우회 여부
        String dir,             // 방향
        int expCf1,             // 첫번째 도착예정 버스의 지수평활 보정계수
        int expCf2,             // 두번째 도착예정 버스의 지수평활 보정계수
        int exps1,              // 첫번째 도착예정 버스의 지수평활 도착예정시간(초)
        int exps2,              // 두번째 도착예정 버스의 지수평활 도착예정시간(초)
        String firstTm,         // 첫차 시간
        int full1,              // 첫번째 도착예정 버스의 만차 여부
        int full2,              // 두번째 도착예정 버스의 만차 여부
        int goal1,              // 첫번째 도착예정 버스의 종점 도착예정시간(초)
        int goal2,              // 두번째 도착예정 버스의 종점 도착예정시간(초)
        int isArrive1,          // 첫번째 도착예정 버스의 최종 정류소 도착출발 여부
        int isArrive2,          // 두번째 도착예정 버스의 최종 정류소 도착출발 여부
        int isLast1,            // 첫번째 도착예정 버스의 막차 여부
        int isLast2,            // 두번째 도착예정 버스의 막차 여부
        int kalCf1,             // 첫번째 도착예정 버스의 기타1평균 보정계수
        int kalCf2,             // 두번째 도착예정 버스의 기타1평균 보정계수
        int kals1,              // 첫번째 도착예정 버스의 기타1 도착예정시간(초)
        int kals2,              // 두번째 도착예정 버스의 기타1 도착예정시간(초)
        String lastTm,          // 막차 시간
        String mkTm,            // 제공 시각
        int namin2Sec1,         // 첫번째 도착예정 버스의 2번째 주요정류소 예정여행시간
        int namin2Sec2,         // 두번째 도착예정 버스의 2번째 주요정류소 예정여행시간
        int neuCf1,             // 첫번째 도착예정 버스의 기타2평균 보정계수
        int neuCf2,             // 두번째 도착예정 버스의 기타2평균 보정계수
        int neus1,              // 첫번째 도착예정 버스의 기타2 도착예정시간(초)
        int neus2,              // 두번째 도착예정 버스의 기타2 도착예정시간(초)
        String nextBus,         // 막차운행여부
        int nmain2Ord1,         // 첫번째 도착예정 버스의 2번째 주요정류소 순번
        int nmain2Ord2,         // 두번째 도착예정 버스의 2번째 주요정류소 순번
        int nmain3Ord1,         // 첫번째 도착예정 버스의 3번째 주요정류소 순번
        int nmain3Ord2,         // 두번째 도착예정 버스의 3번째 주요정류소 순번
        int nmainOrd1,          // 첫번째 도착예정 버스의 1번째 주요정류소 순번
        int nmainOrd2,          // 두번째 도착예정 버스의 1번째 주요정류소 순번
        String nstnId1,         // 첫번째 도착예정 버스의 다음정류소 ID
        String nstnId2,         // 두번째 도착예정 버스의 다음정류소 ID
        int nstnOrd1,           // 첫번째 도착예정 버스의 다음정류소 순번
        int nstnOrd2,           // 두번째 도착예정 버스의 다음정류소 순번
        String plainNo1,        // 첫번째 도착예정차량번호
        String plainNo2,        // 두번째 도착예정차량번호
        int reride_Num1,        // 첫번째 도착예정 버스의 재차 인원
        int reride_Num2,        // 두번째 도착예정 버스의 재차 인원
        int routeType,          // 노선 유형
        String rtNm,            // 노선명
        int sectOrd1,           // 첫번째 도착예정 버스의 현재구간 순번
        int sectOrd2,           // 두번째 도착예정 버스의 현재구간 순번
        String stId,            // 정류소 고유 ID
        String stNm,            // 정류소명
        int term,               // 배차 간격(분)
        int traSpd1,            // 첫번째 도착예정 버스의 여행속도 (Km/h)
        int traSpd2,            // 두번째 도착예정 버스의 여행속도 (Km/h)
        int traTime1,           // 첫번째 도착예정 버스의 여행시간(분)
        int traTime2,           // 두번째 도착예정 버스의 여행시간(분)
        String vehId1,          // 첫번째 도착예정버스ID
        String vehId2           // 두번째 도착예정버스ID
) {}