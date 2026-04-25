<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 수조 정보 등록</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; padding: 20px; background: #f4f7f6; }
        .reg-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); max-width: 800px; margin: auto; }
        h3 { color: #005082; border-bottom: 2px solid #005082; padding-bottom: 10px; margin-bottom: 25px; }
        
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        label { font-weight: bold; font-size: 14px; display: block; margin-bottom: 8px; color: #333; }
        input, select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        
        .readonly-input { background-color: #f9f9f9; color: #666; }
        .calc-info { grid-column: span 2; background: #eef7ff; padding: 15px; border-radius: 8px; color: #005082; font-weight: bold; font-size: 15px; }
        
        .btn-save { grid-column: span 2; padding: 16px; background: #2ecc71; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .btn-save:hover { background: #27ae60; }
    </style>
</head>
<body>
    <div class="reg-card">
        <h3>${empty tank.tankId ? '➕ 수조 정보 등록' : '📝 수조 정보 수정'}</h3>
        <form id="tankForm">
            <input type="hidden" name="farmId" value="${farmId}">
            <input type="hidden" name="tankId" value="${tank.tankId}">
            
            <div class="grid">
                <div><label>수조 이름</label><input type="text" name="tankName" value="${tank.tankName}" required></div>
                <div><label>사육 해산물 종류</label><input type="text" name="species" value="${tank.species}"></div>
                
                <div><label>가로 (m)</label><input type="number" id="widthM" name="widthM" step="0.1" value="${tank.widthM}" oninput="calculateAll()"></div>
                <div><label>세로 (m)</label><input type="number" id="lengthM" name="lengthM" step="0.1" value="${tank.lengthM}" oninput="calculateAll()"></div>
                <div><label>높이 (m)</label><input type="number" id="heightM" name="heightM" step="0.1" value="${tank.heightM}" oninput="calculateAll()"></div>
                <div><label>물높이 (m)</label><input type="number" id="waterLevel" name="waterLevelM" step="0.1" value="${tank.waterLevelM}" oninput="calculateAll()"></div>
                <div><label>장비 번호</label><input type="text" name="deviceNo" value="${tank.deviceNo}" placeholder="예: sw-260001"></div>

                <div>
                    <label>입식 단계</label>
                    <select name="culturePhase">
                        <option value="중간양성" ${tank.culturePhase == '중간양성' ? 'selected' : ''}>중간양성</option>
                        <option value="본양성" ${tank.culturePhase == '본양성' ? 'selected' : ''}>본양성</option>
                    </select>
                </div>
                <div>
                    <label>실제 입식 밀도 (마리/평)</label>
                    <input type="text" id="resDensity" name="stockingDensityActual" value="${tank.stockingDensityActual}" class="readonly-input" readonly>
                </div>

                <div><label>총 입식 마리수 (마리)</label><input type="text" id="tCount" name="totalCount" value="${tank.totalCount}" oninput="formatNumber(this); calculateAll();"></div>
                <div><label>총 입식 무게 (kg)</label><input type="number" id="tWeight" name="totalWeightKg" step="0.001" value="${tank.totalWeightKg}" oninput="calculateAll()"></div>
                
                <div class="calc-info">
                    🌊 예상 담수량: <span id="resVolume">${tank.waterVolumeTon}</span> 톤<br>
                    ⚖️ 1마리당 평균 무게: <span id="resPerWeight">${tank.weightPerPiece}</span> g
                </div>

                <div><label>입식 일자</label><input type="date" id="stockingDate" name="stockingDate" value="${tank.stockingDate}"></div>
                <div><label>종자 공급처</label><input type="text" name="supplier" value="${tank.supplier}" placeholder="예: 대상"></div>
                <div><label>종자 종류</label><input type="text" name="seedSpecies" value="${tank.seedSpecies}" placeholder="예: PL3"></div>
                <div><label>종자 번호 (Lot No.)</label><input type="text" name="seedNo" value="${tank.seedNo}"></div>
                
                <div><label>사료 회사</label><input type="text" name="feedCompany" value="${tank.feedCompany}"></div>
                <div><label>사료 이름</label><input type="text" name="feedName" value="${tank.feedName}"></div>

                <button type="button" class="btn-save" onclick="saveTank()">${empty tank.tankId ? '수조 등록 완료' : '수정 완료'}</button>
            </div>
        </form>
    </div>

<script>
    window.onload = function() {
        // 수정 모드가 아닐 때(날짜가 비어있을 때)만 오늘 날짜 설정
        const dateInput = document.getElementById('stockingDate');
        if(!dateInput.value) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.value = today;
        }
        calculateAll(); // 기존 데이터 기반 계산기 실행
    };

    // calculateAll, formatNumber, saveTank 함수는 기존과 동일하게 유지
    // ... (생략)


    function formatNumber(obj) {
        let val = obj.value.replace(/[^0-9]/g, "");
        obj.value = val.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function changePhase(val) {
        // 나중에 단계별 로직 필요시 추가
    }

    function calculateAll() {
        const w = parseFloat(document.getElementById('widthM').value) || 0;
        const l = parseFloat(document.getElementById('lengthM').value) || 0;
        const h = parseFloat(document.getElementById('waterLevel').value) || 0;
        const count = parseInt(document.getElementById('tCount').value.replace(/,/g, "")) || 0;
        const weight = parseFloat(document.getElementById('tWeight').value) || 0;

        const volume = w * l * h;
        document.getElementById('resVolume').innerText = volume.toFixed(2);

        if (count > 0 && weight > 0) {
            const perWeight = (weight * 1000) / count;
            document.getElementById('resPerWeight').innerText = perWeight.toFixed(3);
        } else {
            document.getElementById('resPerWeight').innerText = "0.000";
        }

        if (w > 0 && l > 0 && count > 0) {
            const pyeong = (w * l) / 3.305;
            const density = Math.round(count / pyeong);
            const densityInput = document.getElementById('resDensity');
            if (densityInput) {
                densityInput.value = density.toLocaleString();
            }
        }
    }

    function saveTank() {
        const form = document.getElementById('tankForm');
        const formData = new FormData(form);
        const params = new URLSearchParams();
        
        for (const pair of formData.entries()) {
            params.append(pair[0], pair[1].toString().replace(/,/g, ""));
        }

        fetch('/tankRegProcess', {
            method: 'POST',
            body: params
        })
        .then(res => res.text())
        .then(data => {
            if(data === "SUCCESS") {
                alert("수조 등록 완료!");
                window.opener.location.reload();
                window.close();
            } else {
                alert("등록 실패: " + data);
            }
        })
        .catch(err => {
            console.error(err);
            alert("서버 연결 오류가 발생했습니다.");
        });
    }
</script>
</body>
</html>