package com.smartfish.repository;

import com.smartfish.entity.FarmMember;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FarmMemberRepository extends JpaRepository<FarmMember, Integer> {
    // 특정 사용자가 속한 양식장 목록을 찾을 때 사용합니다.
    List<FarmMember> findByUserId(String userId);
}