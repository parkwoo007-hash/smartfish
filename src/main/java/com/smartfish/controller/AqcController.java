package com.smartfish.controller;

import com.smartfish.entity.*;
import com.smartfish.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/aqc")
public class AqcController {

    @Autowired private AqcLimitRepository aqcRepository;
    @Autowired private TankRepository tankRepository;
    @Autowired private SensorDataRepository sensorRepository;
    @Autowired private ManualLogRepository manualRepository;
    @Autowired private FarmRepository farmRepository;

    @GetMapping("/manage")
    public String aqcPage(
            @RequestParam(required = false) String farmId,
            @RequestParam(required = false) String tankId,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            Model model) {

        // 1. 기본 마스터 데이터 로드 (양식장, 수조)
        List<FarmInfo> farmList = farmRepository.findAll();
        List<TankInfo> allTanks = tankRepository.findAll();
        model.addAttribute("farmList", farmList);
        model.addAttribute("tankList", allTanks);
        
        // 2. 이름 치환을 위한 맵(Map) 생성
        // 양식장ID -> 양식장 이름
        Map<Integer, String> farmNameMap = farmList.stream()
                .collect(Collectors.toMap(FarmInfo::getFarmId, FarmInfo::getFarmName, (a, b) -> a));

        // 장비번호 -> 수조 정보 전체 (이름 및 ID 추출용)
        Map<String, TankInfo> deviceToTankInfoMap = allTanks.stream()
                .filter(t -> t.getDeviceNo() != null)
                .collect(Collectors.toMap(TankInfo::getDeviceNo, t -> t, (a, b) -> a));

        // 수조이름 -> 수조ID (수기 기록용)
        Map<String, Integer> nameToTankMap = allTanks.stream()
                .collect(Collectors.toMap(TankInfo::getTankName, TankInfo::getTankId, (a, b) -> a));

        // 3. 기준치(Limit) 맵 생성 (Key: tankId)
        Map<Integer, AqcLimit> limitMap = aqcRepository.findAll().stream()
                .collect(Collectors.toMap(AqcLimit::getTankId, l -> l, (existing, replacement) -> existing));
        model.addAttribute("limitMap", limitMap);

        // 검색 조건 유지
        model.addAttribute("farmId", farmId);
        model.addAttribute("tankId", tankId);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);

        if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            try {
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDateTime start = LocalDateTime.parse(startDate + " 00:00:00", dtf);
                LocalDateTime end = LocalDateTime.parse(endDate + " 23:59:59", dtf);

                List<Map<String, Object>> anomalyList = new ArrayList<>();

                // --- [A] 센서 데이터 이상 탐지 (실제 명칭 매핑 적용) ---
                List<SensorData> sensorLogs = sensorRepository.findByRegDateBetween(start, end);
                for (SensorData data : sensorLogs) {
                    // 장비번호로 수조 정보 찾기
                    TankInfo tank = deviceToTankInfoMap.get(data.getDeviceNo());
                    if (tank == null) continue; 

                    // 수조 필터링 (화면 선택값과 비교)
                    if (tankId != null && !tankId.equals("all") && !tank.getTankId().toString().equals(tankId)) continue;

                    // 실제 이름 매핑
                    String realFarmName = farmNameMap.getOrDefault(tank.getFarmId(), "알 수 없는 양식장");
                    String realTankName = tank.getTankName() + " (" + tank.getDeviceNo() + ")";

                    AqcLimit limit = limitMap.get(tank.getTankId());
                    if (limit == null) continue;

                    // 검사 및 리스트 추가 (이제 '양식장' 대신 실제 이름을 넣습니다)
                    checkAnomaly(anomalyList, data.getRegDate(), realFarmName, realTankName, "수온", data.getWaterTemp(), limit.getTempMin(), limit.getTempMax(), "RANGE", data.getDataId());
                    checkAnomaly(anomalyList, data.getRegDate(), realFarmName, realTankName, "DO", data.getDoVal(), limit.getDoLimit(), null, "MIN", data.getDataId());
                    checkAnomaly(anomalyList, data.getRegDate(), realFarmName, realTankName, "pH", data.getPh(), limit.getPhMin(), limit.getPhMax(), "RANGE", data.getDataId());
                }

                // --- [B] 수기 기록 데이터 이상 탐지 ---
// --- [B] 수기 기록 데이터 이상 탐지 (장비번호 매핑 보강) ---
List<ManualLog> manualLogs = manualRepository.findByRegDateBetween(start, end);
for (ManualLog m : manualLogs) {
    // 1. 수조 이름으로 수조ID 찾기
    Integer tid = nameToTankMap.get(m.getTankName());
    if (tid == null) continue;

    // 2. 검색 필터 적용
    if (tankId != null && !tankId.equals("all") && !tid.toString().equals(tankId)) continue;

    AqcLimit limit = limitMap.get(tid);
    if (limit == null) continue;

    // 🛠️ [핵심 추가] 수조 ID를 기반으로 해당 수조의 장비번호 찾아오기
    // allTanks 리스트에서 현재 수조ID와 일치하는 장비번호를 찾습니다.
    String deviceNo = allTanks.stream()
            .filter(t -> t.getTankId().equals(tid))
            .map(TankInfo::getDeviceNo)
            .findFirst()
            .orElse("");

    // 화면에 표시될 수조 명칭을 "수조명 (장비번호)" 형식으로 만듭니다.
    String displayTankName = m.getTankName() + (deviceNo.isEmpty() ? "" : " (" + deviceNo + ")");

    // 3. 이상치 체크 및 리스트 추가 (tName 자리에 displayTankName을 넣습니다)
    checkAnomaly(anomalyList, m.getRegDate(), m.getFarmName(), displayTankName, "암모니아(TAN)", m.getTan(), null, limit.getNh3Limit(), "MAX", m.getLogId());
    checkAnomaly(anomalyList, m.getRegDate(), m.getFarmName(), displayTankName, "아질산", m.getNitrite(), null, limit.getNo2Limit(), "MAX", m.getLogId());
    checkAnomaly(anomalyList, m.getRegDate(), m.getFarmName(), displayTankName, "알칼리도", m.getAlkalinity(), 120.0, 150.0, "RANGE", m.getLogId());
    checkAnomaly(anomalyList, m.getRegDate(), m.getFarmName(), displayTankName, "염분", m.getCalciumInput(), limit.getSalLimit(), limit.getSalMax(), "RANGE", m.getLogId());
}

                // 정렬 (최신순)
                anomalyList.sort((o1, o2) -> ((LocalDateTime)o2.get("regDate")).compareTo((LocalDateTime)o1.get("regDate")));
                model.addAttribute("anomalyList", anomalyList);

            } catch (Exception e) { e.printStackTrace(); }
        }
        return "aqc_manage";
    }

    private void checkAnomaly(List<Map<String, Object>> list, LocalDateTime regDate, String fName, String tName, String itemName, Double val, Double min, Double max, String type, Long dbId) {
        if (val == null) return;
        boolean isAnomaly = false;
        String limitStr = "";

        if ("RANGE".equals(type)) {
            if (val < (min != null ? min : -999) || val > (max != null ? max : 9999)) isAnomaly = true;
            limitStr = (min != null ? min : "0") + " ~ " + (max != null ? max : "∞");
        } else if ("MIN".equals(type)) {
            if (val < (min != null ? min : -999)) isAnomaly = true;
            limitStr = (min != null ? min : "0") + " 이상";
        } else if ("MAX".equals(type)) {
            if (val > (max != null ? max : 9999)) isAnomaly = true;
            limitStr = (max != null ? max : "0") + " 이하";
        }

        if (isAnomaly) {
            Map<String, Object> map = new HashMap<>();
            map.put("farmName", fName);
            map.put("tankName", tName);
            map.put("regDate", regDate);
            map.put("itemName", itemName);
            map.put("currVal", val);
            map.put("limitVal", limitStr);
            map.put("id", dbId);
            list.add(map);
        }
    }

    @PostMapping("/toggleStatus")
    @ResponseBody
    public String toggleStatus(@RequestParam Integer tankId, @RequestParam String status) {
        AqcLimit config = aqcRepository.findByTankId(tankId).orElse(new AqcLimit());
        config.setTankId(tankId);
        config.setMonitorStatus(status);
        aqcRepository.save(config);
        return "success";
    }

    @PostMapping("/saveLimits")
    @ResponseBody
    public String saveLimits(@RequestBody AqcLimit limitData) {
        AqcLimit existing = aqcRepository.findByTankId(limitData.getTankId()).orElse(new AqcLimit());
        if (existing.getLimitId() != null) { limitData.setLimitId(existing.getLimitId()); }
        aqcRepository.save(limitData); 
        return "success";
    }





    
}