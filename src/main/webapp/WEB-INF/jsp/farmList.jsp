<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 양식장 관리</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; display: flex; flex-direction: column; height: 100vh; }
        .wrapper { display: flex; flex: 1; }
        .content { flex: 1; padding: 30px; background-color: #f4f7f6; overflow-y: auto; }
        
        .card { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        h2 { color: #005082; border-bottom: 2px solid #005082; padding-bottom: 10px; margin-bottom: 20px; }

        .btn-add { background: #005082; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; float: right; font-weight: bold; }
        
        .farm-table { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; font-size: 13px; }
        .farm-table th { background: #f8f9fa; color: #333; padding: 10px 5px; border-bottom: 2px solid #eee; white-space: nowrap; }
        .farm-table td { padding: 10px 5px; text-align: center; border-bottom: 1px solid #eee; cursor: pointer; }
        .farm-table tr:hover { background-color: #f1f8ff; }
        .selected-row { background-color: #e3f2fd !important; font-weight: bold; }

        #detailPanel { display: none; margin-top: 25px; padding: 25px; background: #fff; border: 2px solid #005082; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .btn-group button { padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; color: white; margin-left: 5px; }
        .btn-tank { background: #2ecc71; }
        .btn-edit { background: #f39c12; }
        .btn-delete { background: #e74c3c; }

        .tank-list-wrapper { width: 100%; overflow-x: auto; margin-top: 10px; }
        .tank-header { display: flex; align-items: center; margin-top: 20px; color: #333; }
    </style>
</head>
<body onclick="checkClickOutside(event)">
    <%@ include file="header.jsp" %>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <main class="content">
            <div class="card">
                <button class="btn-add" onclick="openRegPopup()">+ 새 양식장 등록</button>
                <h2>🏗️ 양식장 관리 목록</h2>
                
                <table class="farm-table" id="farmTable">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>양식장 이름</th>
                            <th>구조</th>
                            <th>품종</th>
                            <th>면적(평)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="f" items="${farms}">
                            <tr onclick="showDetail(event, this, '${f.farmId}', '${f.farmName}', '${f.farmAddress} ${f.farmAddressDetail}', '${f.farmStructure}', '${f.farmType}', '${f.farmSize}')">
                                <td>${f.farmId}</td>
                                <td>${f.farmName}</td>
                                <td>${f.farmStructure}</td>
                                <td>${f.farmType}</td>
                                <td>${f.farmSize}평</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div id="detailPanel" onclick="event.stopPropagation()">
                    <div class="panel-header">
                        <div class="panel-info">
                            <h3 id="dName" style="margin:0 0 10px 0; color:#005082;"></h3>
                            <p>📍 주소: <span id="dAddr"></span></p>
                            <p>🏗️ 구조: <span id="dStr"></span> | 📏 면적: <span id="dSize"></span>평</p>
                        </div>
                        <div class="btn-group">
                            <button class="btn-tank" onclick="openTankReg()">➕ 수조 등록</button>
                            <button class="btn-edit" onclick="editFarm()">수정</button>
                            <button class="btn-delete" onclick="deleteFarm()">삭제</button>
                        </div>
                    </div>
                    
                    <div class="tank-header">
                        <h4>💧 소속 수조 상세 목록</h4>
                    </div>

                    <div class="tank-list-wrapper">
                        <table class="farm-table" id="tankTable">
                            <thead>
                                <tr>
                                    <th>수조명</th>
                                    <th>해산물</th>
                                    <th>규격(가로x세로x높이)</th>
                                    <th>물높이</th>
                                    <th>담수량</th>
                                    <th>장비번호</th>
                                    <th>입식단계</th>
                                    <th>입식밀도(평)</th>
                                    <th>총마리수</th>
                                    <th>총무게(kg)</th>
                                    <th>평균무게(g)</th>
                                    <th>입식일자</th>
                                    <th>종자(공급/종류/번호)</th>
                                    <th>사료(회사/이름)</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="tankListBody">
                                </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        let selectedFarmId = null;

        function openRegPopup() {
            window.open('/farmReg', 'regPopup', 'width=600,height=800,left=500,top=100');
        }

        function showDetail(e, row, id, name, addr, str, type, size) {
            e.stopPropagation(); 
            selectedFarmId = id;
            document.querySelectorAll('tr').forEach(r => r.classList.remove('selected-row'));
            row.classList.add('selected-row');
            document.getElementById('detailPanel').style.display = 'block';
            document.getElementById('dName').innerText = name;
            document.getElementById('dAddr').innerText = addr;
            document.getElementById('dStr').innerText = str;
            document.getElementById('dSize').innerText = size;

            loadTanks(id);
        }

        function loadTanks(farmId) {
            fetch('/tankList?farmId=' + farmId)
            .then(res => res.json())
            .then(data => {
                let html = "";
                if (data.length > 0) {
                    data.forEach(t => {
                        // 날짜 포맷 (YYYY-MM-DD)
                        const sDate = t.stockingDate ? t.stockingDate : '-';
                        
                        html += `<tr>
                            <td style="font-weight:bold; color:#005082;">\${t.tankName}</td>
                            <td>\${t.species || '-'}</td>
                            <td>\${t.widthM}m x \${t.lengthM}m x \${t.heightM}m</td>
                            <td>\${t.waterLevelM}m</td>
                            <td style="color:#2980b9; font-weight:bold;">\${t.waterVolumeTon}t</td>
                            <td style="color:#e67e22; font-weight:bold;">\${t.deviceNo || '-'}</td>
                            <td>\${t.culturePhase || '-'}</td>
                            <td>\${(t.stockingDensityActual || 0).toLocaleString()}</td>
                            <td>\${(t.totalCount || 0).toLocaleString()}</td>
                            <td>\${t.totalWeightKg || 0}</td>
                            <td style="color:#27ae60; font-weight:bold;">\${t.weightPerPiece || 0}g</td>
                            <td>\${sDate}</td>
                            <td>\${t.supplier || '-'}/\${t.seedSpecies || '-'}/\${t.seedNo || '-'}</td>
                            <td>\${t.feedCompany || '-'}/\${t.feedName || '-'}</td>
                            <td>
                                <div style="display:flex; gap:2px;">
                                <button class="btn-edit" style="padding:2px 5px; font-size:10px;" onclick="editTank(\${t.tankId})">수정</button>
                                <button class="btn-delete" style="padding:2px 5px; font-size:10px;" onclick="deleteTank(\${t.tankId})">삭제</button>
                                </div>
                            </td>
                        </tr>`;
                    });
                } else {
                    html = '<tr><td colspan="15" style="padding:30px; color:#999;">등록된 수조가 없습니다.</td></tr>';
                }
                document.getElementById('tankListBody').innerHTML = html;
            });
        }

        function checkClickOutside(e) {
            const panel = document.getElementById('detailPanel');
            const table = document.getElementById('farmTable');
            if (!table.contains(e.target) && !panel.contains(e.target)) {
                panel.style.display = 'none';
                document.querySelectorAll('tr').forEach(r => r.classList.remove('selected-row'));
            }
        }

        function openTankReg() {
            if(!selectedFarmId) return alert("양식장을 선택해주세요.");
            window.open('/tankReg?farmId=' + selectedFarmId, 'tankPopup', 'width=850,height=900');
        }

        function deleteFarm() {
            if(confirm("이 양식장과 모든 수조 정보가 삭제됩니다. 계속하시겠습니까?")) {
                fetch('/farmDelete?farmId=' + selectedFarmId, { method: 'POST' })
                .then(res => res.text()).then(data => { if(data === "SUCCESS") location.reload(); });
            }
        }
        
        function editFarm() {
            window.open('/farmReg?farmId=' + selectedFarmId, 'editPopup', 'width=600,height=800');
        }

        function editTank(tankId) {
            window.open('/tankReg?farmId=' + selectedFarmId + '&tankId=' + tankId, 'tankEditPopup', 'width=850,height=900');
        }

        function deleteTank(tankId) {
            if(confirm("이 수조 정보를 영구 삭제하시겠습니까?")) {
                fetch('/tankDelete?tankId=' + tankId, { method: 'POST' })
                .then(res => res.text())
                .then(data => {
                    if(data === "SUCCESS") {
                        alert("삭제되었습니다.");
                        loadTanks(selectedFarmId); // 목록 새로고침
                    }
                });
            }
        }








    </script>
</body>
</html>