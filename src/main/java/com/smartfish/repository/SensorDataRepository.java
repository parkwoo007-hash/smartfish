package com.smartfish.repository;

import com.smartfish.entity.SensorData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime; // 추가
import java.util.List;
import java.util.Map;

@Repository
public interface SensorDataRepository extends JpaRepository<SensorData, Long> {

    // [1] 실시간 목록 조회용 (기존 유지)
    @Query(value = "SELECT s.*, s.reg_date as regDate, t.tank_name as tankName, f.farm_name as farmName " +
                   "FROM sensor_data s " +
                   "LEFT JOIN tank_info t ON s.device_no = t.device_no " +
                   "LEFT JOIN farms_info f ON t.farm_id = f.farm_id " +
                   "ORDER BY s.data_id DESC", nativeQuery = true)
    List<Map<String, Object>> findAllWithNames();

    // [2] 수조명/기간 조회 (타입 변경: LocalDateTime)
    @Query(value = "SELECT s.* FROM sensor_data s " +
                   "JOIN tank_info t ON s.device_no = t.device_no " +
                   "WHERE t.tank_name = :tankName " +
                   "AND s.reg_date BETWEEN :start AND :end " +
                   "ORDER BY s.reg_date ASC", nativeQuery = true)
    List<SensorData> findByTankNameAndRegDateBetween(
            @Param("tankName") String tankName,
            @Param("start") LocalDateTime start, // String -> LocalDateTime
            @Param("end") LocalDateTime end);    // String -> LocalDateTime

    // [3] 날짜 범위 조회 (AQC 이상치 탐지용 핵심 - 타입 변경)
    List<SensorData> findByRegDateBetween(LocalDateTime start, LocalDateTime end);
}