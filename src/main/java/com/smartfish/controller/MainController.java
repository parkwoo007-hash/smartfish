package com.smartfish.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/main")
    public String mainPage() {
        return "mainPage"; // mainPage.jsp를 찾아갑니다.
    }
}