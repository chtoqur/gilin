package com.gilin.route.domain.member.repository;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.OAuthType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
    List<Member> findByoAuthTypeAndOauthId(OAuthType oAuthType, String oauthId);
}
