<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Theoros WQS - 프리미엄 분석 시스템</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/sidebar.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <style>
        :root { --nifs-blue: #1e3a8a; --nifs-light: #3b82f6; --bg-canvas: #f1f5f9; --ai-purple: #8b5cf6; }
        
        /* 전체 레이아웃: 헤더 고정 및 wrapper 구성 */
        /* body { 
            margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; 
            background-color: var(--bg-canvas); 
            display: flex; flex-direction: column;
            height: 100vh; overflow: hidden; 
        } */

        .wrapper { display: flex; flex: 1; overflow: hidden; }

        .content { 
            flex: 1; padding: 15px; margin-left: 10px; 
            display: flex; flex-direction: column; min-width: 0; box-sizing: border-box; 
            overflow-y: auto; /* 내용이 많아지면 내부 스크롤 */
        }
        
        .header-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; padding: 10px 25px; background: #fff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .header-area h2 { margin: 0; color: var(--nifs-blue); font-size: 22px; font-weight: 800; }

        .status-container { display: flex; align-items: center; gap: 10px; }
        .data-count-badge { font-size: 12px; color: #64748b; font-weight: 700; background: #f1f5f9; padding: 3px 12px; border-radius: 15px; border: 1px solid #e2e8f0; }

        .filter-bar { background: #fff; padding: 10px 20px; border-radius: 12px; margin-bottom: 12px; display: flex; align-items: center; gap: 12px; border: 1px solid #e2e8f0; }
        .filter-group { display: flex; align-items: center; gap: 8px; }
        .filter-group label { font-size: 13px; font-weight: 700; color: #475569; }
        select, input[type="date"] { padding: 6px 10px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 13px; font-weight: 600; outline: none; }

        .btn-group { display: flex; gap: 8px; }
        .btn-base { border: none; padding: 6px 18px; border-radius: 8px; cursor: pointer; font-weight: 800; font-size: 13px; transition: 0.2s; display: flex; align-items: center; gap: 5px; }
        .btn-lookup { background: var(--nifs-blue); color: white; }
        .btn-excel { background: #10b981; color: white; }
        .btn-ai { background: var(--ai-purple); color: white; animation: pulse 2s infinite; }
        .btn-base:hover { transform: translateY(-2px); filter: brightness(1.1); }

        @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(139, 92, 246, 0.4); } 70% { box-shadow: 0 0 0 10px rgba(139, 92, 246, 0); } 100% { box-shadow: 0 0 0 0 rgba(139, 92, 246, 0); } }

        .graph-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; flex: 1; min-height: 800px; /* 그래프 찌그러짐 방지 */ }
        .card { background: #fff; border-radius: 14px; padding: 12px 15px; border: 1px solid #e2e8f0; display: flex; flex-direction: column; min-height: 350px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .card-title { font-size: 14px; font-weight: 800; color: #1e293b; margin-bottom: 8px; display: flex; align-items: center; gap: 8px; }
        .card-title::before { content: ''; width: 4px; height: 14px; background: var(--nifs-blue); border-radius: 2px; }
        .full-width { grid-column: span 4; } .half-width { grid-column: span 2; }
        .chart-wrapper { flex: 1; position: relative; width: 100%; min-height: 0; }

        /* 모달 스타일 */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background: #fff; margin: 5vh auto; padding: 30px; border-radius: 20px; width: 60%; max-height: 85vh; overflow-y: auto; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); position: relative; }
        .close { position: absolute; right: 25px; top: 20px; font-size: 28px; cursor: pointer; color: #94a3b8; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>

        <div class="content">
            <div class="header-area">
                <h2>📈 과거 데이터 정밀 분석 시스템 <small style="font-size:12px; color:#94a3b8;">NIFS Standard Edition</small></h2>
                <div class="status-container">
                    <div id="dataCount" class="data-count-badge">검색된 분석데이터 : 0개</div>
                    <div id="dataStatus" style="font-size:12px; color:#3b82f6; font-weight:800; background:#eff6ff; padding:3px 12px; border-radius:15px;">분석 엔진 정상</div>
                </div>
            </div>

            <div class="filter-bar">
                <div class="filter-group"><label>📍 양식장</label>
                    <select id="farmSelect" onchange="updateTankList()">
                        <option value="">전체</option>
                        <c:forEach items="${farmList}" var="f"><option value="${f.farmId}">${f.farmName}</option></c:forEach>
                    </select>
                </div>
                <div class="filter-group"><label>🦐 수조</label><select id="tankSelect"><option value="">선택</option></select></div>
                <div class="filter-group"><label>📅 기간</label><input type="date" id="startDate"> ~ <input type="date" id="endDate"></div>
                
                <div class="btn-group">
                    <button class="btn-base btn-lookup" onclick="loadData()">🔍 분석 실행</button>
                    <button class="btn-base btn-excel" onclick="exportToExcel()">📊 엑셀 출력</button>
                    <button class="btn-base btn-ai" onclick="openAIReport()">🤖 AI 보고서</button>
                </div>
            </div>

            <div class="graph-grid">
                <div class="card full-width"><div class="card-title">🌐 종합 환경 시뮬레이션</div><div class="chart-wrapper"><canvas id="envChart"></canvas></div></div>
                <div class="card half-width"><div class="card-title">💧 수질 밸런스 정밀 분석</div><div class="chart-wrapper"><canvas id="waterChart"></canvas></div></div>
                <div class="card half-width"><div class="card-title">⚠️ 수조 독성 적산 리포트</div><div class="chart-wrapper"><canvas id="toxicChart"></canvas></div></div>
                <div class="card"><div class="card-title">🍴 급이량(g)</div><div class="chart-wrapper"><canvas id="feedChart"></canvas></div></div>
                <div class="card"><div class="card-title">☠️ 폐사 관리</div><div class="chart-wrapper"><canvas id="deadChart"></canvas></div></div>
                <div class="card"><div class="card-title">🧪 개선제 투입</div><div class="chart-wrapper"><canvas id="chemChart"></canvas></div></div>
                <div class="card"><div class="card-title">⚖️ 성장 곡선(g)</div><div class="chart-wrapper"><canvas id="weightChart"></canvas></div></div>
            </div>
        </div>
    </div>

    <div id="aiModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <div class="ai-header">
                <h2 style="margin:0; color:var(--ai-purple);">🤖 Theoros AI 수질 정밀 진단 보고서</h2>
                <p id="reportMeta" style="margin:5px 0 0 0; color:#64748b; font-weight:600;"></p>
            </div>
            </div>
    </div>

    <script>
        let charts = {};
        let currentData = null;
        const allTanks = [<c:forEach var="t" items="${tankList}" varStatus="vs">{ "id": "${t.tankId}", "name": "${t.tankName}", "farmId": "${t.farmId}" }${vs.last ? '' : ','}</c:forEach>];

        function updateTankList() {
            const farmId = document.getElementById('farmSelect').value;
            const tankSelect = document.getElementById('tankSelect');
            tankSelect.innerHTML = '<option value="">선택</option>';
            allTanks.filter(t => t.farmId == farmId).forEach(t => {
                const opt = document.createElement('option'); opt.value = t.name; opt.textContent = t.name; tankSelect.appendChild(opt);
            });
        }

        const commonOptions = {
            responsive: true, maintainAspectRatio: false,
            interaction: { mode: 'index', intersect: false },
            animation: { duration: 1200, easing: 'easeOutQuart' },
            plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, boxWidth: 6, font: { size: 12, weight: 'bold' } } } },
            scales: { y: { beginAtZero: true, grid: { color: '#f1f5f9' }, ticks: { font: { size: 12, weight: 'bold' } } }, x: { grid: { display: true, color: '#f1f5f9' }, ticks: { font: { size: 11, weight: 'bold' }, maxTicksLimit: 12 } } },
            elements: { line: { tension: 0.4, borderWidth: 3 } }
        };

        window.onload = function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').value = today; document.getElementById('endDate').value = today;
            initCharts();
        };

        function initCharts() {
            charts.env = new Chart(document.getElementById('envChart'), { type: 'line', data: { labels: [], datasets: [ { label: '수온', borderColor: '#ef4444', backgroundColor: '#ef444415', data: [], fill: true, pointRadius: 0 }, { label: '기온', borderColor: '#f59e0b', data: [], pointRadius: 0 }, { label: '습도', borderColor: '#3b82f6', data: [], pointRadius: 0 } ]}, options: commonOptions });
            charts.water = new Chart(document.getElementById('waterChart'), { type: 'line', data: { labels: [], datasets: [ { label: 'pH', borderColor: '#8b5cf6', data: [], pointRadius: 2 }, { label: 'DO', borderColor: '#0ea5e9', data: [] } ]}, options: commonOptions });
            charts.toxic = new Chart(document.getElementById('toxicChart'), { type: 'line', data: { labels: [], datasets: [ { label: '아질산', borderColor: '#f97316', backgroundColor: '#f97316aa', data: [], fill: true }, { label: 'TAN', borderColor: '#fbbf24', backgroundColor: '#fbbf24aa', data: [], fill: true } ]}, options: { ...commonOptions, scales: { ...commonOptions.scales, y: { stacked: true } } } });
            charts.feed = new Chart(document.getElementById('feedChart'), { type: 'bar', data: { labels: [], datasets: [{ label: '사료', backgroundColor: '#60a5fa', borderRadius: 5, data: [] }]}, options: commonOptions });
            charts.dead = new Chart(document.getElementById('deadChart'), { type: 'bar', data: { labels: [], datasets: [{ label: '폐사', backgroundColor: '#fb7185', borderRadius: 5, data: [] }]}, options: commonOptions });
            charts.chem = new Chart(document.getElementById('chemChart'), { type: 'bar', data: { labels: [], datasets: [ { label: '포도당', backgroundColor: '#c084fc', data: [] }, { label: '당밀', backgroundColor: '#818cf8', data: [] } ]}, options: { ...commonOptions, scales: { y: { stacked: true }, x: { ...commonOptions.scales.x, stacked: true } } } });
            charts.weight = new Chart(document.getElementById('weightChart'), { type: 'line', data: { labels: [], datasets: [{ label: '체중', borderColor: '#10b981', backgroundColor: '#10b981', data: [], pointRadius: 4 }]}, options: commonOptions });
        }

        function loadData() {
            const tank = document.getElementById('tankSelect').value; if(!tank) return;
            $.get("/getHistoryData", { tankName: tank, startDate: $('#startDate').val(), endDate: $('#endDate').val() }, function(res) {
                currentData = res;
                updateCharts(res);
                const sCount = res.sensor ? res.sensor.length : 0;
                const mCount = res.manual ? res.manual.length : 0;
                $('#dataCount').text("검색된 분석데이터 : " + (sCount + mCount) + "개");
            });
        }

        function updateCharts(data) {
            const s = data.sensor || []; const m = data.manual || [];
            const sL = s.map(i => i.regDate.substring(5, 13).replace('T', ' '));
            const mL = m.map(i => i.regDate.substring(5, 13).replace('T', ' '));
            charts.env.data.labels = sL; charts.env.data.datasets[0].data = s.map(i => i.waterTemp); charts.env.data.datasets[1].data = s.map(i => i.airTemp); charts.env.data.datasets[2].data = s.map(i => i.airHumid);
            charts.water.data.labels = sL; charts.water.data.datasets[0].data = s.map(i => i.ph); charts.water.data.datasets[1].data = s.map(i => i.doVal);
            charts.toxic.data.labels = mL; charts.toxic.data.datasets[0].data = m.map(i => i.nitrite); charts.toxic.data.datasets[1].data = m.map(i => i.tan);
            charts.feed.data.labels = mL; charts.feed.data.datasets[0].data = m.map(i => i.feedAmount);
            charts.dead.data.labels = mL; charts.dead.data.datasets[0].data = m.map(i => i.deathCount);
            charts.chem.data.labels = mL; charts.chem.data.datasets[0].data = m.map(i => i.glucoseInput); charts.chem.data.datasets[1].data = m.map(i => i.molassesInput);
            charts.weight.data.labels = mL; charts.weight.data.datasets[0].data = m.map(i => i.avgWeight);
            Object.values(charts).forEach(c => c.update());
        }

        function exportToExcel() {
            if(!currentData) { alert("먼저 데이터를 분석해주세요."); return; }
            const wb = XLSX.utils.book_new();
            const sensorWS = XLSX.utils.json_to_sheet(currentData.sensor);
            const manualWS = XLSX.utils.json_to_sheet(currentData.manual);
            XLSX.utils.book_append_sheet(wb, sensorWS, "센서데이터");
            XLSX.utils.book_append_sheet(wb, manualWS, "수기데이터");
            XLSX.writeFile(wb, "Theoros_Analysis_" + $('#tankSelect').val() + ".xlsx");
        }

        // [AQC 연동] 상단 설정값들을 모든 수조에 일괄 적용하여 저장
        function saveGlobalLimits() {
            const limitData = {
                tempMin: $("#tempMin").val(), tempMax: $("#tempMax").val(),
                doLimit: $("#doLimit").val(), phMin: $("#phMin").val(),
                phMax: $("#phMax").val(), nh3Limit: $("#nh3Limit").val()
            };
            const tankIds = [<c:forEach var="t" items="${tankList}" varStatus="vs">${t.tankId}${!vs.last ? ',' : ''}</c:forEach>];
            if(!confirm("설정한 한계치를 모든 수조에 일괄 적용하시겠습니까?")) return;
            let completed = 0;
            tankIds.forEach(id => {
                const payload = { ...limitData, tankId: id, monitorStatus: 'START' };
                $.ajax({
                    url: "/aqc/saveLimits", type: "POST", contentType: "application/json",
                    data: JSON.stringify(payload),
                    success: function() {
                        completed++;
                        if(completed === tankIds.length) { alert("한계치 설정 완료"); location.reload(); }
                    }
                });
            });
        }
        function closeModal() { $('#aiModal').fadeOut(200); }
    </script>
</body>
</html>