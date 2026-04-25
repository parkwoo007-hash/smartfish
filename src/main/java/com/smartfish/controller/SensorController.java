package com.smartfish.controller;

import com.smartfish.entity.SensorData;
import com.smartfish.repository.SensorDataRepository;
import com.smartfish.repository.TankRepository;
import com.smartfish.repository.FarmRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
public class SensorController {

    @Autowired
    private SensorDataRepository sensorDataRepository;

    @Autowired
    private FarmRepository farmRepository; // 양식장 목록 조회를 위해 주입

    @Autowired
        private TankRepository tankRepository;



    // [데이터 저장] ESP8266 장비로부터 데이터를 받아 저장
    @GetMapping("/save")
    @ResponseBody
    public String save(
            @RequestParam("device_no") String deviceNo, 
            @RequestParam(value = "water_temp", required = false) Double waterTemp, 
            @RequestParam(value = "ph", required = false) Double ph,
            @RequestParam(value = "do_val", required = false) Double doVal,
            @RequestParam(value = "air_temp", required = false) Double airTemp,
            @RequestParam(value = "air_humid", required = false) Double airHumid,
            @RequestParam(value = "lux", required = false) Double lux) {
        
        SensorData data = new SensorData();
        data.setDeviceNo(deviceNo);
        data.setWaterTemp(waterTemp);
        data.setPh(ph);
        data.setDoVal(doVal);
        data.setAirTemp(airTemp);
        data.setAirHumid(airHumid);
        data.setLux(lux);
        
        sensorDataRepository.save(data);
        return "OK: Data saved to Seongwoo's DB!";
    }

    // [데이터 목록] 필터용 양식장 목록과 센서 데이터를 함께 전달
@GetMapping("/list")
public String list(
        @RequestParam(value = "farm", required = false) String farm,
        @RequestParam(value = "tank", required = false) String tank,
        Model model) {
    
    List<Map<String, Object>> listWithNames = sensorDataRepository.findAllWithNames();
    model.addAttribute("farmList", farmRepository.findAll());
    model.addAttribute("tankList", tankRepository.findAll());
    model.addAttribute("sensorList", listWithNames);
    
    // 사용자가 선택했던 값을 다시 화면으로 보내서 드롭박스에 고정시킵니다.
    model.addAttribute("selectedFarm", farm);
    model.addAttribute("selectedTank", tank);
    
    return "list"; 
}
}