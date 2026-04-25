<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 내 정보 수정</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; display: flex; flex-direction: column; height: 100vh; }
        .wrapper { display: flex; flex: 1; }
        .content { flex: 1; padding: 40px; background-color: #f4f7f6; overflow-y: auto; }
        .edit-card { background: white; padding: 40px; border-radius: 15px; max-width: 600px; margin: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        h2 { color: #005082; border-bottom: 2px solid #005082; padding-bottom: 10px; margin-bottom: 30px; }
        
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
        input { width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        .readonly-input { background-color: #eee; cursor: not-allowed; }
        
        /* 비밀번호 입력창 그룹 */
        .pw-group { position: relative; width: 100%; }
        .pw-group input { padding-right: 45px; margin-bottom: 5px; }
        .eye-btn { position: absolute; right: 12px; top: 12px; cursor: pointer; font-size: 18px; color: #666; user-select: none; }
        
        /* 알림 메시지 스타일 */
        .info-msg { font-size: 12px; margin-bottom: 15px; font-weight: bold; }
        
        .btn-save { width: 100%; padding: 15px; background: #4CAF50; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; }
        .btn-save:hover { background: #45a049; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="edit-card">
                <h2>👤 내 정보 수정</h2>
                <form action="/loginJoinProcess" method="post" id="editForm">
                    <label>아이디 (수정 불가)</label>
                    <input type="text" name="userId" value="${user.userId}" class="readonly-input" readonly>
                    
                    <label>이름</label>
                    <input type="text" name="userName" value="${user.userName}" required>
                    
                    <label>새 비밀번호 (변경 시에만 입력)</label>
                    <div class="pw-group">
                        <input type="password" id="pw" name="password" placeholder="새로운 비밀번호" onkeyup="checkPw()">
                        <span class="eye-btn" onclick="togglePw('pw', this)">👁️</span>
                    </div>
                    <div id="pwNotice" class="info-msg" style="color: #666;">보안강도: 미입력</div>
                    
                    <label>새 비밀번호 확인</label>
                    <div class="pw-group">
                        <input type="password" id="pwConfirm" placeholder="비밀번호 재입력" onkeyup="checkPw()">
                        <span class="eye-btn" onclick="togglePw('pwConfirm', this)">👁️</span>
                    </div>
                    <div id="pwMatch" class="info-msg"></div>

                    <label>비밀번호 찾기 힌트</label>
                    <input type="text" name="pwHint" value="${user.pwHint}" placeholder="비밀번호 찾기 힌트 (예: 내 보물 1호는?)">

                    <label>전화번호</label>
                    <input type="text" name="phone" value="${user.phone}" placeholder="010-0000-0000">
                    
                    <label>팩스</label>
                    <input type="text" name="fax" value="${user.fax}">
                    
                    <label>비고</label>
                    <input type="text" name="remarks" value="${user.remarks}">

                    <button type="submit" class="btn-save">수정 완료</button>
                </form>
            </div>
        </main>
    </div>

    <script>
        // 1. 비밀번호 보이기/숨기기 토글 함수
        function togglePw(inputId, btnElement) {
            const input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                btnElement.innerText = "🔒"; // 보일 때는 잠금 아이콘
            } else {
                input.type = "password";
                btnElement.innerText = "👁️"; // 숨길 때는 눈 아이콘
            }
        }

        // 2. 보안강도 및 일치 여부 실시간 체크 함수
        function checkPw() {
            const pw = document.getElementById('pw').value;
            const pw2 = document.getElementById('pwConfirm').value;
            const notice = document.getElementById('pwNotice');
            const match = document.getElementById('pwMatch');

            // 보안강도 체크
            if(pw === "") {
                notice.innerText = "보안강도: 미입력";
                notice.style.color = "#666";
            } else {
                // 영문, 숫자, 특수문자 포함 8자 이상 정규식
                const regex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})/;
                if (regex.test(pw)) {
                    notice.innerText = "보안강도: 아주 강력함 💪";
                    notice.style.color = "green";
                } else {
                    notice.innerText = "보안강도: 약함 (영문+숫자+특수문자 조합 8자 이상 권장)";
                    notice.style.color = "red";
                }
            }

            // 일치 여부 체크
            if(pw2 === "") {
                match.innerText = "";
            } else if (pw === pw2) {
                match.innerText = "✅ 비밀번호가 일치합니다.";
                match.style.color = "blue";
            } else {
                match.innerText = "❌ 비밀번호가 일치하지 않습니다.";
                match.style.color = "red";
            }
        }
    </script>

</body>
</html>