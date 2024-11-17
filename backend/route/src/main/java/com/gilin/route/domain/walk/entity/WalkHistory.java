package com.gilin.route.domain.walk.entity;

import com.gilin.route.domain.member.entity.Member;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Entity
@Getter
@RequiredArgsConstructor
public class WalkHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne(optional = false)
    private Member member;

    @Column
    private Integer distance;

    @Column
    private Integer time;

    public WalkHistory(Integer distance, Integer time, Member member) {
        this.distance = distance;
        this.time = time;
        this.member = member;
    }
}
