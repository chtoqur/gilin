package com.gilin.route.domain.taxi.service;

import com.gilin.route.domain.taxi.dto.TaxiInfo;
import com.gilin.route.global.dto.Coordinate;

public interface TaxiService {
    TaxiInfo getTaxiInfo(Coordinate start, Coordinate end);
}
