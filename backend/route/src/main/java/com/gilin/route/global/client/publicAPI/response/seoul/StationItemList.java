package com.gilin.route.global.client.publicAPI.response.seoul;

public record StationItemList(
        String adirection,         // 방향
        String arrmsg1,            // 첫번째 도착예정 버스의 도착정보 메시지
        String arrmsg2,            // 두번째 도착예정 버스의 도착정보 메시지
        String arrmsgSec1,         // 첫번째 도착예정 버스의 도착정보 메시지 (추가 정보)
        String arrmsgSec2,         // 두번째 도착예정 버스의 도착정보 메시지 (추가 정보)
        String arsId,              // 정류소 고유 번호
        String busRouteAbrv,       // 노선 약칭
        String busRouteId,         // 노선 ID
        int busType1,              // 첫번째 도착예정 버스의 차량유형
        int busType2,              // 두번째 도착예정 버스의 차량유형
        String deTourAt,           // 우회 여부
        String firstTm,            // 첫차 시간
        double gpsX,               // 정류소 X 좌표
        double gpsY,               // 정류소 Y 좌표
        int isArrive1,             // 첫번째 도착예정 버스의 최종 정류소 도착출발 여부
        int isArrive2,             // 두번째 도착예정 버스의 최종 정류소 도착출발 여부
        int isFullFlag1,           // 첫번째 도착예정 버스의 만차 여부
        int isFullFlag2,           // 두번째 도착예정 버스의 만차 여부
        int isLast1,               // 첫번째 도착예정 버스의 막차 여부
        int isLast2,               // 두번째 도착예정 버스의 막차 여부
        String lastTm,             // 막차 시간
        String nextBus,            // 막차운행 여부
        String nxtStn,             // 다음 정류장
        double posX,               // 정류소 좌표 X
        double posY,               // 정류소 좌표 Y
        String repTm1,             // 첫번째 도착예정 버스의 최종 보고 시간
        String repTm2,             // 두번째 도착예정 버스의 최종 보고 시간
        int rerdieDiv1,            // 첫번째 도착예정 버스의 재차 구분
        int rerdieDiv2,            // 두번째 도착예정 버스의 재차 구분
        int rerideNum1,            // 첫번째 도착예정 버스의 재차 인원
        int rerideNum2,            // 두번째 도착예정 버스의 재차 인원
        int routeType,             // 노선 유형
        String rtNm,               // 노선명
        String sectNm,             // 구간명
        int sectOrd1,              // 첫번째 도착예정 버스의 현재 구간 순번
        int sectOrd2,              // 두번째 도착예정 버스의 현재 구간 순번
        String stId,               // 정류소 ID
        String stNm,               // 정류소명
        int staOrd,                // 요청 정류소 순번
        String stationNm1,         // 첫번째 도착예정 버스의 최종 정류소명
        String stationNm2,         // 두번째 도착예정 버스의 최종 정류소명
        int stationTp,             // 정류소 타입
        int term,                  // 배차 간격 (분)
        int traSpd1,               // 첫번째 도착예정 버스의 여행 속도
        int traSpd2,               // 두번째 도착예정 버스의 여행 속도
        int traTime1,              // 첫번째 도착예정 버스의 여행 시간
        int traTime2,              // 두번째 도착예정 버스의 여행 시간
        String vehId1,             // 첫번째 도착예정 버스 ID
        String vehId2              // 두번째 도착예정 버스 ID
) {
}
