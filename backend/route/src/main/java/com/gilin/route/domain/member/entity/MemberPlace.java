package com.gilin.route.domain.member.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Entity(name = "member_place")
@Getter
@NoArgsConstructor
public class MemberPlace {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_place_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @Column
    private int type;

    @Column
    private Double x;

    @Column
    private Double y;

    @Column
    private String address;

    @Column(name = "arrival_time")
    private LocalTime arrivalTime;
}
