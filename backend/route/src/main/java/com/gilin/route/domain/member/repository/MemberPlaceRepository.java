package com.gilin.route.domain.member.repository;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.MemberPlace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MemberPlaceRepository extends JpaRepository<MemberPlace, Long> {
    void deleteByMemberAndType(Member member, Integer type);
    List<MemberPlace> findByMember(Member member);
}
