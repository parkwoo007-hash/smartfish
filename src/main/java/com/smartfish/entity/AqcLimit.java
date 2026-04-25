package com.smartfish.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "aqc_limit")
@Data
public class AqcLimit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "limit_id")
    private Integer limitId; // 고유 ID
    
    @Column(name = "tank_id", nullable = false, unique = true)
    private Integer tankId; // 수조 ID

    @Column(name = "monitor_status")
    private String monitorStatus; // START (수집중) / STOP (중단)

    // --- 수질 관리 한계치 설정 필드 ---

    @Column(name = "temp_min")
    private Double tempMin; // 수온 하한값 (℃)

    @Column(name = "temp_max")
    private Double tempMax; // 수온 상한값 (℃)

    @Column(name = "do_limit")
    private Double doLimit; // 용존산소(DO) 하한값 (mg/L)

    @Column(name = "ph_min")
    private Double phMin; // pH 하한값

    @Column(name = "ph_max")
    private Double phMax; // pH 상한값

    @Column(name = "nh3_limit")
    private Double nh3Limit; // 암모니아(NH3) 상한값 (ppm)

    @Column(name = "no2_limit")
    private Double no2Limit; // 아질산(NO2) 상한값 (ppm)

    @Column(name = "alk_limit")
    private Double alkLimit; // 알칼리도 하한값 (mg/L)

    @Column(name = "sal_limit")
    private Double salLimit; // 염분 하한값 (psu/ppt)

    @Column(name = "sal_max")
    private Double salMax; // 염분 상한값 (psu/ppt) - 👈 추가됨

    @Column(name = "ss_limit")
    private Double ssLimit; // 투명도(SS) 상한값 (cm)
}