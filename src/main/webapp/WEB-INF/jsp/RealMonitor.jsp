<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 실시간 모니터링</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background: #f4f7f9; margin: 0; padding: 20px; }
        
        /* ☁️ 상단 기상청 정보 바 (성우님 요청 항목 반영) */
        .weather-container {
            background: #003d66; color: white; padding: 20px; border-radius: 12px;
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 25px;
        }
        .weather-item { font-size: 14px; border-bottom: 1px solid #005082; padding-bottom: 5px; }
        .weather-item span { font-weight: bold; color: #00d2ff; }

        /* 📊 그래프 카드 스타일 */
        .chart-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .tank-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        h3 { color: #003d66; margin-top: 0; border-left: 5px solid #00d2ff; padding-left: 10px; }
    </style>
</head>
<body>

    <div class="weather-container">
        <div class="weather-item">📍 지역: <span>목포시 해안로</span></div>
        <div class="weather-item">☀️ 날씨: <span id="w-desc">맑음</span></div>
        <div class="weather-item">🌡️ 기온: <span id="w-temp">22.5</span>°C</div>
        <div class="weather-item">💧 습도: <span id="w-humid">45</span>%</div>
        <div class="weather-item">☔ 강우량: <span id="w-rain">0</span>mm</div>
        <div class="weather-item">🌬️ 풍향/풍속: <span id="w-wind">남서 / 3.2m/s</span></div>
    </div>

    <div class="chart-card">
        <h3>🏠 양식장 실내 공통 환경 (기온 / 습도 / 조도)</h3>
        <canvas id="commonChart" height="80"></canvas>
    </div>

    <div class="tank-grid">
        <div class="chart-card">
            <h3>💧 A-01 수조 (수온 / pH / DO)</h3>
            <canvas id="tankChart1" height="150"></canvas>
        </div>
        <div class="chart-card">
            <h3>💧 A-02 수조 (수온 / pH / DO)</h3>
            <canvas id="tankChart2" height="150"></canvas>
        </div>
    </div>

    <script>
        // --- 차트 생성 함수 (공통 환경) ---
        const commonChart = new Chart(document.getElementById('commonChart'), {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    { label: '실내기온', data: [], borderColor: '#ff6384', fill: false },
                    { label: '실내습도', data: [], borderColor: '#36a2eb', fill: false },
                    { label: '조도', data: [], borderColor: '#ffce56', fill: false }
                ]
            },
            options: { responsive: true, animation: false }
        });

        // --- 차트 생성 함수 (수조 1번) ---
        const tankChart1 = new Chart(document.getElementById('tankChart1'), {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    { label: '수온', data: [], borderColor: '#2ecc71', fill: false },
                    { label: 'pH', data: [], borderColor: '#9b59b6', fill: false },
                    { label: 'DO', data: [], borderColor: '#e67e22', fill: false }
                ]
            },
            options: { responsive: true, animation: false }
        });

        // 🔄 임시 데이터 업데이트 (나중에 DB 데이터 연결)
        function refreshData() {
            const now = new Date().toLocaleTimeString();
            if(commonChart.data.labels.length > 15) commonChart.data.labels.shift();
            commonChart.data.labels.push(now);
            commonChart.data.datasets[0].data.push((Math.random()*2 + 20).toFixed(1));
            commonChart.update();
        }

        setInterval(refreshData, 5000); // 5초마다 갱신 테스트
    </script>
</body>
</html>