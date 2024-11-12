package com.gilin.route.domain.member.repository;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.OAuthType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByOAuthTypeAndOauthId(String OAuthType, String oauthId);
}
