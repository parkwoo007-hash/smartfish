package com.smartfish.controller;

import com.smartfish.entity.TankInfo;
import com.smartfish.repository.TankRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
public class TankController {

    @Autowired
    private TankRepository tankRepository;

    @GetMapping("/tankList")
    @ResponseBody
    public List<TankInfo> getTankList(@RequestParam Integer farmId) {
        return tankRepository.findByFarmId(farmId);
    }

    @GetMapping("/tankReg")
    public String tankRegPage(@RequestParam Integer farmId, 
                            @RequestParam(required = false) Integer tankId, 
                            Model model) {
        model.addAttribute("farmId", farmId);
        
        // 수정 모드: tankId가 있으면 데이터를 조회해서 모델에 담음
        if (tankId != null) {
            TankInfo tank = tankRepository.findById(tankId).orElse(null);
            model.addAttribute("tank", tank);
        }
        return "tankReg";
    }

    @PostMapping("/tankDelete")
    @ResponseBody
    public String tankDelete(@RequestParam Integer tankId) {
        try {
            tankRepository.deleteById(tankId);
            return "SUCCESS";
        } catch (Exception e) {
            return "FAIL";
        }
    }












    @PostMapping("/tankRegProcess")
    @ResponseBody
    public String tankRegProcess(TankInfo tankInfo) {
        try {
            // 1. 담수량 연산
            double volume = tankInfo.getWidthM() * tankInfo.getLengthM() * tankInfo.getWaterLevelM();
            tankInfo.setWaterVolumeTon(Math.round(volume * 100) / 100.0);
            
            // 2. 평당 입식 밀도 연산 (마리/평)
            if(tankInfo.getWidthM() > 0 && tankInfo.getLengthM() > 0 && tankInfo.getTotalCount() > 0) {
                double pyeong = (tankInfo.getWidthM() * tankInfo.getLengthM()) / 3.305;
                int densityPerPyeong = (int) Math.round(tankInfo.getTotalCount() / pyeong);
                tankInfo.setStockingDensityActual(densityPerPyeong);
            }

            // 3. 1마리당 무게 연산
            if(tankInfo.getTotalCount() != null && tankInfo.getTotalCount() > 0) {
                double perWeight = (tankInfo.getTotalWeightKg() / tankInfo.getTotalCount()) * 1000;
                tankInfo.setWeightPerPiece(Math.round(perWeight * 1000) / 1000.0);
            }

            tankRepository.save(tankInfo);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace(); // 에러 로그 출력
            return "FAIL";
        }
    }





    
}