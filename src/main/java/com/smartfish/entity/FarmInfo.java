package com.smartfish.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "farms_info")
@Data
public class FarmInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer farmId;      // 양식장 고유 번호
    
    private String farmName;     // 양식장 이름
    private String farmAddress;  // 소재지 주소
    private String farmAddressDetail;
    private Double farmSize;     // 총면적(평)
    private String farmStructure; // 구조(축제식, 하우스, 혼합)
    private String farmType;     // 양식 품종
}