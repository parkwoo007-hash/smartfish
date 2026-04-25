<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav style="width: 240px; background: #2c3e50; color: white; height: calc(100vh - 60px); padding: 10px 0; box-shadow: 2px 0 5px rgba(0,0,0,0.1); flex-shrink: 0;">
    <ul style="list-style: none; padding: 0; margin: 0;">
        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/main" style="color: white; text-decoration: none; display: block; transition: 0.3s;"> 메인 대시보드</a>
        </li>

        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/farmList" style="color: white; text-decoration: none; display: block;"> - 양식장 관리</a>
        </li>

        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/loginConfirm" style="color: white; text-decoration: none; display: block;"> - 내 정보 관리</a>
        </li>

        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/list" style="color: white; text-decoration: none; display: block;"> - 실시간 데이터 조회</a>
        </li>

        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/history/analysis" style="color: white; text-decoration: none; display: block;"> - 과거 데이터 정밀 조회</a>
        </li>
        
        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/aqc/manage" style="color: white; text-decoration: none; display: block;"> - AQC 품질 관제 센터</a>
        </li>

        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/manual/form" style="color: white; text-decoration: none; display: block;"> - 수기 데이터 입력</a>
        </li>
        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/manual/list" style="color: white; text-decoration: none; display: block;"> - 수기 기록 목록</a>
        </li>

        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="/carList" style="color: white; text-decoration: none; display: block;"> - 자동차 목록</a>
        </li>

        
        <li style="padding: 15px 20px; border-bottom: 1px solid #3e4f5f;">
            <a href="#" style="color: white; text-decoration: none; display: block;"> - 장비 설정</a>
        </li>


    </ul>
</nav>

<style>
    /* 마우스 올렸을 때 효과 */
    nav ul li:hover {
        background: #34495e;
    }
    nav ul li a:hover {
        color: #3498db !important;
    }
    
    /* 현재 페이지 표시나 중요 메뉴 강조를 위한 배경색 미세 조정 */
    nav ul li a {
        transition: color 0.2s ease-in-out;
    }
</style>