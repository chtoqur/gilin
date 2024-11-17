package com.gilin.route.domain.walk.repository;

import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.walk.entity.WalkHistory;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WalkHistoryRepository extends JpaRepository<WalkHistory, Long> {

    List<WalkHistory> findAllByMember(Member member);
}
