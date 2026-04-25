package com.smartfish.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "tank_info")
@Data
public class TankInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer tankId;
    
    private Integer farmId;
    private String tankName;
    private String species;
    
    // DB의 언더바(_)가 포함된 컬럼명과 자바 변수를 명확히 연결합니다.
    @Column(name = "width_m")
    private Double widthM;
    
    @Column(name = "length_m")
    private Double lengthM;
    
    @Column(name = "height_m")
    private Double heightM;
    
    @Column(name = "water_level_m")
    private Double waterLevelM;

    private Double waterVolumeTon;
    private String culturePhase;
    private Integer stockingDensityStandard;
    private Integer stockingDensityActual;
    private LocalDate stockingDate;
    private String supplier;
    private String seedNo;
    private Integer totalCount;
    private Double totalWeightKg;
    private Double weightPerPiece;
    private String deviceNo;
    private String feedCompany;
    private String feedName;
    private String seedSpecies; // 종자 종류
}