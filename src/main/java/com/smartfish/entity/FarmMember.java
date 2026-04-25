package com.smartfish.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "farm_members")
@Data
public class FarmMember {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer memberIdx;

    private String userId;
    private Integer farmId;
    private String role; // ADMIN, USER 등
    
    private LocalDateTime regDate = LocalDateTime.now();
}