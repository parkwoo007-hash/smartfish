package com.smartfish.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smartfish.entity.UserInfo;
import com.smartfish.repository.LoginRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private LoginRepository loginRepository;

    // --- [로그인 영역] ---
    @GetMapping("/login")
    public String loginPage() {
        return "loginPage";
    }

    @PostMapping("/loginProcess")
    @ResponseBody
    public String loginProcess(@RequestParam String userId, @RequestParam String password, HttpSession session) {
        Optional<UserInfo> user = loginRepository.findById(userId);
        
        if (user.isEmpty()) {
            return "아이디가 없습니다. 확인해주세요.";
        }
        
        if (!user.get().getPassword().equals(password)) {
            return "비밀번호를 확인하세요.";
        }
        
        // 핵심: 로그인 성공 시 세션에 아이디 저장!
        session.setAttribute("userId", userId); 
        
        return "OK";
    }

    // --- [회원가입 영역] ---
    @GetMapping("/loginJoin")
    public String joinPage() {
        return "loginJoin";
    }

    @PostMapping("/loginJoinProcess")
    public String joinProcess(UserInfo userInfo) {
        loginRepository.save(userInfo); // 저장 및 수정을 동시에 처리
        return "redirect:/login";
    }

    // --- [아이디/비밀번호 찾기 영역] ---
    @GetMapping("/loginFind")
    public String loginFind() {
        return "loginFind";
    }

    @PostMapping("/findIdProcess")
    @ResponseBody
    public String findId(@RequestParam String phone, @RequestParam String pwHint) {
        return loginRepository.findAll().stream()
                .filter(u -> phone.equals(u.getPhone()) && pwHint.equals(u.getPwHint()))
                .map(UserInfo::getUserId)
                .findFirst()
                .orElse("FAIL");
    }

    @PostMapping("/findPwProcess")
    @ResponseBody
    public String findPw(@RequestParam String userId, @RequestParam String phone) {
        Optional<UserInfo> user = loginRepository.findById(userId);
        
        if (user.isPresent() && user.get().getPhone().equals(phone)) {
            String tempPw = String.valueOf((int)(Math.random() * 899999) + 100000);
            user.get().setPassword(tempPw);
            loginRepository.save(user.get());
            return tempPw;
        }
        return "FAIL";
    }

    // --- [내 정보 수정 영역 (보안 포함)] ---

    // 1. 비밀번호 재확인 페이지 이동
    @GetMapping("/loginConfirm")
    public String loginConfirm() {
        return "loginConfirm";
    }

    // 2. 수정 전 비밀번호 검증 처리 (jakarta 세션 사용)
    @PostMapping("/verifyPw")
    @ResponseBody
    public String verifyPw(@RequestParam String password) {
        // 테스트용: DB의 첫 번째 사용자 정보를 기준으로 검증
        List<UserInfo> users = loginRepository.findAll();
        
        if (!users.isEmpty() && users.get(0).getPassword().equals(password)) {
            return "OK";
        }
        return "FAIL";
    }

    // 3. 정보 수정 페이지 이동 (기존 정보 채우기)
    @GetMapping("/loginEdit")
    public String loginEdit(Model model) {
        List<UserInfo> users = loginRepository.findAll();
        if (!users.isEmpty()) {
            model.addAttribute("user", users.get(0));
        }
        return "loginEdit";
    }
}