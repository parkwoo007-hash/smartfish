package com.smartfish.repository;

import com.smartfish.entity.AqcLimit;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AqcLimitRepository extends JpaRepository<AqcLimit, Integer> {
    Optional<AqcLimit> findByTankId(Integer tankId);
}