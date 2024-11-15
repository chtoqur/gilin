package com.gilin.route.global.client.publicAPI.response;

public record MsgHeader(
    String queryTime,
    String resultCode,
    String resultMessage
) {}