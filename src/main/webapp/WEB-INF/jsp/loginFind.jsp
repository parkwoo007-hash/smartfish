<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>아이디/비밀번호 찾기</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .find-box { width: 400px; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        .tabs { display: flex; margin-bottom: 25px; border-bottom: 2px solid #eee; }
        .tab { flex: 1; text-align: center; padding: 12px; cursor: pointer; color: #999; transition: 0.3s; }
        .tab.active { color: #4CAF50; border-bottom: 3px solid #4CAF50; font-weight: bold; }
        .content { display: none; }
        .content.active { display: block; }
        input { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        button:hover { background: #45a049; }
        .result-box { margin-top: 20px; padding: 15px; background: #e8f5e9; border-radius: 5px; color: #2e7d32; display: none; text-align: center; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #666; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>

<div class="find-box">
    <div class="tabs">
        <div id="tabId" class="tab active" onclick="showTab('id')">아이디 찾기</div>
        <div id="tabPw" class="tab" onclick="showTab('pw')">비밀번호 찾기</div>
    </div>

    <div id="contentId" class="content active">
        <input type="text" id="idPhone" placeholder="가입한 전화번호 (010-0000-0000)">
        <input type="text" id="idHint" placeholder="비밀번호 힌트 답변">
        <button onclick="doFindId()">아이디 확인</button>
        <div id="idResult" class="result-box"></div>
    </div>

    <div id="contentPw" class="content">
        <input type="text" id="pwUserId" placeholder="아이디">
        <input type="text" id="pwPhone" placeholder="가입한 전화번호">
        <button onclick="doFindPw()">임시 비밀번호 발급</button>
        <div id="pwResult" class="result-box"></div>
    </div>
    
    <a href="/login" class="back-link">← 로그인 페이지로 돌아가기</a>
</div>

<script>
    function showTab(type) {
        document.querySelectorAll('.tab, .content').forEach(el => el.classList.remove('active'));
        if(type === 'id') {
            document.getElementById('tabId').classList.add('active');
            document.getElementById('contentId').classList.add('active');
        } else {
            document.getElementById('tabPw').classList.add('active');
            document.getElementById('contentPw').classList.add('active');
        }
    }

    function doFindId() {
        const phone = document.getElementById('idPhone').value;
        const hint = document.getElementById('idHint').value;
        
        fetch('/findIdProcess?phone=' + phone + '&pwHint=' + hint, { method: 'POST' })
        .then(res => res.text())
        .then(data => {
            const resBox = document.getElementById('idResult');
            resBox.style.display = "block";
            if(data === "FAIL") resBox.innerText = "정보가 일치하지 않습니다.";
            else resBox.innerHTML = "찾으시는 아이디: <strong>" + data + "</strong>";
        });
    }

    function doFindPw() {
        const userId = document.getElementById('pwUserId').value;
        const phone = document.getElementById('pwPhone').value;
        
        fetch('/findPwProcess?userId=' + userId + '&phone=' + phone, { method: 'POST' })
        .then(res => res.text())
        .then(data => {
            const resBox = document.getElementById('pwResult');
            resBox.style.display = "block";
            if(data === "FAIL") resBox.innerText = "일치하는 회원 정보가 없습니다.";
            else resBox.innerHTML = "임시 비밀번호: <strong>" + data + "</strong><br><small>로그인 후 비밀번호를 변경하세요.</small>";
        });
    }
</script>

</body>
</html>