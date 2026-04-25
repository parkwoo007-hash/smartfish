package com.smartfish.repository;

import com.smartfish.entity.UserInfo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LoginRepository extends JpaRepository<UserInfo, String> {
}