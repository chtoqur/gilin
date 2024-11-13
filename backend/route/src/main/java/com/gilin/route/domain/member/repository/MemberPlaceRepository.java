package com.gilin.route.domain.member.repository;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.MemberPlace;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberPlaceRepository extends JpaRepository<MemberPlace, Long> {
    void deleteByMemberAndType(Member member, Integer type);
}
