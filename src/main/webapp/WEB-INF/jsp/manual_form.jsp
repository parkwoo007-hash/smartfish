<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theoros WQS - 수기 기록 통합 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/sidebar.css">
    <style>
        /* body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f0f4f8; display: flex; flex-direction: column; height: 100vh; font-size: 15px; color: #333; } */
        .wrapper { display: flex; flex: 1; overflow: hidden; }
        .content { flex: 1; padding: 15px; overflow-y: auto; }
        .container { max-width: 1650px; margin: auto; background: white; padding: 20px 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        h2 { color: #005082; border-left: 6px solid #005082; padding-left: 15px; margin-bottom: 20px; font-size: 22px; letter-spacing: -1px; }
        
        .input-card { background: #fcfcfc; padding: 12px 18px; border-radius: 10px; border: 1px solid #dee2e6; margin-bottom: 15px; transition: 0.3s; }
        .edit-mode { background: #fff9db !important; border: 1px solid #fab005 !important; }

        .section-title { font-size: 16px; font-weight: bold; color: #005082; margin-bottom: 10px; padding-bottom: 3px; border-bottom: 2px solid #005082; display: flex; align-items: center; gap: 6px; }
        
        .btn-config { padding: 2px 8px; font-size: 12px; background: #f1f3f5; border: 1px solid #ced4da; border-radius: 4px; cursor: pointer; margin-left: auto; font-weight: bold; color: #555; }
        .btn-config:hover { background: #e9ecef; }

        .form-grid { display: flex; flex-wrap: wrap; gap: 8px 12px; margin-bottom: 12px; align-items: flex-end; }
        .form-group { display: flex; flex-direction: column; gap: 4px; }
        .form-group label { font-size: 15px; font-weight: bold; color: #555; white-space: nowrap; }
        
        .form-group input, .form-group select { 
            padding: 4px 8px; border: 1px solid #ccc; border-radius: 3px; font-size: 15px; 
            height: 34px; box-sizing: border-box; background-color: #fff; font-weight: 500;
        }

        .num-input { width: 85px; text-align: right; }
        .calc-input { width: 95px; text-align: center; background-color: #f8f9fa !important; color: #e74c3c; font-weight: bold; border: 1px dashed #e74c3c !important; font-size: 14px; }
        .text-input { width: 120px; }
        .select-input { width: 140px; }
        .date-input { width: 220px; }
        .remarks-input { width: 450px; }

        .save-btn-bottom { height: 36px; min-width: 110px; background: #005082; color: white; border: none; border-radius: 3px; cursor: pointer; font-weight: bold; font-size: 15px; transition: 0.2s; margin-top: 5px; }
        .btn-cancel { height: 36px; background: #888; color: white; border: none; border-radius: 3px; cursor: pointer; padding: 0 15px; margin-left: 5px; font-weight: bold; }
        .btn-now { padding: 0 12px; height: 34px; background: #e67e22; color: white; border: none; border-radius: 3px; cursor: pointer; font-weight: bold; font-size: 14px; }

        .table-section { border-top: 1px solid #ddd; padding-top: 15px; }
        .table-scroll { max-height: 420px; overflow-y: auto; border: 1px solid #eee; width: 100%; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; min-width: 1600px; }
        th { background: #f8f9fa; padding: 8px 3px; border: 1px solid #eee; position: sticky; top: 0; z-index: 5; color: #444; font-size: 14px; }
        td { padding: 6px 3px; border: 1px solid #f2f2f2; text-align: center; vertical-align: middle; font-size: 14px; font-weight: 500; }
        
        .btn-edit-icon { padding: 4px 6px; background: #4c6ef5; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; line-height: 1; }
        .highlight-blue { color: #0984e3; font-weight: bold; font-size: 16px; }
        .highlight-red { color: #e74c3c; font-weight: bold; font-size: 16px; }

        /* 🛠️ 설정 모달 스타일 보완 */
        .config-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; }
        .config-modal { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 25px; border-radius: 15px; width: 480px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .config-list { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin: 20px 0; }
        
        /* 🛠️ 글자색 검정으로 강제 고정 */
        .config-item { display: flex; align-items: center; gap: 10px; font-size: 15px; cursor: pointer; font-weight: bold; color: #222 !important; }
        .config-item input { width: 18px; height: 18px; cursor: pointer; }
        .config-item span { color: #222 !important; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <main class="content">
            <div class="container">
                <h2>📋 스마트 양식 데이터 통합 기록부</h2>

                <div class="input-card" id="inputCard">
                    <form action="/manual/save" method="post" id="logForm">
                        <input type="hidden" name="logId" id="logId">

                        <div class="section-title">📍 기록 대상 및 시점 <span id="editStatus" style="margin-left:15px; color:#e67e22; display:none;">[수정 모드]</span></div>
                        <div class="form-grid">
                            <div class="form-group"><label>양식장</label>
                                <select name="farmName" id="farmSelect" class="select-input" onchange="applyFilter()" required>
                                    <option value="all">전체</option>
                                    <c:forEach var="f" items="${farmList}"><option value="${f.farmName}" ${selectedFarm == f.farmName ? 'selected' : ''}>${f.farmName}</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group"><label>수조</label><select name="tankName" id="tankSelect" class="select-input" onchange="applyFilter()" required><option value="all">전체</option></select></div>
                            <div class="form-group"><label>작성 일시</label>
                                <div class="time-box"><input type="datetime-local" name="regDate" id="regDate" class="date-input" required><button type="button" class="btn-now" id="btnNow" onclick="setNow()">지금</button></div>
                            </div>
                        </div>

                        <div class="section-title">
                            📊 성장/수질 및 환경개선제
                            <button type="button" class="btn-config" onclick="openConfig('section1')">⚙️ 항목 설정</button>
                        </div>
                        <div class="form-grid">
                            <div class="form-group" id="group-avgWeight"><label>평균체중(g)</label><input type="number" step="0.001" name="avgWeight" id="avgWeight" class="num-input" value="0" oninput="calcDeathCount()"></div>
                            <div class="form-group" id="group-deathWeight"><label>폐사량(g)</label><input type="number" step="0.001" name="deathCount" id="deathWeight" class="num-input" value="0" oninput="calcDeathCount()"></div>
                            <div class="form-group" id="group-deathCountCalc"><label>폐사(마리)</label><input type="text" id="deathCountCalc" class="calc-input" value="0" readonly></div>
                            <input type="hidden" name="deathCountCalcValue" id="deathCountHidden" value="0">
                            
                            <div class="form-group" id="group-tan"><label>TAN</label><input type="number" step="0.001" name="tan" id="tan" class="num-input" value="0"></div>
                            <div class="form-group" id="group-nitrite"><label>아질산</label><input type="number" step="0.001" name="nitrite" id="nitrite" class="num-input" value="0"></div>
                            <div class="form-group" id="group-alkalinity"><label>알칼리도</label><input type="number" step="0.1" name="alkalinity" id="alkalinity" class="num-input" value="0"></div>
                            <div class="form-group" id="group-glucoseInput"><label>포도당</label><input type="number" step="0.001" name="glucoseInput" id="glucoseInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-molassesInput"><label>당밀</label><input type="number" step="0.001" name="molassesInput" id="molassesInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-bicarbonateInput"><label>중탄산</label><input type="number" step="0.001" name="bicarbonateInput" id="bicarbonateInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-slakedLimeInput"><label>소석회</label><input type="number" step="0.001" name="slakedLimeInput" id="slakedLimeInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-calciumInput"><label>칼키</label><input type="number" step="0.001" name="calciumInput" id="calciumInput" class="num-input" value="0"></div>
                        </div>

                        <div class="section-title">
                            🍽️ 사료 및 영양제
                            <button type="button" class="btn-config" onclick="openConfig('section2')">⚙️ 항목 설정</button>
                        </div>
                        <div class="form-grid">
                            <div class="form-group" id="group-feedAmount"><label>사료량(g)</label><input type="number" step="0.1" name="feedAmount" id="feedAmount" class="num-input" value="0"></div>
                            <div class="form-group" id="group-feedCompany"><label>사료회사</label><input type="text" name="feedCompany" id="feedCompany" class="text-input"></div>
                            <div class="form-group" id="group-feedType"><label>사료종류</label><input type="text" name="feedType" id="feedType" class="text-input"></div>
                            <div class="form-group" id="group-vitaminInput"><label>비타민</label><input type="number" step="0.01" name="vitaminInput" id="vitaminInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-bacillusInput"><label>바실러스</label><input type="number" step="0.01" name="bacillusInput" id="bacillusInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-nutrientsInput"><label>영양제</label><input type="number" step="0.01" name="nutrientsInput" id="nutrientsInput" class="num-input" value="0"></div>
                            <div class="form-group" id="group-remarks"><label>비고</label><input type="text" name="remarks" id="remarks" class="remarks-input"></div>
                        </div>
                        <button type="submit" class="save-btn-bottom" id="btnSubmit">💾 기록 저장</button>
                        <button type="button" class="btn-cancel" id="btnCancel" onclick="resetForm()" style="display:none;">취소</button>
                    </form>
                </div>

                <div class="table-section">
                    <div class="table-scroll">
                        <table>
                            <thead>
                                <tr>
                                    <th width="85">일시</th><th width="140">양식장 > 수조</th><th width="55">체중</th><th width="55">폐사(g)</th>
                                    <th width="40">TAN</th><th width="40">NO2</th><th width="45">알칼리</th>
                                    <th width="40">포도당</th><th width="40">당밀</th><th width="40">중탄산</th><th width="40">소석회</th><th width="40">칼키</th>
                                    <th width="55">사료</th><th width="120">회사/종류</th><th width="150">영양제</th><th width="160">비고</th><th width="45">수정</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${logs}">
                                    <tr class="log-row" data-farm="${log.farmName}" data-tank="${log.tankName}">
                                        <td class="date-cell"><fmt:parseDate value="${log.regDate}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both" /><fmt:formatDate value="${pDate}" pattern="MM-dd HH:mm" /></td>
                                        <td class="farm-tank-cell">${log.farmName} > ${log.tankName}</td>
                                        <td class="highlight-blue">${log.avgWeight}</td><td class="highlight-red">${log.deathCount}</td> 
                                        <td>${log.tan}</td><td>${log.nitrite}</td><td>${log.alkalinity}</td>
                                        <td>${log.glucoseInput}</td><td>${log.molassesInput}</td><td>${log.bicarbonateInput}</td><td>${log.slakedLimeInput}</td><td>${log.calciumInput}</td>
                                        <td style="font-weight:bold; font-size:16px;">${log.feedAmount}</td>
                                        <td class="feed-info-cell">${log.feedCompany} | ${log.feedType}</td>
                                        <td>${log.tankName} (${deviceMap[log.tankName]})</td>
                                        <td>
                                            <c:if test="${log.vitaminInput > 0}"><span class="status-badge">Vita:${log.vitaminInput}</span></c:if>
                                            <c:if test="${log.bacillusInput > 0}"><span class="status-badge">Baci:${log.bacillusInput}</span></c:if>
                                            <c:if test="${log.nutrientsInput > 0}"><span class="status-badge">Nutr:${log.nutrientsInput}</span></c:if>
                                        </td>
                                        <td class="col-remarks" title="${log.remarks}">${log.remarks}</td>
                                        <td><button type="button" class="btn-edit-icon" onclick="editLog(${log.logId}, this.parentElement.parentElement)">📝</button></td>
                                        <td style="display:none;" class="raw-data" data-id="${log.logId}" data-farm="${log.farmName}" data-tank="${log.tankName}" data-date="${log.regDate}" data-weight="${log.avgWeight}" data-dweight="${log.deathCount}" data-tan="${log.tan}" data-no2="${log.nitrite}" data-alk="${log.alkalinity}" data-glu="${log.glucoseInput}" data-mol="${log.molassesInput}" data-bic="${log.bicarbonateInput}" data-sla="${log.slakedLimeInput}" data-cal="${log.calciumInput}" data-feed="${log.feedAmount}" data-fcom="${log.feedCompany}" data-ftype="${log.feedType}" data-vit="${log.vitaminInput}" data-bac="${log.bacillusInput}" data-nut="${log.nutrientsInput}" data-rem="${log.remarks}"></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <div id="configOverlay" class="config-overlay">
        <div class="config-modal">
            <h3 id="configTitle" style="margin-top:0; color:#005082;">입력 항목 커스텀 설정</h3>
            <p style="font-size:14px; color:#666; margin-bottom:15px;">체크한 항목만 입력창에 나타납니다.</p>
            <div class="config-list" id="configList"></div>
            <div style="text-align: right; margin-top: 20px; display:flex; gap:10px; justify-content: flex-end;">
                <button type="button" class="save-btn-bottom" onclick="saveConfig()" style="margin:0;">설정 저장</button>
                <button type="button" class="btn-cancel" onclick="closeConfig()" style="margin:0;">닫기</button>
            </div>
        </div>
    </div>

    <script>
        const fieldConfigs = {
            section1: [
                {id: 'avgWeight', name: '평균체중'}, {id: 'deathWeight', name: '폐사량(g)'}, 
                {id: 'deathCountCalc', name: '폐사(마리)'}, {id: 'tan', name: 'TAN'}, 
                {id: 'nitrite', name: '아질산'}, {id: 'alkalinity', name: '알칼리도'}, 
                {id: 'glucoseInput', name: '포도당'}, {id: 'molassesInput', name: '당밀'}, 
                {id: 'bicarbonateInput', name: '중탄산'}, {id: 'slakedLimeInput', name: '소석회'}, 
                {id: 'calciumInput', name: '칼키'}
            ],
            section2: [
                {id: 'feedAmount', name: '사료량'}, {id: 'feedCompany', name: '사료회사'}, 
                {id: 'feedType', name: '사료종류'}, {id: 'vitaminInput', name: '비타민'}, 
                {id: 'bacillusInput', name: '바실러스'}, {id: 'nutrientsInput', name: '영양제'},
                {id: 'remarks', name: '비고'}
            ]
        };

        let currentSection = '';

        // 🛠️ 설정창 열기 - 텍스트 노드 생성 방식 보완
        function openConfig(section) {
            currentSection = section;
            const listDiv = document.getElementById('configList');
            listDiv.innerHTML = '';
            const savedStatus = JSON.parse(localStorage.getItem('wqs_fields') || '{}');
            
            fieldConfigs[section].forEach(field => {
                const isChecked = savedStatus[field.id] !== false;
                
                const label = document.createElement('label');
                label.className = 'config-item';
                
                // 체크박스 생성
                const input = document.createElement('input');
                input.type = 'checkbox';
                input.className = 'field-chk';
                input.dataset.id = field.id;
                if(isChecked) input.checked = true;
                
                // 텍스트 생성
                const span = document.createElement('span');
                span.innerText = field.name;
                
                label.appendChild(input);
                label.appendChild(span);
                listDiv.appendChild(label);
            });
            document.getElementById('configOverlay').style.display = 'block';
        }

        function closeConfig() { document.getElementById('configOverlay').style.display = 'none'; }

        function saveConfig() {
            const savedStatus = JSON.parse(localStorage.getItem('wqs_fields') || '{}');
            document.querySelectorAll('.field-chk').forEach(chk => {
                savedStatus[chk.dataset.id] = chk.checked;
            });
            localStorage.setItem('wqs_fields', JSON.stringify(savedStatus));
            applyFieldDisplay();
            closeConfig();
        }

        function applyFieldDisplay() {
            const savedStatus = JSON.parse(localStorage.getItem('wqs_fields') || '{}');
            Object.values(fieldConfigs).flat().forEach(field => {
                const el = document.getElementById('group-' + field.id);
                if (el) el.style.display = (savedStatus[field.id] === false) ? 'none' : 'flex';
            });
        }

        // --- 나머지 기존 스크립트 동일 ---
        function editLog(id, row) {
            const data = row.querySelector('.raw-data').dataset;
            document.getElementById('inputCard').classList.add('edit-mode');
            document.getElementById('editStatus').style.display = 'inline';
            document.getElementById('btnCancel').style.display = 'inline';
            document.getElementById('btnSubmit').innerText = '💾 수정 완료';
            document.getElementById('btnNow').style.display = 'none';
            document.getElementById('logId').value = data.id;
            document.getElementById('farmSelect').value = data.farm;
            updateTankSelect(data.farm, data.tank);
            document.getElementById('regDate').value = data.date.substring(0, 16);
            document.getElementById('avgWeight').value = data.weight;
            document.getElementById('deathWeight').value = data.dweight;
            document.getElementById('tan').value = data.tan;
            document.getElementById('nitrite').value = data.no2;
            document.getElementById('alkalinity').value = data.alk;
            document.getElementById('glucoseInput').value = data.glu;
            document.getElementById('molassesInput').value = data.mol;
            document.getElementById('bicarbonateInput').value = data.bic;
            document.getElementById('slakedLimeInput').value = data.sla;
            document.getElementById('calciumInput').value = data.cal;
            document.getElementById('feedAmount').value = data.feed;
            document.getElementById('feedCompany').value = data.fcom;
            document.getElementById('feedType').value = data.ftype;
            document.getElementById('vitaminInput').value = data.vit;
            document.getElementById('bacillusInput').value = data.bac;
            document.getElementById('nutrientsInput').value = data.nut;
            document.getElementById('remarks').value = data.rem;
            calcDeathCount();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function resetForm() {
            document.getElementById('logId').value = '';
            document.getElementById('logForm').reset();
            document.getElementById('inputCard').classList.remove('edit-mode');
            document.getElementById('editStatus').style.display = 'none';
            document.getElementById('btnCancel').style.display = 'none';
            document.getElementById('btnSubmit').innerText = '💾 기록 저장';
            document.getElementById('btnNow').style.display = 'inline';
            setNow();
        }

        function calcDeathCount() {
            const avg = parseFloat(document.getElementById('avgWeight').value) || 0;
            const weight = parseFloat(document.getElementById('deathWeight').value) || 0;
            const display = document.getElementById('deathCountCalc');
            display.value = (avg > 0 && weight > 0) ? Math.round(weight / avg) + " 마리" : "0 마리";
        }

        const allTanks = [<c:forEach var="t" items="${tankList}" varStatus="vs">{ name: "${t.tankName}", farmId: "${t.farmId}" }${!vs.last ? ',' : ''}</c:forEach>];
        const farmMap = {<c:forEach var="f" items="${farmList}" varStatus="vs">"${f.farmName}": "${f.farmId}"${!vs.last ? ',' : ''}</c:forEach>};
        
        function setNow() {
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            document.getElementById('regDate').value = now.toISOString().slice(0, 16);
        }

        function updateTankSelect(farmName, selectedTank) {
            const tankSelect = document.getElementById('tankSelect');
            const farmId = farmMap[farmName];
            tankSelect.innerHTML = '<option value="all">전체</option>';
            allTanks.forEach(tank => {
                if (farmName === 'all' || String(tank.farmId) === String(farmId)) {
                    const opt = document.createElement('option');
                    opt.value = tank.name; opt.textContent = tank.name;
                    if(tank.name === selectedTank) opt.selected = true;
                    tankSelect.appendChild(opt);
                }
            });
        }

        function applyFilter() {
            if(document.getElementById('logId').value) return;
            location.href = "/manual/form?farmName=" + encodeURIComponent(document.getElementById('farmSelect').value) + "&tankName=" + encodeURIComponent(document.getElementById('tankSelect').value);
        }

        window.onload = function() {
            setNow();
            applyFieldDisplay();
            updateTankSelect("${selectedFarm}", "${selectedTank}");
        };
    </script>
</body>
</html>