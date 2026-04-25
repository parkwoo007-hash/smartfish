package com.smartfish.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smartfish.entity.FarmInfo;
import com.smartfish.entity.FarmMember;
import com.smartfish.repository.FarmMemberRepository;
import com.smartfish.repository.FarmRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class FarmController {

    @Autowired
    private FarmRepository farmRepository;

    @Autowired
    private FarmMemberRepository farmMemberRepository;

    // 1. 양식장 관리 통합 목록 페이지
    @GetMapping("/farmList")
    public String farmListPage(Model model, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        // 전체 양식장 목록 조회
        List<FarmInfo> farms = farmRepository.findAll();
        model.addAttribute("farms", farms);
        return "farmList";
    }

    // 2. 등록 페이지 (팝업용)
    @GetMapping("/farmReg")
    public String farmRegPage(@RequestParam(required = false) Integer farmId, Model model, HttpSession session) {
        // 1. 보안 체크: 로그인 안 했으면 쫓아내기
        if (session.getAttribute("userId") == null) return "redirect:/login";

        // 2. 수정 모드 체크: farmId가 파라미터로 넘어왔는지 확인
        if (farmId != null) {
            // DB에서 해당 양식장 정보를 찾아서
            FarmInfo farm = farmRepository.findById(farmId).orElse(null);
            // "farm"이라는 이름으로 바구니(model)에 담아 JSP로 보냅니다.
            model.addAttribute("farm", farm); 
        }
        
        return "farmReg";
    }

    // 3. 등록 및 수정 프로세스 (AJAX 처리를 위해 @ResponseBody 사용)
    @PostMapping("/farmRegProcess")
    @ResponseBody
    public String farmRegProcess(FarmInfo farmInfo, HttpSession session) {
        String currentUserId = (String) session.getAttribute("userId");
        if (currentUserId == null) currentUserId = "admin"; // 테스트용 아이디

        // 저장 (farmId가 있으면 수정, 없으면 신규 등록이 자동으로 됨)
        FarmInfo savedFarm = farmRepository.save(farmInfo);
        
        // 신규 등록일 때만 멤버 연결 (수정 시에는 이미 연결되어 있음)
        if (farmInfo.getFarmId() == null) {
            FarmMember member = new FarmMember();
            member.setFarmId(savedFarm.getFarmId());
            member.setUserId(currentUserId);
            member.setRole("ADMIN"); 
            farmMemberRepository.save(member);
        }
        
        return "SUCCESS";
    }

    // 4. 삭제 프로세스
    @PostMapping("/farmDelete")
    @ResponseBody
    public String farmDelete(@RequestParam Integer farmId) {
        try {
            // 연결된 멤버 정보가 있다면 먼저 지우는 로직이 필요할 수 있습니다.
            farmRepository.deleteById(farmId);
            return "SUCCESS";
        } catch (Exception e) {
            return "FAIL";
        }
    }










}