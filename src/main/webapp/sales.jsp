<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="java.util.Calendar" %>
<%
    List<Order> allOrders = (List<Order>) request.getAttribute("allOrders");
    
    // 期間別ランキングの受け取り
    List<String[]> rankDay = (List<String[]>) request.getAttribute("rankDay");
    List<String[]> rankMonth = (List<String[]>) request.getAttribute("rankMonth");
    List<String[]> rankYear = (List<String[]>) request.getAttribute("rankYear");
    
    // 年齢別ランキングの受け取り
    List<String[]> rankKids = (List<String[]>) request.getAttribute("rankKids");
    List<String[]> rankYouth = (List<String[]>) request.getAttribute("rankYouth");
    List<String[]> rankAdult = (List<String[]>) request.getAttribute("rankAdult");
    List<String[]> rankSenior = (List<String[]>) request.getAttribute("rankSenior");
    
    // 年齢別売上サマリー
    List<String[]> ageSalesSummary = (List<String[]>) request.getAttribute("ageSalesSummary");

    // サーブレット側でnullや型に不整合があっても落ちないように安全に取得
    int seaCount = request.getAttribute("seaCount") != null ? (Integer) request.getAttribute("seaCount") : 0;
    int landCount = request.getAttribute("landCount") != null ? (Integer) request.getAttribute("landCount") : 0;

    // 今日の売上集計（Java側）
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
<title>超多機能 売上分析モニタ | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    body { font-family: 'Montserrat', 'Noto Sans JP', sans-serif; background-color: #f4f7f5; margin: 0; padding: 30px 20px; }
    .container { max-width: 1100px; margin: 0 auto; }
    .header { display: flex; justify-content: space-between; align-items: center; background: #00704A; color: white; padding: 20px 30px; border-radius: 12px; margin-bottom: 25px; }
    .btn-back { background: white; color: #00704A; text-decoration: none; padding: 8px 16px; border-radius: 6px; font-weight: bold; }
    
    .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 25px; }
    .kpi-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); border-left: 5px solid #00704A; }
    .kpi-title { font-size: 13px; color: #666; font-weight: bold; }
    .kpi-value { font-size: 26px; font-weight: 700; margin-top: 5px; }

    /* 📊 タブメニューのスタイリング */
    .tab-container { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 25px; }
    .tab-buttons { display: flex; gap: 10px; border-bottom: 2px solid #eef5f0; padding-bottom: 10px; margin-bottom: 20px; }
    .tab-btn { background: #eee; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer; color: #555; font-size: 14px; }
    .tab-btn.active { background: #00704A; color: white; }
    .tab-content { display: none; }
    .tab-content.active { display: block; }

    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th { text-align: left; color: #868e96; font-size: 12px; padding-bottom: 10px; border-bottom: 1px solid #dee2e6; }
    td { padding: 12px 6px; border-bottom: 1px dashed #eee; font-size: 14px; }
    .rank-badge { background: #eef5f0; color: #00704A; font-weight: bold; padding: 2px 8px; border-radius: 20px; font-size: 11px; }
    .text-right { text-align: right; }
    
    .age-box-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; margin-top: 15px; }
    .age-card { background: #fffdf8; border: 1px solid #f1e4bf; padding: 15px; border-radius: 8px; }
    .age-title { font-weight: bold; color: #856404; font-size: 14px; border-bottom: 1px solid #f1e4bf; padding-bottom: 5px; margin-bottom: 8px; }
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
        <h1>📊 ガチ業務用・最強売上多機能ダッシュボード</h1>
        <a href="staff_main.jsp" class="btn-back">🐢 メインへ戻る</a>
    </div>

    <div class="dashboard-grid">
        <div class="kpi-card" style="border-left-color: #2b8a3e;"><div class="kpi-title">📈 本日の総売上高</div><div class="kpi-value" style="color: #2b8a3e;">￥<%= String.format("%,d", todaySales) %>-</div></div>
        <div class="kpi-card" style="border-left-color: #0b5ed7;"><div class="kpi-title">🛒 本日の総注文数</div><div class="kpi-value" style="color: #0b5ed7;"><%= todayOrderCount %> 卓</div></div>
        <div class="kpi-card" style="border-left-color: #f57c00;"><div class="kpi-title">👥 本日の客単価</div><div class="kpi-value" style="color: #f57c00;">￥<%= String.format("%,d", averageSpent) %>-</div></div>
    </div>

    <div class="tab-container">
        <div class="tab-buttons">
            <button class="tab-btn active" onclick="switchTab('tab-period', this)">📅 期間別ランキング（日・月・年）</button>
            <button class="tab-btn" onclick="switchTab('tab-age-rank', this)">👑 年齢層別の人気メニュー</button>
            <button class="tab-btn" onclick="switchTab('tab-age-sales', this)">💰 年齢層別の売上貢献度</button>
        </div>

        <div id="tab-period" class="tab-content active">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
                <div>
                    <h3 style="color:#00704A; border-bottom:2px solid #00704A; padding-bottom:5px;">☀️ 本日の人気 TOP5</h3>
                    <%= renderTable(rankDay) %>
                </div>
                <div>
                    <h3 style="color:#0b5ed7; border-bottom:2px solid #0b5ed7; padding-bottom:5px;">🌙 今月の人気 TOP5</h3>
                    <%= renderTable(rankMonth) %>
                </div>
                <div>
                    <h3 style="color:#f57c00; border-bottom:2px solid #f57c00; padding-bottom:5px;">🌋 今年の人気 TOP5</h3>
                    <%= renderTable(rankYear) %>
                </div>
            </div>
        </div>

        <div id="tab-age-rank" class="tab-content">
            <h3 style="margin-top:0;">👤 年齢層別の売れ筋メニュー（各TOP 3）</h3>
            <div class="age-box-grid">
                <div class="age-card"><div class="age-title">👧 キッズ（12歳以下）</div><%= renderAgeList(rankKids) %></div>
                <div class="age-card"><div class="age-title">⚡ 若者・学生（10〜20代）</div><%= renderAgeList(rankYouth) %></div>
                <div class="age-card"><div class="age-title">💼 大人（30〜50代）</div><%= renderAgeList(rankAdult) %></div>
                <div class="age-card"><div class="age-title">👴 シニア（60歳以上）</div><%= renderAgeList(rankSenior) %></div>
            </div>
        </div>

        <div id="tab-age-sales" class="tab-content">
            <h3 style="margin-top:0;">💰 どの客層が一番お店に貢献しているか？</h3>
            <table>
                <thead>
                    <tr><th>年齢層</th><th class="text-right">総注文数</th><th class="text-right">累計売上総額</th></tr>
                </thead>
                <tbody>
                    <% if(ageSalesSummary == null || ageSalesSummary.isEmpty()) { %>
                        <tr><td colspan="3" style="text-align:center; color:#999;">データがありません</td></tr>
                    <% } else { 
                        for(String[] row : ageSalesSummary) {
                            String displayAge = row[0];
                            if(displayAge != null) {
                                // 💡 小文字・大文字どちらが来ても絶対にヒットするようにequalsIgnoreCaseに変更カメ！
                                if("kids".equalsIgnoreCase(displayAge)) displayAge="キッズ(12歳以下)";
                                else if("youth".equalsIgnoreCase(displayAge)) displayAge="若者・学生";
                                else if("adult".equalsIgnoreCase(displayAge)) displayAge="大人";
                                else if("senior".equalsIgnoreCase(displayAge)) displayAge="シニア";
                                else if("unknown".equalsIgnoreCase(displayAge)) displayAge="不明（未選択）";
                            } else {
                                displayAge = "不明";
                            }
                    %>
                        <tr>
                            <td><strong><%= displayAge %></strong></td>
                            <td class="text-right"><%= row[1] %> 回</td>
                            <td class="text-right" style="font-weight:bold; color:#2b8a3e;">￥<%= String.format("%,d", Integer.parseInt(row[2])) %></td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>

<%! 
    // テーブルを描画するための共通関数カメ 🐢
    String renderTable(List<String[]> list) {
        if(list == null || list.isEmpty()) return "<p style='color:#999; font-size:12px;'>データなしカメ 🐢</p>";
        StringBuilder sb = new StringBuilder("<table><thead><tr><th>順位</th><th>メニュー</th><th class='text-right'>数</th></tr></thead><tbody>");
        int r = 1;
        for(String[] row : list) {
            sb.append("<tr><td><span class='rank-badge'>#").append(r).append("</span></td>")
              .append("<td><strong>").append(row[0]).append("</strong></td>")
              .append("<td class='text-right'>").append(row[1]).append("個</td></tr>");
            r++;
        }
        sb.append("</tbody></table>");
        return sb.toString();
    }

    // 💡 修正：年齢層別の簡易リスト（データがないときは「これから集計カメ！」にする）
    String renderAgeList(List<String[]> list) {
        if(list == null || list.isEmpty()) return "<span style='color:#999; font-size:12px; display:block; margin-top:5px;'>💡 まだ注文がありません</span>";
        StringBuilder sb = new StringBuilder("<ol style='padding-left:18px; margin:5px 0; font-size:13px;'>");
        for(String[] row : list) {
            sb.append("<li style='margin-bottom:4px;'><strong>").append(row[0]).append("</strong> (").append(row[1]).append("個)</li>");
        }
        sb.append("</ol>");
        return sb.toString();
    }
%>