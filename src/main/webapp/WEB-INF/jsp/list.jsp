<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartFish - 실시간 데이터 조회</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/sidebar.css">
    
    <style>
        
        @media screen and (max-width: 1400px) {
            .container {
                font-size: 14px;
            }
        }
        @media screen and (max-width: 768px) {
            .container {
                font-size: 13px;
            }
        }
        @media screen and (max-width: 480px) {
            .container {
                font-size: 11px;
            }
        }
        /* body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; flex-direction: column; height: 100vh; } */
        .wrapper { display: flex; flex: 1; }
        .content { flex: 1; padding: 30px; overflow-y: auto; }
        .container { max-width: 1450px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
        
        .filter-section { 
            display: flex; gap: 15px; margin-bottom: 25px; padding: 15px; 
            background: #f8f9fa; border-radius: 8px; align-items: center; border: 1px solid #e9ecef;
        }
        .filter-section label { font-weight: bold; color: #495057; font-size: 14px; }
        .filter-section select { padding: 8px 12px; border-radius: 5px; border: 1px solid #ced4da; min-width: 180px; }

        h2 { text-align: center; color: #2c3e50; margin-bottom: 20px; border-bottom: 2px solid #005082; padding-bottom: 10px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 15px; table-layout: auto; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #ddd; text-align: center; white-space: nowrap; }
        th { background-color: #f8f9fa; color: #333; font-weight: bold; }
        
        .farm-val { font-weight: bold; color: #333; font-size: 15px; }sidebar
        .device-info { color: #535353; font-weight: bold; font-size: 15px; margin-left: 5px; } 

        .temp-val { color: #007bff; font-weight: bold; }
        .ph-val { color: #28a745; font-weight: bold; }
        .do-val { color: #e67e22; font-weight: bold; }
        .lux-val { color: #f1c40f; font-weight: bold; text-shadow: 0.5px 0.5px 0px #ccc; }
        .date-val { color: #555; font-weight: bold; font-size: 14px; }
        
        tr:hover { background-color: #f1f8ff; }
        .refresh-btn { padding: 10px 20px; cursor: pointer; background: #005082; color: white; border: none; border-radius: 5px; font-weight: bold; }

        /* 🛠️ 더보기 버튼 스타일 */
        .load-more-container { text-align: center; margin-top: 30px; padding-bottom: 20px; }
        .load-more-btn { 
            padding: 12px 50px; font-size: 16px; background: white; color: #005082; 
            border: 2px solid #005082; border-radius: 30px; cursor: pointer; font-weight: bold;
            transition: 0.3s;
        }
        .load-more-btn:hover { background: #005082; color: white; }
        .load-more-btn:disabled { border-color: #ccc; color: #ccc; cursor: default; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="container">
                <h2>📊 실시간 수질 데이터 모니터링</h2>

                <div class="filter-section">
                    <label>📍 양식장 선택</label>
                    <select id="farmFilter" onchange="updateTankFilter()">
                        <option value="all">전체 양식장</option>
                        <c:forEach var="farm" items="${farmList}">
                            <option value="${farm.farmName}">${farm.farmName}</option>
                        </c:forEach>
                    </select>

                    <label>🦐 수조 선택</label>
                    <select id="tankFilter" onchange="filterData()">
                        <option value="all">전체 수조</option>
                    </select>
                    
                    <button class="refresh-btn" style="margin-left: auto;" onclick="location.reload()">🔄 새로고침</button>
                </div>
                
                <table id="dataTable">
                    <thead>
                        <tr>
                            <th width="60">No.</th>
                            <th>양식장 / 수조 (장비번호)</th>
                            <th>수온 (℃)</th>
                            <th>pH 농도</th>
                            <th>DO (mg/L)</th>
                            <th>기온 (℃)</th>
                            <th>습도 (%)</th>
                            <th>조도 (Lux)</th>
                            <th>측정 시간</th>
                        </tr>
                    </thead>
                    <tbody id="dataBody">
                        <c:choose>
                            <c:when test="${not empty sensorList}">
                                <c:forEach var="item" items="${sensorList}">
                                    <tr class="data-row" data-farm="${item.farmName}" data-tank="${item.tankName}">
                                        <td>${item.data_id}</td>
                                        <td>
                                            <span class="farm-val">${item.farmName}</span>
                                            <span style="color: #999; margin: 0 5px;">/</span>
                                            <span class="tank-val">${item.tankName}</span>
                                            <span class="device-info">(${item.device_no})</span>
                                        </td>
                                        <td class="temp-val">${item.water_temp}℃</td>
                                        <td class="ph-val">${item.ph}</td>
                                        <td class="do-val">${item.do_val}</td>
                                        <td>${item.air_temp}℃</td>
                                        <td>${item.air_humid}%</td>
                                        <td class="lux-val">${item.lux}</td>
                                        <td class="date-val">
                                            <fmt:parseDate value="${item.regDate}" pattern="yyyy-MM-dd HH:mm" var="parsedDate" />
                                            <fmt:formatDate value="${parsedDate}" pattern="MM-dd HH:mm" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr id="noDataRow"><td colspan="9" style="padding:50px; color:#999;">데이터가 없습니다.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <div class="load-more-container">
                    <button type="button" id="loadMoreBtn" class="load-more-btn" onclick="showMore()">더보기 (24개씩)</button>
                </div>
            </div>
        </main>
    </div>

    <script>
    let visibleCount = 24; // 현재 보여지는 개수
    const pageSize = 24;   // 한 번에 추가할 개수

    function updateTankFilter() {
        const farmVal = document.getElementById('farmFilter').value;
        const tankFilter = document.getElementById('tankFilter');
        const rows = document.querySelectorAll('.data-row');
        tankFilter.innerHTML = '<option value="all">전체 수조</option>';
        const tanks = new Set();
        rows.forEach(row => {
            const rowFarm = row.getAttribute('data-farm');
            const rowTank = row.getAttribute('data-tank');
            if (farmVal === 'all' || farmVal === rowFarm) {
                if(rowTank && rowTank !== 'null') tanks.add(rowTank);
            }
        });
        tanks.forEach(tank => {
            const opt = document.createElement('option');
            opt.value = tank; opt.textContent = tank;
            tankFilter.appendChild(opt);
        });
        
        visibleCount = pageSize; // 필터 변경 시 다시 24개부터 시작
        filterData();
    }

    function filterData() {
        const farmVal = document.getElementById('farmFilter').value;
        const tankVal = document.getElementById('tankFilter').value;
        const rows = document.querySelectorAll('.data-row');
        const loadMoreBtn = document.getElementById('loadMoreBtn');
        
        let matchCount = 0; // 조건에 맞는 전체 데이터 수
        let shownCount = 0; // 실제 화면에 표시된 데이터 수

        rows.forEach(row => {
            const rowFarm = row.getAttribute('data-farm');
            const rowTank = row.getAttribute('data-tank');
            const farmMatch = (farmVal === 'all' || farmVal === rowFarm);
            const tankMatch = (tankVal === 'all' || tankVal === rowTank);

            if (farmMatch && tankMatch) {
                matchCount++;
                if (shownCount < visibleCount) {
                    row.style.display = ''; // 보여줌
                    shownCount++;
                } else {
                    row.style.display = 'none'; // 24개 넘어가면 숨김
                }
            } else {
                row.style.display = 'none'; // 필터 조건 안 맞으면 숨김
            }
        });

        // 더 보여줄 데이터가 있으면 버튼 활성화, 없으면 숨김
        if (matchCount > visibleCount) {
            loadMoreBtn.style.display = 'inline-block';
            loadMoreBtn.textContent = "더보기 (" + (matchCount - shownCount) + "개 남음)";
        } else {
            loadMoreBtn.style.display = 'none';
        }
        
        // 데이터가 아예 없을 때 처리
        const noDataRow = document.getElementById('noDataRow');
        if (noDataRow) {
            noDataRow.style.display = (matchCount === 0) ? '' : 'none';
        }
    }

    // [더보기] 버튼 클릭 시 호출
    function showMore() {
        visibleCount += pageSize;
        filterData();
    }

    window.onload = function() {
        updateTankFilter();
    };
    </script>
</body>
</html>