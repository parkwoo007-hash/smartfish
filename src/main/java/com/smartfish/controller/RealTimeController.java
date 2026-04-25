package com.smartfish.controller;

import com.smartfish.repository.SensorDataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RealTimeController {

    @Autowired
    private SensorDataRepository sensorDataRepository;

    // 실시간 모니터링 화면 호출
    @GetMapping("/realtime")
    public String realTimeMonitor() {
        // WEB-INF/jsp/RealMonitor.jsp 파일을 찾아갑니다.
        return "RealMonitor"; 
    }
}