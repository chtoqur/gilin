package com.gilin.route.global.client.publicAPI.response.seoul;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

public record ServiceResult(
    @JacksonXmlProperty(localName = "msgHeader")
    MsgHeader msgHeader,
    @JacksonXmlProperty(localName = "msgBody")
    MsgBody msgBody
) {}