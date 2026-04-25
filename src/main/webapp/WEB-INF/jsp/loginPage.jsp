<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 로그인</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { width: 350px; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #005082; margin-bottom: 30px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        
        /* 체크박스 스타일 */
        .remember-me { margin-bottom: 20px; font-size: 14px; color: #666; display: flex; align-items: center; }
        .remember-me input { width: auto; margin-right: 8px; cursor: pointer; }
        
        button { width: 100%; padding: 12px; background: #005082; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: bold; transition: 0.3s; }
        button:hover { background: #003d63; }
        
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; }
        .footer-links a { text-decoration: none; color: #666; transition: 0.3s; }
        .footer-links a:hover { color: #005082; font-weight: bold; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>🐟 Smartfish 로그인</h2>
        
        <input type="text" id="userId" placeholder="아이디">
        <input type="password" id="password" placeholder="비밀번호">
        
        <div class="remember-me">
            <input type="checkbox" id="rememberMe">
            <label for="rememberMe" style="cursor: pointer;">아이디/비밀번호 기억하기</label>
        </div>
        
        <button onclick="doLogin()">로그인</button>
        
        <div class="footer-links">
            <a href="/loginJoin">회원가입</a> 
            <span style="color: #ccc; margin: 0 10px;">|</span>
            <a href="/loginFind">아이디/비밀번호 찾기</a>
        </div>
    </div>

    <script>
        // 페이지가 열릴 때 저장된 정보가 있는지 확인
        window.onload = function() {
            const savedId = localStorage.getItem("savedUserId");
            const savedPw = localStorage.getItem("savedPassword");
            
            if (savedId && savedPw) {
                document.getElementById("userId").value = savedId;
                document.getElementById("password").value = savedPw;
                document.getElementById("rememberMe").checked = true;
            }
        };

        function doLogin() {
            const userId = document.getElementById('userId').value;
            const password = document.getElementById('password').value;
            const rememberMe = document.getElementById('rememberMe').checked;

            fetch('/loginProcess?userId=' + userId + '&password=' + password, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "OK") {
                    // 기억하기가 체크되어 있으면 브라우저에 저장
                    if (rememberMe) {
                        localStorage.setItem("savedUserId", userId);
                        localStorage.setItem("savedPassword", password);
                    } else {
                        // 체크 안 되어 있으면 정보 삭제
                        localStorage.removeItem("savedUserId");
                        localStorage.removeItem("savedPassword");
                    }
                    location.href = "/main";
                } else {
                    alert(data);
                }
            });
        }
    </script>
</body>
</html>