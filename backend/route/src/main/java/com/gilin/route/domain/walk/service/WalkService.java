package com.gilin.route.domain.walk.service;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.route.dto.response.RouteResponse.SubPathh;
import com.gilin.route.domain.walk.dto.WalkInfo;
import com.gilin.route.domain.walk.dto.request.WalkHistoryRequestDto;
import com.gilin.route.domain.walk.dto.response.WalkHistoryResponseDto;
import com.gilin.route.global.client.odsay.response.SearchPubTransPathResponse.Result.SubPath;
import com.gilin.route.global.dto.Coordinate;

public interface WalkService {

    WalkInfo getWalkGraphPath(Coordinate start, Coordinate end, Member member);

    SubPathh convertToSubPathh(SubPath prevSubPath, SubPath nextSubPath, Coordinate start,
        Coordinate end, Member member);

    void saveWalkHistory(WalkHistoryRequestDto request, Member member);

    WalkHistoryResponseDto getWalkHistory(Member member);

}
