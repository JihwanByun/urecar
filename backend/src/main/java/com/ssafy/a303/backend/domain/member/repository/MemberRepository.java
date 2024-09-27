package com.ssafy.a303.backend.domain.member.repository;

import com.ssafy.a303.backend.domain.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {

    Member findByEmail(String email);

    Boolean existsByEmail(String email);

}
