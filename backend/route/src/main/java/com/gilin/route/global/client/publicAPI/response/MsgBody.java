package com.gilin.route.global.client.publicAPI.response;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

import java.util.List;

public record MsgBody(
    @JacksonXmlElementWrapper(useWrapping = false)
    @JacksonXmlProperty(localName = "busArrivalList")
    List<BusArrivalList> busArrivalList
) {}
