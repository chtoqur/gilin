package com.gilin.route.global.client.publicAPI.response.seoul;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;

import java.util.List;

public record MsgBody<T> (
    @JacksonXmlElementWrapper(localName = "itemList", useWrapping = false)
    List<T> itemList
) {}