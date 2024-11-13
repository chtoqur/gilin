package com.gilin.route.domain.member.entity;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@Entity(name = "member")
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long Id;

    @Column(name = "oauth_type")
    @Enumerated(EnumType.STRING)
    private OAuthType oAuthType;

    @Column(name = "oauth_id")
    private String oauthId;

    @Column
    private String name;

    @Column
    private Integer age;

    @Column
    private String gender;

    @Column
    private Integer travelType;

    @OneToMany(mappedBy = "member")
    private List<MemberPlace> places = new ArrayList<>();

    @Builder
    public Member(OAuthType oAuthType, String oauthId, String name, Integer age, String gender, Integer travelType) {
        this.oAuthType = oAuthType;
        this.oauthId = oauthId;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.travelType = travelType;
    }
}


