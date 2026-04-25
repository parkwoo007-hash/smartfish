package com.smartfish.controller;

import com.smartfish.entity.ManualLog;
import com.smartfish.entity.TankInfo;
import com.smartfish.repository.ManualLogRepository;
import com.smartfish.repository.FarmRepository;
import com.smartfish.repository.TankRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/manual") 
public class ManualLogController {

    @Autowired
    private ManualLogRepository manualLogRepository;

    @Autowired
    private FarmRepository farmRepository; 

    @Autowired
    private TankRepository tankRepository; 

    /**
     * [1] 수기 입력 및 목록 조회 화면
     * - 테이블 출력 시 수조명 옆에 장비번호를 붙여서 표시할 수 있도록 데이터를 가공합니다.
     */
    @GetMapping("/form")
    public String manualForm(
            @RequestParam(value = "farmName", required = false) String farmName,
            @RequestParam(value = "tankName", required = false) String tankName,
            Model model) {
        
        // 1. 드롭박스용 마스터 데이터
        model.addAttribute("farmList", farmRepository.findAll());
        List<TankInfo> tankList = tankRepository.findAll();
        model.addAttribute("tankList", tankList);
        
        // 2. 장비번호 매핑용 맵 (수조명 -> 장비번호)
        Map<String, String> tankToDeviceMap = tankList.stream()
                .collect(Collectors.toMap(TankInfo::getTankName, 
                        t -> t.getDeviceNo() != null ? t.getDeviceNo() : "미등록", (a, b) -> a));
        model.addAttribute("deviceMap", tankToDeviceMap);

        // 3. 수기 기록 목록 (최신순)
        List<ManualLog> logs = manualLogRepository.findAll(Sort.by(Sort.Direction.DESC, "logId"));
        model.addAttribute("logs", logs);
        
        // 4. 상태 유지값
        model.addAttribute("selectedFarm", farmName);
        model.addAttribute("selectedTank", tankName);

        return "manual_form"; 
    }

    /**
     * [2] 수기 데이터 저장 및 수정
     */
    @PostMapping("/save")
    public String saveLog(ManualLog manualLog) {
        
        // ID가 있는 경우(수정) 기존 데이터 로드 후 변경된 부분만 덮어쓰기 로직을 추가할 수 있습니다.
        // 여기서는 단순 save로 처리 (ID가 있으면 Update)
        manualLogRepository.save(manualLog);

        try {
            String encodedFarm = URLEncoder.encode(manualLog.getFarmName() != null ? manualLog.getFarmName() : "", StandardCharsets.UTF_8);
            String encodedTank = URLEncoder.encode(manualLog.getTankName() != null ? manualLog.getTankName() : "", StandardCharsets.UTF_8);

            return "redirect:/manual/form?farmName=" + encodedFarm + "&tankName=" + encodedTank;
            
        } catch (Exception e) {
            return "redirect:/manual/form";
        }
    }

    /**
     * [3] 수기 데이터 삭제
     */
    @GetMapping("/delete/{id}")
    public String deleteLog(@PathVariable("id") Long id) {
        manualLogRepository.deleteById(id);
        return "redirect:/manual/form";
    }

    /**
     * [4] 기존 목록 화면 (호환성 유지)
     */
    @GetMapping("/list")
    public String listLogs(
            @RequestParam(value = "farmName", required = false) String farmName,
            @RequestParam(required = false) String tankName,
            Model model) {
        
        model.addAttribute("farmList", farmRepository.findAll());
        model.addAttribute("tankList", tankRepository.findAll());
        model.addAttribute("logs", manualLogRepository.findAll(Sort.by(Sort.Direction.DESC, "logId")));
        model.addAttribute("selectedFarm", farmName);
        model.addAttribute("selectedTank", tankName);

        return "manual_list"; 
    }
}