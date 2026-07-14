<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="java.util.Calendar" %>
<%
    List<Order> allOrders = (List<Order>) request.getAttribute("allOrders");
    List<String[]> rankDay = (List<String[]>) request.getAttribute("rankDay");
    List<String[]> rankMonth = (List<String[]>) request.getAttribute("rankMonth");
    List<String[]> rankYear = (List<String[]>) request.getAttribute("rankYear");
    List<String[]> rankKids = (List<String[]>) request.getAttribute("rankKids");
    List<String[]> rankYouth = (List<String[]>) request.getAttribute("rankYouth");
    List<String[]> rankAdult = (List<String[]>) request.getAttribute("rankAdult");
    List<String[]> rankSenior = (List<String[]>) request.getAttribute("rankSenior");
    List<String[]> ageSalesSummary = (List<String[]>) request.getAttribute("ageSalesSummary");

    int seaCount = request.getAttribute("seaCount") != null ? (Integer) request.getAttribute("seaCount") : 0;
    int landCount = request.getAttribute("landCount") != null ? (Integer) request.getAttribute("landCount") : 0;

    int todaySales = 0; int todayOrderCount = 0;
    Calendar cal1 = Calendar.getInstance();
    int ty = cal1.get(Calendar.YEAR); int tm = cal1.get(Calendar.MONTH); int td = cal1.get(Calendar.DAY_OF_MONTH);

    if (allOrders != null) {
        for (Order o : allOrders) {
            if (o.getOrderDate() != null) {
                Calendar cal2 = Calendar.getInstance(); cal2.setTime(o.getOrderDate());
                if (cal2.get(Calendar.YEAR) == ty && cal2.get(Calendar.MONTH) == tm && cal2.get(Calendar.DAY_OF_MONTH) == td) {
                    todaySales += o.getTotalPrice(); todayOrderCount++;
                }
            }
        }
    }
    int averageSpent = (todayOrderCount > 0) ? (todaySales / todayOrderCount) : 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>売上分析ダッシュボード | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<!-- 📊 グラフ化ライブラリ Chart.js の読み込み -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    body { font-family: 'Montserrat', 'Noto Sans JP', sans-serif; background-color: #f8f9fa; color: #333; margin: 0; padding: 30px 20px; }
    .container { max-width: 1200px; margin: 0 auto; }
    
    .header { display: flex; justify-content: space-between; align-items: center; background: #00704A; color: white; padding: 20px 30px; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,112,74,0.15); margin-bottom: 30px; }
    .header h1 { margin: 0; font-size: 22px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
    .header-btns { display: flex; gap: 12px; }
    .btn { text-decoration: none; padding: 10px 18px; border-radius: 8px; font-weight: bold; font-size: 13px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px; }
    .btn-back { background: rgba(255,255,255,0.15); color: white; border: 1px solid rgba(255,255,255,0.3); }
    .btn-back:hover { background: rgba(255,255,255,0.25); }
    .btn-plt { background: #ffc107; color: #212529; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    .btn-plt:hover { background: #e0a800; transform: translateY(-1px); }
    
    .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px; }
    .kpi-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.04); border-top: 4px solid #00704A; position: relative; }
    .kpi-title { font-size: 13px; color: #6c757d; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; }
    .kpi-value { font-size: 28px; font-weight: 700; margin-top: 8px; color: #212529; }
    
    .main-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; }
    @media (max-width: 992px) { .main-grid { grid-template-columns: 1fr; } }
    
    .card-box { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.04); margin-bottom: 25px; }
    .card-title { font-size: 16px; color: #00704A; font-weight: 700; margin-top: 0; margin-bottom: 20px; border-bottom: 2px solid #f1f3f5; padding-bottom: 10px; display: flex; align-items: center; gap: 8px; }
    
    /* グラフ配置エリア */
    .chart-wrapper { position: relative; width: 100%; height: 300px; margin-bottom: 20px; }
    
    .tab-buttons { display: flex; gap: 8px; background: #f1f3f5; padding: 4px; border-radius: 8px; margin-bottom: 20px; width: fit-content; }
    .tab-btn { background: transparent; border: none; padding: 8px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; color: #6c757d; font-size: 13px; transition: all 0.2s; }
    .tab-btn.active { background: white; color: #00704A; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
    .tab-content { display: none; }
    .tab-content.active { display: block; }

    table { width: 100%; border-collapse: collapse; }
    th { text-align: left; color: #6c757d; font-size: 12px; padding-bottom: 12px; border-bottom: 1px solid #edf2f7; font-weight: 600; }
    td { padding: 14px 8px; border-bottom: 1px solid #f8f9fa; font-size: 14px; color: #495057; }
    tr:last-child td { border-bottom: none; }
    .rank-badge { background: #eef5f0; color: #00704A; font-weight: 700; padding: 3px 8px; border-radius: 6px; font-size: 11px; }
    .text-right { text-align: right; }
    
    .age-box-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
    .age-card { background: #fdfbf7; border: 1px solid #f5ebd0; padding: 15px; border-radius: 12px; }
    .age-title { font-weight: 700; color: #856404; font-size: 13px; margin-bottom: 8px; display: flex; justify-content: space-between; }
</style>
<script>
    function switchTab(tabId, btn) {
        document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        btn.classList.add('active');
    }
</script>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>🐢 カメシステム売上ダッシュボード</h1>
        <div class="header-btns">
            <!-- 💡 plt統合：甲羅勘定（損益計算書）への素敵なジャンプ先 -->
            <!-- 💡 修正後：JSP直接ではなく、サーブレットURL（/pl）へ繋ぎ直すカメ！ -->
			<a href="${pageContext.request.contextPath}/pl" class="btn btn-plt">📊 甲羅勘定(損益計算書)を見る</a>
            <a href="staff_main.jsp" class="btn btn-back">メインへ戻る</a>
        </div>
    </div>

    <!-- KPIサマリーカード -->
    <div class="dashboard-grid">
        <div class="kpi-card" style="border-top-color: #2b8a3e;"><div class="kpi-title">📈 本日の総売上高</div><div class="kpi-value" style="color: #2b8a3e;">￥<%= String.format("%,d", todaySales) %></div></div>
        <div class="kpi-card" style="border-top-color: #0b5ed7;"><div class="kpi-title">🛒 本日の総注文数</div><div class="kpi-value" style="color: #0b5ed7;"><%= todayOrderCount %> 卓</div></div>
        <div class="kpi-card" style="border-top-color: #f57c00;"><div class="kpi-title">👥 本日の客単価</div><div class="kpi-value" style="color: #f57c00;">￥<%= String.format("%,d", averageSpent) %></div></div>
    </div>

    <div class="main-grid">
        <!-- 左側：ランキングとインタラクティブグラフ -->
        <div>
            <div class="card-box">
                <h3 class="card-title">📈 pltプロット分析（売れ筋メニューの可視化）</h3>
                <div class="chart-wrapper">
                    <canvas id="rankingChart"></canvas>
                </div>
                
                <div class="tab-buttons">
                    <button class="tab-btn active" onclick="switchTab('tab-period', this)">📅 期間別データ詳細</button>
                    <button class="tab-btn" onclick="switchTab('tab-age-rank', this)">👑 年齢層別の人気メニュー</button>
                </div>

                <div id="tab-period" class="tab-content active">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px;">
                        <div><h4 style="color:#00704A; margin-bottom:10px;">☀️ 本日の人気</h4><%= renderTable(rankDay) %></div>
                        <div><h4 style="color:#0b5ed7; margin-bottom:10px;">🌙 今月の人気</h4><%= renderTable(rankMonth) %></div>
                        <div><h4 style="color:#f57c00; margin-bottom:10px;">🌋 今年の人気</h4><%= renderTable(rankYear) %></div>
                    </div>
                </div>

                <div id="tab-age-rank" class="tab-content">
                    <div class="age-box-grid">
                        <div class="age-card"><div class="age-title">👧 キッズ <span>(12歳以下)</span></div><%= renderAgeList(rankKids) %></div>
                        <div class="age-card"><div class="age-title">⚡ 若者・学生 <span>(10〜20代)</span></div><%= renderAgeList(rankYouth) %></div>
                        <div class="age-card"><div class="age-title">💼 大人 <span>(30〜50代)</span></div><%= renderAgeList(rankAdult) %></div>
                        <div class="age-card"><div class="age-title">👴 シニア <span>(60歳以上)</span></div><%= renderAgeList(rankSenior) %></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 右側：客層の円グラフ分析と貢献度テーブル -->
        <div>
            <div class="card-box">
                <h3 class="card-title">🍕 客層別の売上貢献度(plt)</h3>
                <div class="chart-wrapper" style="height: 240px;">
                    <canvas id="ageShareChart"></canvas>
                </div>
                
                <table>
                    <thead>
                        <tr><th>年齢層</th><th class="text-right">売上総額</th></tr>
                    </thead>
                    <tbody>
                        <% 
                        if(ageSalesSummary != null && !ageSalesSummary.isEmpty()) { 
                            for(String[] row : ageSalesSummary) {
                                String displayAge = row[0];
                                if("kids".equalsIgnoreCase(displayAge)) displayAge="キッズ(12歳以下)";
                                else if("youth".equalsIgnoreCase(displayAge)) displayAge="若者・学生";
                                else if("adult".equalsIgnoreCase(displayAge)) displayAge="大人";
                                else if("senior".equalsIgnoreCase(displayAge)) displayAge="シニア";
                                else displayAge="不明";
                        %>
                            <tr>
                                <td><strong><%= displayAge %></strong></td>
                                <td class="text-right" style="font-weight:600; color:#2b8a3e;">￥<%= String.format("%,d", Integer.parseInt(row[2])) %></td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 💡 ここからChart.jsのリアルタイムレンダリング処理(plt機能) -->
<script>
    // ① 期間別売れ筋ランキンググラフ（棒グラフ）
    const ctxRank = document.getElementById('rankingChart').getContext('2d');
    new Chart(ctxRank, {
        type: 'bar',
        data: {
            labels: [
                <% if(rankMonth != null) { for(String[] r : rankMonth) { %> '<%= r[0] %>', <% } } %>
            ],
            datasets: [{
                label: '今月の注文個数',
                data: [
                    <% if(rankMonth != null) { for(String[] r : rankMonth) { %> <%= r[1] %>, <% } } %>
                ],
                backgroundColor: 'rgba(0, 112, 74, 0.75)',
                borderColor: '#00704A',
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, grid: { color: '#f1f3f5' } }, x: { grid: { display: false } } }
        }
    });

    // ② 客層パイチャート（円グラフ）
    const ctxAge = document.getElementById('ageShareChart').getContext('2d');
    new Chart(ctxAge, {
        type: 'doughnut',
        data: {
            labels: [
                <% if(ageSalesSummary != null) { for(String[] row : ageSalesSummary) { 
                    String label = row[0];
                    if("kids".equalsIgnoreCase(label)) label="キッズ";
                    else if("youth".equalsIgnoreCase(label)) label="若者";
                    else if("adult".equalsIgnoreCase(label)) label="大人";
                    else if("senior".equalsIgnoreCase(label)) label="シニア";
                %> '<%= label %>', <% } } %>
            ],
            datasets: [{
                data: [
                    <% if(ageSalesSummary != null) { for(String[] row : ageSalesSummary) { %> <%= row[2] %>, <% } } %>
                ],
                backgroundColor: ['#2b8a3e', '#0b5ed7', '#f57c00', '#6c757d', '#adb5bd'],
                borderWidth: 2,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, font: { family: 'Noto Sans JP' } } } }
        }
    });
</script>

</body>
</html>

<%! 
    String renderTable(List<String[]> list) {
        if(list == null || list.isEmpty()) return "<p style='color:#999; font-size:12px;'>データなし🐢</p>";
        StringBuilder sb = new StringBuilder("<table><tbody>");
        int r = 1;
        for(String[] row : list) {
            sb.append("<tr><td style='width:40px;'><span class='rank-badge'>#").append(r).append("</span></td>")
              .append("<td><strong>").append(row[0]).append("</strong></td>")
              .append("<td class='text-right' style='color:#6c757d;'>").append(row[1]).append("個</td></tr>");
            r++;
        }
        sb.append("</tbody></table>");
        return sb.toString();
    }

    String renderAgeList(List<String[]> list) {
        if(list == null || list.isEmpty()) return "<span style='color:#999; font-size:12px;'>注文なし</span>";
        StringBuilder sb = new StringBuilder("<ol style='padding-left:16px; margin:5px 0; font-size:13px; color:#495057;'>");
        for(String[] row : list) {
            sb.append("<li style='margin-bottom:4px;'><strong>").append(row[0]).append("</strong> (").append(row[1]).append("個)</li>");
        }
        sb.append("</ol>");
        return sb.toString();
    }
%>