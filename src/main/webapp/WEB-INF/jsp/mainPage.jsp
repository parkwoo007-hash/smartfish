<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 메인 페이지</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; display: flex; flex-direction: column; height: 100vh; }
        .wrapper { display: flex; flex: 1; }
        .content { flex: 1; padding: 40px; background-color: #f4f7f6; overflow-y: auto; }
        .welcome-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="welcome-card">
                <h1 style="color: #005082;">안녕하세요. 메인페이지입니다.</h1>
                <p>수산양식 모니터링 시스템에 접속하신 것을 환영합니다.</p>
                <hr style="border: 0.5px solid #eee;">
                <p>현재 연결된 장치 상태: <span style="color: green; font-weight: bold;">정상</span></p>
            </div>
        </main>
    </div>

</body>
</html>