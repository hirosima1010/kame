<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // サーブレットから注文履歴の一覧を受け取る
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    
    // 日付を綺麗にフォーマットするための道具
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    
    // 売り上げの総計を計算する用
    int grandTotalSales = 0;
    if (orderList != null) {
        for (Order o : orderList) {
            grandTotalSales += o.getTotalPrice();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>注文履歴一覧 | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    body {
        font-family: 'Montserrat', 'Noto Sans JP', sans-serif;
        color: #212529;
        margin: 0;
        padding: 40px 20px;
        background-color: #f4f7f5;
    }
    .container {
        max-width: 900px;
        margin: 0 auto;
        background: #ffffff;
        padding: 35px 40px;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        border-top: 6px solid #00704A;
    }
    .header-area {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #e9ecef;
        padding-bottom: 15px;
        margin-bottom: 25px;
    }
    h1 { font-size: 24px; color: #00704A; margin: 0; font-weight: 700; }
    
    .sales-summary {
        background: #eef5f0;
        border: 1px solid #c2ebd4;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 25px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .sales-title { font-size: 14px; color: #555; font-weight: bold; }
    .sales-amount { font-size: 24px; color: #00704A; font-weight: 700; }

    /* 履歴カードスタイル */
    .history-card {
        border: 1px solid #ced4da;
        border-radius: 8px;
        margin-bottom: 15px;
        overflow: hidden;
        background: #fff;
        transition: box-shadow 0.2s;
    }
    .history-card:hover {
        box-shadow: 0 4px 12px rgba(0, 112, 74, 0.08);
    }
    .card-header {
        background: #fafafa;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        cursor: pointer;
        user-select: none;
    }
    .card-header:hover { background: #f1f3f5; }
    
    .meta-left { display: flex; flex-direction: column; gap: 4px; }
    .order-id-badge {
        display: inline-block; background: #6c757d; color:#fff; font-size: 11px; padding: 2px 6px; border-radius: 4px; width: fit-content;
    }
    .order-date { font-size: 13px; color: #666; }
    .order-staff { font-size: 14px; font-weight: bold; margin-top: 2px; }
    
    .meta-right { text-align: right; }
    .order-price { font-size: 18px; font-weight: bold; color: #00704A; }
    .style-badge {
        display: inline-block; font-size: 11px; padding: 2px 8px; border-radius: 12px; margin-top: 4px; font-weight: bold;
    }
    .badge-sea { background: #bde0fe; color: #0b5ed7; }
    .badge-land { background: #ffe3e3; color: #dc3545; }

    /* 内訳エリア（最初から表示するか、JavaScriptでトグルする） */
    .card-details {
        border-top: 1px dashed #ced4da;
        background: #fffdf8;
        padding: 15px 20px;
    }
    .detail-table { width: 100%; border-collapse: collapse; }
    .detail-table th { text-align: left; font-size: 12px; color: #868e96; padding-bottom: 8px; border-bottom: 1px solid #dee2e6; }
    .detail-table td { padding: 8px 0; font-size: 14px; border-bottom: 1px dashed #f1f3f5; }
    .text-right { text-align: right; }

    .btn-back {
        display: inline-block; background-color: #6c757d; color: #ffffff; text-decoration: none; padding: 10px 20px; font-size: 14px; font-weight: bold; border-radius: 4px; transition: background 0.2s;
    }
    .btn-back:hover { background-color: #5a6268; }
    
    .toggle-icon { font-size: 14px; color: #aaa; transition: transform 0.2s; }
    .active .toggle-icon { transform: rotate(180deg); }
</style>
</head>
<body>

<div class="container">
    
    <div class="header-area">
        <h1>📜 カメシステム注文履歴管理</h1>
        <a href="staff_main.jsp" class="btn-back">🐢 メインに戻る</a>
    </div>

    <div class="sales-summary">
        <div>
            <div class="sales-title">📈 登録済み総売上高</div>
            <div style="font-size: 11px; color: #666; margin-top: 2px;">（これまでにPostgreSQLに蓄積された全累計金額カメ）</div>
        </div>
        <div class="sales-amount">￥<%= String.format("%,d", grandTotalSales) %> -</div>
    </div>

    <% if (orderList == null || orderList.isEmpty()) { %>
        <div style="text-align: center; padding: 40px; color: #868e96;">
            まだデータベースに注文履歴がありませんカメ…💤
        </div>
    <% } else { 
        for (Order o : orderList) {
    %>
        <div class="history-card">
            <div class="card-header" onclick="toggleDetails(this)">
                <div class="meta-left">
                    <span class="order-id-badge">注文番号 #<%= o.getOrderId() %></span>
                    <span class="order-date">🕒 <%= sdf.format(o.getOrderDate()) %></span>
                    <span class="order-staff">👤 担当：<%= o.getStaffName() %></span>
                    <% if(o.getReceiptName() != null && !o.getReceiptName().trim().isEmpty()) { %>
                        <span style="font-size: 12px; color: #856404; background: #fff3cd; padding: 1px 6px; border-radius: 3px; width: fit-content; margin-top: 2px;">
                            📄 領収書宛名: <%= o.getReceiptName() %>
                        </span>
                    <% } %>
                </div>
                <div class="meta-right">
                    <div class="order-price">￥<%= String.format("%,d", o.getTotalPrice()) %></div>
                    <span class="style-badge <%= "sea".equals(o.getEatStyle()) ? "badge-sea" : "badge-land" %>">
                        <%= "sea".equals(o.getEatStyle()) ? "海中浸水" : "陸上退避" %>
                    </span>
                    <span class="toggle-icon">▼</span>
                </div>
            </div>
            
            <div class="card-details">
                <table class="detail-table">
                    <thead>
                        <tr>
                            <th>商品名</th>
                            <th class="text-right" style="width: 80px;">単価</th>
                            <th class="text-right" style="width: 60px;">数量</th>
                            <th class="text-right" style="width: 100px;">小計</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (o.getDetails() != null) {
                                for (OrderDetail d : o.getDetails()) {
                        %>
                            <tr>
                                <td><strong><%= d.getMenuName() %></strong></td>
                                <td class="text-right">￥<%= String.format("%,d", d.getPrice()) %></td>
                                <td class="text-right"><%= d.getQuantity() %></td>
                                <td class="text-right font-bold">￥<%= String.format("%,d", d.getPrice() * d.getQuantity()) %></td>
                            </tr>
                        <% 
                                }
                            } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    <% 
        } 
    } 
    %>

</div>

<script>
    // カメのアコーディオン開閉仕掛け 🐢
    function toggleDetails(header) {
        header.classList.toggle('active');
        const details = header.nextElementSibling;
        if (details.style.display === "none" || details.style.display === "") {
            details.style.display = "block";
        } else {
            details.style.display = "none";
        }
    }

    // 最初は内訳をすべて閉じておく処理
    document.querySelectorAll('.card-details').forEach(el => el.style.display = 'none');
</script>

</body>
</html>