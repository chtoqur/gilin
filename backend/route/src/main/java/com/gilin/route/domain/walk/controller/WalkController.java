package com.gilin.route.domain.walk.controller;


import com.gilin.route.domain.member.dto.Authenticated;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.walk.dto.request.WalkHistoryRequestDto;
import com.gilin.route.domain.walk.service.WalkService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/walk", produces = MediaType.APPLICATION_JSON_VALUE)
public class WalkController {

    private final WalkService walkService;

    @PostMapping
    public ResponseEntity<Void> walkHistorySave(
        @RequestBody WalkHistoryRequestDto request,
        @Authenticated Member member
    ) {
        walkService.saveWalkHistory(request, member);
        return ResponseEntity.noContent()
                             .build();
    }

}
