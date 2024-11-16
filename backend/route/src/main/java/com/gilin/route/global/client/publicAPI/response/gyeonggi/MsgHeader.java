package com.gilin.route.global.client.publicAPI.response.gyeonggi;

public record MsgHeader(
    String queryTime,
    String resultCode,
    String resultMessage
) {}