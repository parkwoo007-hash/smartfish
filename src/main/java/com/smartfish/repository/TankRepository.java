package com.smartfish.repository;

import com.smartfish.entity.TankInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TankRepository extends JpaRepository<TankInfo, Integer> {
    List<TankInfo> findByFarmId(Integer farmId);
}