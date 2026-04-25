package com.smartfish.controller;

import com.smartfish.repository.SensorDataRepository;
import com.smartfish.repository.ManualLogRepository;
import com.smartfish.repository.TankRepository;
import com.smartfish.repository.FarmRepository; // 👈 1. 추가됨
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
public class HistoryDataController {

    @Autowired
    private TankRepository tankRepository;
    
    @Autowired
    private SensorDataRepository sensorRepository;
    
    @Autowired
    private ManualLogRepository manualRepository;

    @Autowired
    private FarmRepository farmRepository; // 👈 2. 이 줄이 없어서 빨간 줄이 떴던 겁니다!

    /**
     * [1] 과거 데이터 분석 페이지 열기
     * 중복되었던 historyPage 함수를 하나로 합쳤습니다.
     */
    @GetMapping("/history/analysis")
    public String historyPage(Model model) {
        // 드롭박스 조회를 위해 양식장 목록과 수조 목록을 모두 보냅니다.
        model.addAttribute("farmList", farmRepository.findAll()); 
        model.addAttribute("tankList", tankRepository.findAll());
        return "history_data";
    }

    /**
     * [2] 그래프용 데이터 API
     */
    /**
     * [2] 그래프용 데이터 API
     */
    @GetMapping("/getHistoryData")
    @ResponseBody
    public Map<String, Object> getHistoryData(
            @RequestParam String tankName,
            @RequestParam String startDate,
            @RequestParam String endDate) {

        Map<String, Object> result = new HashMap<>();

        // 날짜 포맷 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        
        // 1. 글자로 된 날짜를 LocalDateTime 객체로 변환 (모든 조회에 공통 사용)
        LocalDateTime startObj = LocalDateTime.parse(startDate + " 00:00:00", formatter);
        LocalDateTime endObj = LocalDateTime.parse(endDate + " 23:59:59", formatter);

        // 2. 센서 데이터 조회 (중요: 이제 String이 아닌 LocalDateTime 객체인 startObj, endObj를 전달합니다)
        result.put("sensor", sensorRepository.findByTankNameAndRegDateBetween(tankName, startObj, endObj));
        
        // 3. 수기 기록 조회 (타입 일치)
        result.put("manual", manualRepository.findByTankNameAndRegDateBetween(tankName, startObj, endObj));
        
        return result; 
    }
}