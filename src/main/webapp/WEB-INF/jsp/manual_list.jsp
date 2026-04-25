<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theoros WQS - 수기 기록 목록</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f0f4f8; }
        .wrapper { display: flex; flex: 1; }
        .content { flex: 1; padding: 25px; overflow-y: auto; }
        .container { max-width: 1400px; margin: auto; background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        h2 { color: #005082; border-left: 5px solid #005082; padding-left: 15px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .add-btn { padding: 10px 20px; background: #005082; color: white; text-decoration: none; border-radius: 5px; font-size: 14px; font-weight: bold; }

        table { width: 100%; border-collapse: collapse; font-size: 12px; margin-top: 10px; }
        th { background: #f8f9fa; color: #333; padding: 12px 5px; border-bottom: 2px solid #005082; position: sticky; top: 0; }
        td { padding: 10px 5px; border-bottom: 1px solid #eee; text-align: center; }
        tr:hover { background: #f1f8ff; }

        /* 상태 및 수치 강조 */
        .farm-tag { font-weight: bold; color: #2c3e50; }
        .weight-tag { color: #0984e3; font-weight: bold; }
        .death-tag { color: #e74c3c; font-weight: bold; }
        .remark-text { text-align: left; color: #666; font-size: 11px; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="container">
                <h2>📋 수기 데이터 관리 기록부
                    <a href="/manual/form" class="add-btn">➕ 새 기록 작성</a>
                </h2>

                <table>
                    <thead>
                        <tr>
                            <th>날짜</th>
                            <th>양식장/수조</th>
                            <th>평균체중</th>
                            <th>폐사</th>
                            <th>TAN</th>
                            <th>아질산</th>
                            <th>알칼리</th>
                            <th>사료량</th>
                            <th>비타민/바실러스/영양제</th>
                            <th>비고</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty logs}">
                                <c:forEach var="log" items="${logs}">
                                    <tr>
                                        <td>
                                            <fmt:formatDate value="${log.regDate}" pattern="MM-dd HH:mm" />
                                        </td>
                                        <td>
                                            <span class="farm-tag">${log.farmName}</span><br>
                                            <small>${log.tankName}</small>
                                        </td>
                                        <td class="weight-tag">${log.avgWeight}g</td>
                                        <td class="death-tag">${log.deathCount}</td>
                                        <td>${log.tan}</td>
                                        <td>${log.nitrite}</td>
                                        <td>${log.alkalinity}</td>
                                        <td><strong>${log.feedAmount}kg</strong></td>
                                        <td>
                                            <small>${log.vitaminInput} / ${log.bacillusInput} / ${log.nutrientsInput}</small>
                                        </td>
                                        <td class="remark-text" title="${log.remarks}">${log.remarks}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10" style="padding: 50px; color: #999;">아직 등록된 수기 기록이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>