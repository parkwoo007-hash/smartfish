<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theoros WQS - 비밀번호 확인</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 1. 전체 레이아웃: 헤더를 위에, 나머지를 아래에 배치 */
        body { 
            margin: 0; padding: 0; font-family: 'Pretendard', 'Malgun Gothic', sans-serif; 
            background: #f4f7f6; display: flex; flex-direction: column; 
            height: 100vh; overflow: hidden; 
        }

        /* 2. 사이드바와 본문을 가로로 배치할 컨테이너 */
        .wrapper {
            display: flex;
            flex: 1;
            overflow: hidden;
        }

        /* 3. 본문 영역: 사이드바 옆 나머지 공간을 차지하고 중앙 정렬 */
        .content {
            flex: 1;
            display: flex;
            justify-content: center; /* 가로 중앙 */
            align-items: center;     /* 세로 중앙 */
            padding: 20px;
        }

        .confirm-box { 
            width: 100%;
            max-width: 400px; 
            background: white; padding: 50px 40px; 
            border-radius: 20px; text-align: center; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
            border: 1px solid #e2e8f0;
        }

        .icon { font-size: 50px; margin-bottom: 20px; }
        h3 { color: #1e3a8a; margin-bottom: 12px; font-weight: 800; font-size: 22px; }
        p { color: #64748b; font-size: 15px; margin-bottom: 30px; line-height: 1.6; }
        
        input { 
            width: 100%; padding: 15px; margin-bottom: 20px; 
            border: 1px solid #cbd5e1; border-radius: 12px; 
            box-sizing: border-box; font-size: 16px; outline: none;
            background: #f8fafc; transition: 0.3s;
        }
        input:focus { border-color: #3b82f6; background: #fff; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1); }

        .btn-confirm { 
            width: 100%; padding: 15px; background: #1e3a8a; 
            color: white; border: none; border-radius: 12px; 
            cursor: pointer; font-size: 16px; font-weight: 800; 
            transition: 0.3s; box-shadow: 0 4px 6px rgba(30, 58, 138, 0.2);
        }
        .btn-confirm:hover { background: #1e40af; transform: translateY(-1px); }

        .back-link { display: inline-block; margin-top: 25px; color: #94a3b8; text-decoration: none; font-weight: 600; font-size: 14px; }
        .back-link:hover { color: #64748b; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="confirm-box">
                <div class="icon">🔒</div>
                <h3>비밀번호 재확인</h3>
                <p>개인정보 보호를 위해<br><strong>현재 비밀번호</strong>를 입력해주세요.</p>
                
                <input type="password" id="confirmPw" placeholder="비밀번호를 입력하세요" onkeyup="if(window.event.keyCode==13){checkPw()}">
                <button class="btn-confirm" onclick="checkPw()">안전하게 확인</button>
                
                <a href="javascript:history.back()" class="back-link">← 이전 페이지로 돌아가기</a>
            </div>
        </main>
    </div>

    <script>
        function checkPw() {
            const pw = document.getElementById('confirmPw').value;
            if(!pw) {
                alert("비밀번호를 입력해주세요.");
                return;
            }

            // 서버에 비밀번호 검증 요청
            fetch('/verifyPw?password=' + encodeURIComponent(pw), { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "OK") {
                    location.href = "/loginEdit"; // 성공 시 회원수정 페이지
                } else {
                    alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
                    document.getElementById('confirmPw').value = "";
                    document.getElementById('confirmPw').focus();
                }
            })
            .catch(err => {
                alert("서버 통신 중 오류가 발생했습니다.");
            });
        }
    </script>
</body>
</html>