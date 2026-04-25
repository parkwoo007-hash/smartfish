<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        .join-box { width: 450px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; }
        input, textarea { width: 95%; padding: 8px; margin: 5px 0; }
        .strength { font-size: 12px; font-weight: bold; }
        .btn-group { display: flex; gap: 10px; margin-top: 20px; }
        .btn-save { background: #4CAF50; color: white; flex: 1; padding: 10px; border: none; cursor: pointer; }
        .btn-cancel { background: #f44336; color: white; flex: 1; padding: 10px; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <div class="join-box">
        <h2>회원가입</h2>
        <form action="/loginJoinProcess" method="post" id="joinForm">
            <input type="text" name="userName" placeholder="이름" required>
            <input type="text" name="userId" placeholder="아이디" required>
            
            <input type="password" id="pw" name="password" placeholder="비밀번호 (영문+숫자+기호, 8자 이상)" onkeyup="checkPw()" required>
            <div id="pwNotice" class="strength">보안강도: 대기중</div>
            
            <input type="password" id="pwConfirm" placeholder="비밀번호 확인" onkeyup="checkPw()">
            <div id="pwMatch" style="font-size:12px;"></div>

            <input type="text" name="phone" placeholder="전화번호 (예: 010-0000-0000)" required>
            
            <input type="text" id="address" name="address" placeholder="집주소" readonly onclick="findAddr()">
            <input type="text" name="fax" placeholder="팩스">
            <textarea name="remarks" placeholder="비고"></textarea>

            <div class="btn-group">
                <button type="submit" class="btn-save">회원가입</button>
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>

    <script>
        function checkPw() {
            const pw = document.getElementById('pw').value;
            const pw2 = document.getElementById('pwConfirm').value;
            const notice = document.getElementById('pwNotice');
            const match = document.getElementById('pwMatch');

            // 보안강도 체크 (정규식)
            const regex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})/;
            if (regex.test(pw)) { notice.innerText = "보안강도: 강력"; notice.style.color = "green"; }
            else { notice.innerText = "보안강도: 약함 (영문+숫자+기호 조합 8자 이상 필요)"; notice.style.color = "red"; }

            // 비번 확인 체크
            if (pw === pw2) { match.innerText = "비밀번호가 일치합니다."; match.style.color = "blue"; }
            else { match.innerText = "비밀번호가 틀립니다."; match.style.color = "red"; }
        }

        function findAddr() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById("address").value = data.address;
                }
            }).open();
        }
    </script>
</body>
</html>