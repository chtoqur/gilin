package com.gilin.route.domain.walk.service;

import com.gilin.route.global.dto.Coordinate;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import java.util.List;

public interface WalkService {

    List<Coordinate> getWalkGraphPath(Coordinate start, Coordinate end);

    SubPath walkInfoToSubPath();
}
