package com.gilin.route.global.client.publicAPI.response.seoul;

public record MsgHeader(
    String headerCd,
    String headerMsg,
    int itemCount
) {}