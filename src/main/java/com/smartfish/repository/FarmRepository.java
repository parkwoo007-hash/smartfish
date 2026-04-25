package com.smartfish.repository;

import com.smartfish.entity.FarmInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FarmRepository extends JpaRepository<FarmInfo, Integer> {
    // 기본적인 저장(save), 조회(findAll) 기능이 자동으로 들어있습니다.
}