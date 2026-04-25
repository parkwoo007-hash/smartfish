<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>양식장 정보 등록/수정</title>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background: #f4f7f6; padding: 20px; }
        .reg-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { color: #005082; text-align: center; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 15px; background: #005082; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; }
        #farmAddress { cursor: pointer; background: #eee; }
    </style>
</head>
<body>
    <div class="reg-card">
        <h2>🏗️ ${empty farm.farmId ? '신규 양식장 등록' : '양식장 정보 수정'}</h2>
        
        <form id="regForm">
            <input type="hidden" name="farmId" value="${farm.farmId}">

            <label>양식장 이름</label>
            <input type="text" name="farmName" value="${farm.farmName}" placeholder="양식장 이름을 입력하세요" required>
            
            <label>소재지 주소 (클릭 검색)</label>
            <input type="text" id="farmAddress" name="farmAddress" value="${farm.farmAddress}" onclick="searchAddr()" readonly required>
            
            <label>상세 주소</label>
            <input type="text" id="farmAddressDetail" name="farmAddressDetail" value="${farm.farmAddressDetail}" placeholder="상세 주소를 입력하세요">
            
            <label>총면적 (평)</label>
            <input type="number" name="farmSize" value="${farm.farmSize}" step="0.1" required>
            
            <label>양식장 구조</label>
            <select name="farmStructure" required>
                <option value="축제식" ${farm.farmStructure == '축제식' ? 'selected' : ''}>축제식 (노지)</option>
                <option value="하우스" ${farm.farmStructure == '하우스' ? 'selected' : ''}>하우스 (시설)</option>
                <option value="혼합형" ${farm.farmStructure == '혼합형' ? 'selected' : ''}>혼합형</option>
            </select>
            
            <label>주요 양식 품종</label>
            <input type="text" name="farmType" value="${farm.farmType}" placeholder="예: 흰다리새우">
            
            <button type="button" class="btn-submit" onclick="doRegister()">
                ${empty farm.farmId ? '등록 완료' : '수정 완료'}
            </button>
        </form>
    </div>

    <script>
        function searchAddr() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                    document.getElementById("farmAddress").value = addr;
                    document.getElementById("farmAddressDetail").focus();
                }
            }).open();
        }

        function doRegister() {
            const formData = new URLSearchParams(new FormData(document.getElementById('regForm')));
            fetch('/farmRegProcess', {
                method: 'POST',
                body: formData
            })
            .then(res => res.text())
            .then(data => {
                if(data === "SUCCESS") {
                    alert("처리되었습니다.");
                    window.opener.location.reload(); 
                    window.close(); 
                }
            });
        }
    </script>
</body>
</html>