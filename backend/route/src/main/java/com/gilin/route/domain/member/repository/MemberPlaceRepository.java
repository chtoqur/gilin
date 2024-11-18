package com.gilin.route.domain.member.repository;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.MemberPlace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MemberPlaceRepository extends JpaRepository<MemberPlace, Long> {
    Optional<MemberPlace> findByMemberAndType(Member member, Integer type);
    List<MemberPlace> findByMemberOrderByTypeAsc(Member member);
}
