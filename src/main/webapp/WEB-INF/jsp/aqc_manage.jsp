<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Theoros AQC - 통합 품질 관제 시스템</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/sidebar.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root { --nifs-blue: #1e3a8a; --danger: #ef4444; --success: #10b981; --bg: #f1f5f9; }
        /* body { margin: 0; display: flex; flex-direction: column; background: var(--bg); font-family: 'Pretendard', sans-serif; height: 100vh; overflow: hidden; font-size: 15px; } */
        
        /* 레이아웃 구조 */
        .wrapper { display: flex; flex: 1; overflow: hidden; width: 100%; }
        .content { flex: 1; padding: 20px; display: flex; flex-direction: column; gap: 20px; overflow-y: auto; box-sizing: border-box; }
        
        /* 섹션 카드 디자인 */
        .section-card { 
            background: #fff; border-radius: 12px; padding: 25px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; 
            width: 100%; box-sizing: border-box; 
        }
        .section-title { font-size: 17px; font-weight: 800; color: var(--nifs-blue); margin-bottom: 20px; border-bottom: 2px solid var(--nifs-blue); padding-bottom: 10px; display: flex; justify-content: space-between; align-items: center; }

        /* [1] 상단 설정 테이블 스타일 */
        .limit-table { width: 100%; border-collapse: collapse; table-layout: auto; font-size: 13px; }
        .limit-table th { background: #f8fafc; padding: 8px 10px; border: 1px solid #e2e8f0; font-weight: 800; white-space: nowrap; }
        .limit-table td { padding: 8px 10px; border: 1px solid #e2e8f0; text-align: center; }
        .limit-table input { width: 65px; padding: 6px 0; border: 1px solid #cbd5e1; border-radius: 4px; text-align: center; font-weight: 700; }
        input[type="number"]::-webkit-outer-spin-button, input[type="number"]::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

        /* [2] 양식장 가로 배치 레이아웃 */
        .farms-wrapper { display: flex; flex-wrap: wrap; gap: 20px; width: 100%; }
        .farm-container { 
            flex: 0 0 calc(33.333% - 14px); 
            min-width: 400px; background: #fdfdfd; border: 1px solid #dee2e6; border-radius: 10px; padding: 15px; box-sizing: border-box;
        }
        .farm-header { font-size: 16px; font-weight: 800; color: #334155; margin-bottom: 10px; }
        
        .control-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e2e8f0; }
        .control-table th { background: #f1f5f9; padding: 6px; border: 1px solid #e2e8f0; font-size: 14px; }
        .control-table td { padding: 4px 10px; border: 1px solid #e2e8f0; text-align: center; height: 35px; }
        .col-tank { width: 150px; font-weight: 800; color: var(--nifs-blue); }

        /* 토글 스위치 */
        .switch { position: relative; display: inline-block; width: 46px; height: 22px; vertical-align: middle; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 22px; }
        .slider:before { position: absolute; content: ""; height: 16px; width: 16px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: var(--nifs-blue); }
        input:checked + .slider:before { transform: translateX(24px); }

        /* 버튼 및 필터 */
        .btn-lookup { background: #1e293b; color: white; border: none; padding: 8px 20px; border-radius: 4px; cursor: pointer; font-weight: 700; }
        .btn-filter { background: #f1f3f5; border: 1px solid #ced4da; padding: 4px 10px; border-radius: 4px; font-size: 12px; cursor: pointer; font-weight: bold; }
        .filter-area { background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e2e8f0; display: flex; flex-wrap: wrap; gap: 20px; align-items: flex-end; }
        
        .val-error { color: var(--danger); font-weight: 800; background: #fff1f2; }

        /* 모달 */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; }
        .modal-content { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #fff; padding: 30px; border-radius: 15px; width: 450px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); }
        .filter-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin: 20px 0; }
        .filter-item { display: flex; align-items: center; gap: 10px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        
        <main class="content" id="mainContent">
            <%-- 상단 설정 창 --%>
            <div class="section-card">
                <div class="section-title">
                    <span>실시간 수질 관리 기준치 통합 설정</span>
                    <button class="btn-filter" onclick="openFilter()">⚙️ 항목 필터 설정</button>
                </div>
                <table class="limit-table">
                    <thead>
                        <tr>
                            <th class="col-tempMin">수온 최소</th><th class="col-tempMax">수온 최대</th>
                            <th class="col-doLimit">DO 최소</th><th class="col-phMin">pH 최소</th>
                            <th class="col-phMax">pH 최대</th><th class="col-nh3Limit">NH3 최대</th>
                            <th class="col-no2Limit">NO2 최대</th><th class="col-alkLimit">알칼리 최소</th>
                            <th class="col-salLimit">염분 최소</th><th class="col-salMax">염분 최대</th>
                            <th class="col-ssLimit">투명도 최대</th>
                            <th width="80">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="col-tempMin"><input type="number" id="tempMin" step="0.1"></td>
                            <td class="col-tempMax"><input type="number" id="tempMax" step="0.1"></td>
                            <td class="col-doLimit"><input type="number" id="doLimit" step="0.1"></td>
                            <td class="col-phMin"><input type="number" id="phMin" step="0.1"></td>
                            <td class="col-phMax"><input type="number" id="phMax" step="0.1"></td>
                            <td class="col-nh3Limit"><input type="number" id="nh3Limit" step="0.01"></td>
                            <td class="col-no2Limit"><input type="number" id="no2Limit" step="0.01"></td>
                            <td class="col-alkLimit"><input type="number" id="alkLimit" step="1"></td>
                            <td class="col-salLimit"><input type="number" id="salLimit" step="1"></td>
                            <td class="col-salMax"><input type="number" id="salMax" step="1"></td>
                            <td class="col-ssLimit"><input type="number" id="ssLimit" step="1"></td>
                            <td><button class="btn-lookup" style="width:100%; padding:6px 0;" onclick="saveGlobalLimits()">저장</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <%-- 양식장 관제 테이블 --%>
            <div class="section-card">
                <div class="section-title">양식장별 장비 수집 관제 시스템</div>
                <div class="farms-wrapper">
                    <c:forEach var="farm" items="${farmList}">
                        <div class="farm-container">
                            <div class="farm-header">📍 ${farm.farmName}</div>
                            <table class="control-table">
                                <thead>
                                    <tr><th width="60">순번</th><th class="col-tank">수조명</th><th width="120">현재 상태</th><th width="100">수집 제어</th></tr>
                                </thead>
                                <tbody>
                                    <c:set var="idx" value="1" />
                                    <c:forEach var="tank" items="${tankList}">
                                        <c:if test="${tank.farmId == farm.farmId}">
                                            <tr>
                                                <td>${idx}</td><td class="col-tank">${tank.tankName}</td>
                                                <td><c:set var="tid" value="${tank.tankId}" />
                                                    <span id="txt_${tid}" style="font-size:12px; font-weight:800; color:${limitMap[tid].monitorStatus == 'STOP' ? 'var(--danger)' : 'var(--success)'}">
                                                        ${limitMap[tid].monitorStatus == 'STOP' ? 'OFFLINE' : 'ONLINE'}
                                                    </span>
                                                </td>
                                                <td><label class="switch"><input type="checkbox" id="tog_${tid}" onchange="handleToggle(${tid})" ${limitMap[tid].monitorStatus != 'STOP' ? 'checked' : ''}><span class="slider"></span></label></td>
                                            </tr>
                                            <c:set var="idx" value="${idx + 1}" />
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <%-- 이상 탐지 조회 테이블 --%>
            <div class="section-card" id="anomalySection">
                <div class="section-title">🚨 수질 기준치 이탈 및 실시간 이상 탐지</div>
                
                <div class="filter-area">
                    <div style="display: flex; flex-direction: column; gap: 5px;">
                        <label style="font-size: 13px; font-weight: 800; color: #475569;">양식장 선택</label>
                        <select id="searchFarm" style="width: 180px; padding: 8px; border-radius: 4px; border: 1px solid #cbd5e1; font-weight: bold;" onchange="updateTankOptions()">
                            <option value="all">전체 양식장</option>
                            <c:forEach var="farm" items="${farmList}"><option value="${farm.farmId}">${farm.farmName}</option></c:forEach>
                        </select>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 5px;">
                        <label style="font-size: 13px; font-weight: 800; color: #475569;">수조 선택</label>
                        <select id="searchTank" style="width: 150px; padding: 8px; border-radius: 4px; border: 1px solid #cbd5e1; font-weight: bold;">
                            <option value="all">전체 수조</option>
                        </select>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 5px;">
                        <label style="font-size: 13px; font-weight: 800; color: #475569;">조회 기간</label>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <input type="date" id="startDate" style="padding: 7px; border: 1px solid #cbd5e1; border-radius: 4px; font-weight: bold;">
                            <span style="font-weight: bold; color: #64748b;">~</span>
                            <input type="date" id="endDate" style="padding: 7px; border: 1px solid #cbd5e1; border-radius: 4px; font-weight: bold;">
                        </div>
                    </div>
                    <button class="btn-lookup" style="background: var(--nifs-blue); height: 38px;" onclick="lookupAnomaly()">🔍 이상 수치 조회</button>
                </div>

                <table class="control-table" style="width: 100%;">
                    <thead>
                        <tr style="background: #f1f5f9;">
                            <th width="150">양식장명</th>
                            <th width="180">발생수조 (장비번호)</th>
                            <th width="180">발생일시</th>
                            <th width="130">이상 항목</th>
                            <th width="100">현재 측정값</th>
                            <th width="120">설정 기준치</th>
                            <th width="100">상태</th>
                            <th width="120">관리/조치</th>
                        </tr>
                    </thead>
                    <tbody id="anomalyBody">
                        <c:choose>
                            <c:when test="${not empty anomalyList}">
                                <c:forEach var="a" items="${anomalyList}">
                                    <tr>
                                        <td>${a.farmName}</td>
                                        <td style="font-weight: 800; color: var(--nifs-blue);">
                                            <%-- 🛠️ 수정 포인트: 수조명과 장비번호를 함께 표시 --%>
                                            ${a.tankName}
                                        </td>
                                        <td>${a.regDate}</td>
                                        <td style="color: var(--danger); font-weight: 800;">${a.itemName}</td>
                                        <td class="val-error">${a.currVal}</td>
                                        <td>${a.limitVal}</td>
                                        <td><span style="color: var(--danger); font-weight: 800;">수치 이탈</span></td>
                                        <td>
                                            <button class="btn-filter" style="padding:2px 8px;" onclick="editVal('${a.id}')">수정</button> 
                                            <button class="btn-filter" style="padding:2px 8px;" onclick="delVal('${a.id}')">삭제</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" style="padding: 40px; color: #94a3b8; font-weight: bold;">조회된 이상 데이터가 없습니다.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <%-- 항목 필터 모달 --%>
    <div id="filterModal" class="modal-overlay">
        <div class="modal-content">
            <h2 style="margin-top:0; color:var(--nifs-blue);">노출할 수질 항목 선택</h2>
            <div class="filter-grid" id="filterGrid"></div>
            <div style="text-align: right; border-top: 1px solid #eee; padding-top: 20px;">
                <button class="btn-lookup" style="background:var(--nifs-blue);" onclick="saveFilterSettings()">설정 적용</button>
                <button class="btn-filter" style="padding:10px 20px;" onclick="closeFilter()">닫기</button>
            </div>
        </div>
    </div>

    <script>
        const fieldList = [
            { id: 'tempMin', name: '수온 최소' }, { id: 'tempMax', name: '수온 최대' },
            { id: 'doLimit', name: 'DO 최소' }, { id: 'phMin', name: 'pH 최소' },
            { id: 'phMax', name: 'pH 최대' }, { id: 'nh3Limit', name: 'NH3 최대' },
            { id: 'no2Limit', name: 'NO2 최대' }, { id: 'alkLimit', name: '알칼리 최소' },
            { id: 'salLimit', name: '염분 최소' }, { id: 'salMax', name: '염분 최대' },
            { id: 'ssLimit', name: '투명도 최대' }
        ];

        window.onload = function() {
            applyFilters();
            
            // 날짜/필터 복구
            const sFarm = "${farmId}";
            const sTank = "${tankId}";
            const sStart = "${startDate}";
            const sEnd = "${endDate}";

            if(sStart) $("#startDate").val(sStart);
            else $("#startDate").val(new Date().toISOString().substring(0, 10));
            
            if(sEnd) $("#endDate").val(sEnd);
            else $("#endDate").val(new Date().toISOString().substring(0, 10));

            if(sFarm) {
                $("#searchFarm").val(sFarm);
                updateTankOptions(); 
                if(sTank) $("#searchTank").val(sTank);
            }

            // 스크롤 복구
            const scrollY = sessionStorage.getItem("lastScrollY");
            if (scrollY) { document.getElementById('mainContent').scrollTop = scrollY; sessionStorage.removeItem("lastScrollY"); }

            // 상단 리미트 세팅
            <c:if test="${not empty limitMap}">
                <c:set var="firstId" value="${tankList[0].tankId}" />
                $("#tempMin").val("${limitMap[firstId].tempMin}");
                $("#tempMax").val("${limitMap[firstId].tempMax}");
                $("#doLimit").val("${limitMap[firstId].doLimit}");
                $("#phMin").val("${limitMap[firstId].phMin}");
                $("#phMax").val("${limitMap[firstId].phMax}");
                $("#nh3Limit").val("${limitMap[firstId].nh3Limit}");
                $("#no2Limit").val("${limitMap[firstId].no2Limit}");
                $("#alkLimit").val("${limitMap[firstId].alkLimit}");
                $("#salLimit").val("${limitMap[firstId].salLimit}");
                $("#salMax").val("${limitMap[firstId].salMax}");
                $("#ssLimit").val("${limitMap[firstId].ssLimit}");
            </c:if>
        };

        const allTanksForSearch = [
            <c:forEach var="t" items="${tankList}" varStatus="vs">
                { id: "${t.tankId}", name: "${t.tankName}", farmId: "${t.farmId}" }${!vs.last ? ',' : ''}
            </c:forEach>
        ];

        function updateTankOptions() {
            const farmId = $("#searchFarm").val();
            const tankSelect = document.getElementById('searchTank');
            tankSelect.innerHTML = '<option value="all">전체 수조</option>';
            allTanksForSearch.forEach(tank => {
                if (farmId === 'all' || String(tank.farmId) === String(farmId)) {
                    const opt = document.createElement('option');
                    opt.value = tank.id; opt.textContent = tank.name;
                    tankSelect.appendChild(opt);
                }
            });
        }

        function lookupAnomaly() {
            sessionStorage.setItem("lastScrollY", document.getElementById('mainContent').scrollTop);
            const farm = $("#searchFarm").val();
            const tank = $("#searchTank").val();
            const start = $("#startDate").val();
            const end = $("#endDate").val();
            location.href = "/aqc/manage?farmId=" + farm + "&tankId=" + tank + "&startDate=" + start + "&endDate=" + end;
        }

        function openFilter() {
            const grid = document.getElementById('filterGrid');
            grid.innerHTML = ''; 
            const savedConfig = JSON.parse(localStorage.getItem('aqc_filter_config') || '{}');
            fieldList.forEach(item => {
                const isChecked = savedConfig[item.id] !== false;
                const label = document.createElement('label');
                label.className = 'filter-item';
                const input = document.createElement('input');
                input.type = 'checkbox'; input.className = 'filter-chk'; input.value = item.id;
                if(isChecked) input.checked = true;
                const span = document.createElement('span'); span.innerText = item.name;
                label.appendChild(input); label.appendChild(span); grid.appendChild(label);
            });
            $("#filterModal").show();
        }

        function closeFilter() { $("#filterModal").hide(); }

        function saveFilterSettings() {
            const newConfig = {};
            $(".filter-chk").each(function() { newConfig[$(this).val()] = $(this).is(":checked"); });
            localStorage.setItem('aqc_filter_config', JSON.stringify(newConfig));
            applyFilters(); closeFilter();
        }

        function applyFilters() {
            const config = JSON.parse(localStorage.getItem('aqc_filter_config') || '{}');
            fieldList.forEach(item => {
                const isVisible = config[item.id] !== false;
                isVisible ? $(".col-" + item.id).show() : $(".col-" + item.id).hide();
            });
        }

        function handleToggle(tankId) {
            const isChecked = $("#tog_" + tankId).is(":checked");
            $.post("/aqc/toggleStatus", { tankId: tankId, status: isChecked ? 'START' : 'STOP' }, function() {
                const txt = $("#txt_" + tankId);
                isChecked ? txt.text("ONLINE").css("color", "var(--success)") : txt.text("OFFLINE").css("color", "var(--danger)");
            });
        }

        function saveGlobalLimits() {
            const data = {
                tempMin: $("#tempMin").val(), tempMax: $("#tempMax").val(),
                doLimit: $("#doLimit").val(), phMin: $("#phMin").val(), phMax: $("#phMax").val(),
                nh3Limit: $("#nh3Limit").val(), no2Limit: $("#no2Limit").val(),
                alkLimit: $("#alkLimit").val(), salLimit: $("#salLimit").val(),
                salMax: $("#salMax").val(), ssLimit: $("#ssLimit").val()
            };
            const tankIds = [<c:forEach var="t" items="${tankList}" varStatus="vs">${t.tankId}${!vs.last ? ',' : ''}</c:forEach>];
            if(!confirm("모든 수조의 설정값을 업데이트 하시겠습니까?")) return;
            sessionStorage.setItem("lastScrollY", document.getElementById('mainContent').scrollTop);
            let count = 0;
            tankIds.forEach(id => {
                $.ajax({
                    url: "/aqc/saveLimits", type: "POST", contentType: "application/json",
                    data: JSON.stringify({ ...data, tankId: id, monitorStatus: 'START' }),
                    success: function() {
                        count++;
                        if(count === tankIds.length) { alert("일괄 저장 완료"); location.reload(); }
                    }
                });
            });
        }
    </script>
</body>
</html>