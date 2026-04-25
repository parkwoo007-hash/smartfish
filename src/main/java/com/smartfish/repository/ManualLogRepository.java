package com.smartfish.repository;

import com.smartfish.entity.ManualLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ManualLogRepository extends JpaRepository<ManualLog, Long> {
    // 🛠️ 추가: 수기 기록 조회를 위한 날짜 범위 검색 메소드
    List<ManualLog> findByRegDateBetween(LocalDateTime start, LocalDateTime end);
    
    // 기존에 수조명으로 찾던 메소드가 있다면 유지
    List<ManualLog> findByTankNameAndRegDateBetween(String tankName, LocalDateTime start, LocalDateTime end);
}