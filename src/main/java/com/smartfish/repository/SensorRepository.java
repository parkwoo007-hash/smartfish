package com.smartfish.repository;

import com.smartfish.entity.SensorData;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SensorRepository extends JpaRepository<SensorData, Long> {
}