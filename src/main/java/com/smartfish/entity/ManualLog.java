package com.smartfish.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "manual_log")
@Data
public class ManualLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long logId;             // 기록 번호

    private String farmName;        // 양식장 이름
    private String tankName;        // 수조 이름
    
    @Column(insertable = false, updatable = false)
    private LocalDateTime regDate;  // 작성일시 (DB에서 자동생성)

    private Double avgWeight;       // 평균체중(g)
    private Integer deathCount;     // 오늘 폐사량(마리)
    
    private Double tan;             // 총 암모니아(TAN)
    private Double nitrite;         // 아질산
    private Double alkalinity;      // 알칼리도
    
    private Double glucoseInput;    // 포도당 투입량
    private Double molassesInput;   // 당밀 투입량
    private Double bicarbonateInput;// 중탄산 투입량
    private Double slakedLimeInput; // 소석회 투입량
    private Double calciumInput;    // 칼키 투입량
    
    private Double feedAmount;      // 사료량
    private String feedCompany;     // 사료회사
    private String feedType;        // 사료종류
    
    private Double vitaminInput;    // 비타민
    private Double bacillusInput;   // 바실러스
    private Double nutrientsInput;  // 영양제
    
    @Column(columnDefinition = "TEXT")
    private String remarks;         // 비고
}