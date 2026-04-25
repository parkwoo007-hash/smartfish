package com.smartfish;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication
// 컴퓨터야, 이 폴더 아래에 있는 데이터 설계도(Entity)와 도구(Repository)를 다 찾아줘!
@EntityScan(basePackages = {"com.smartfish.entity"})
@EnableJpaRepositories(basePackages = {"com.smartfish.repository"})
public class SmartfishApplication {

    public static void main(String[] args) {
        // 이 한 줄이 스프링 부트 엔진을 켜는 스위치예요.
        SpringApplication.run(SmartfishApplication.class, args);
        
        System.out.println("===============================");
        System.out.println("   Smartfish 서버가 시작되었습니다!   ");
        System.out.println("===============================");
    }

}