package com.gilin.route.global.client.publicAPI.response.gyeonggi;

public record BusArrivalList(
    String flag,
    int locationNo1,
    Integer locationNo2,
    int lowPlate1,
    int lowPlate2,
    String plateNo1,
    String plateNo2,
    int predictTime1,
    Integer predictTime2,
    int remainSeatCnt1,
    int remainSeatCnt2,
    String routeId,
    int staOrder,
    String stationId
) {}