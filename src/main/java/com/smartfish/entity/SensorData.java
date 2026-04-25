package com.smartfish.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "sensor_data") // 아까 만든 DB 테이블 이름과 똑같이 써요
@Data // 변수들의 저장/읽기(Getter/Setter)를 자동으로 해줘요
public class SensorData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long dataId; // 데이터 번호

    @Column(name = "device_no")
    private String deviceNo; // 어떤 장비인지 이름

    // 공통 데이터 (양식장 안의 날씨)
    @Column(name = "air_temp")
    private Double airTemp; // 기온

    @Column(name = "air_humid")
    private Double airHumid; // 습도

    @Column(name = "lux")
    private Double lux; // 밝기

    // 수조별 데이터 (물속 상태)
    @Column(name = "water_temp")
    private Double waterTemp; // 수온

    @Column(name = "ph")
    private Double ph; // 산성도

    @Column(name = "do_val")
    private Double doVal; // 산소량

    @Column(name = "reg_date", insertable = false, updatable = false)
    private LocalDateTime regDate;
}