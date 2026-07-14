<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    
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
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    body { font-family: 'Montserrat', 'Noto Sans JP', sans-serif; color: #333; margin: 0; padding: 40px 20px; background-color: #f8f9fa; }
    .container { max-width: 850px; margin: 0 auto; }
    
    .header-area { display: flex; justify-content: space-between; align-items: center; background: white; padding: 20px 30px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.02); margin-bottom: 25px; }
    h1 { font-size: 20px; color: #00704A; margin: 0; font-weight: 700; display: flex; align-items: center; gap: 8px; }
    .btn-back { display: inline-block; background-color: #f1f3f5; color: #495057; text-decoration: none; padding: 10px 20px; font-size: 13px; font-weight: bold; border-radius: 8px; transition: all 0.2s; }
    .btn-back:hover { background-color: #e9ecef; }
    
    .sales-summary { background: #00704A; color: white; padding: 25px; border-radius: 16px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 16px rgba(0,112,74,0.15); }
    .sales-title { font-size: 13px; opacity: 0.8; font-weight: bold; letter-spacing: 0.5px; }
    .sales-amount { font-size: 32px; font-weight: 700; font-family: 'Montserrat', sans-serif; }

    /* 📄 レシート風の履歴カード */
    .history-card { border: none; border-radius: 16px; margin-bottom: 16px; overflow: hidden; background: #fff; box-shadow: 0 4px 16px rgba(0,0,0,0.03); transition: all 0.2s ease; }
    .history-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0, 112, 74, 0.08); }
    
    .card-header { padding: 20px 25px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; user-select: none; }
    .card-header:hover { background: #fafafa; }
    
    .meta-left { display: flex; flex-direction: column; gap: 6px; }
    .order-id-badge { display: inline-block; background: #eef5f0; color: #00704A; font-size: 11px; font-weight: 700; padding: 4px 8px; border-radius: 6px; width: fit-content; }
    .order-date { font-size: 12px; color: #868e96; }
    .order-staff { font-size: 14px; color: #495057; font-weight: 500; }
    
    .meta-right { text-align: right; display: flex; flex-direction: column; align-items: flex-end; gap: 6px; }
    .order-price { font-size: 20px; font-weight: 700; color: #212529; }
    
    .style-badge { display: inline-block; font-size: 11px; padding: 4px 10px; border-radius: 20px; font-weight: bold; }
    .badge-sea { background: #e7f3ff; color: #0b5ed7; }
    .badge-land { background: #fff0f0; color: #dc3545; }

    /* 内訳ドロップダウン */
    .card-details { border-top: 1px dashed #edf2f7; background: #fdfdfd; padding: 20px 25px; display: none; }
    .detail-table { width: 100%; border-collapse: collapse; }
    .detail-table th { text-align: left; font-size: 12px; color: #a0aec0; padding-bottom: 10px; border-bottom: 1px solid #edf2f7; text-transform: uppercase; }
    .detail-table td { padding: 12px 0; font-size: 14px; color: #495057; border-bottom: 1px solid #f8f9fa; }
    .text-right { text-align: right; }
    
    .toggle-icon { font-size: 12px; color: #cbd5e0; transition: transform 0.2s; margin-left: 5px; }
    .active .toggle-icon { transform: rotate(180deg); color: #00704A; }
</style>
</head>
<body>

<div class="container">
    
    <div class="header-area">
        <h1>📜 注文履歴ログマネジメント</h1>
        <a href="staff_main.jsp" class="btn-back">🐢 メインに戻る</a>
    </div>

    <div class="sales-summary">
        <div>
            <div class="sales-title">📦 POSTGRESQL ACCUMULATED SALES</div>
            <div style="font-size: 11px; opacity: 0.7; margin-top: 4px;">データベース累計金額</div>
        </div>
        <div class="sales-amount">￥<%= String.format("%,d", grandTotalSales) %></div>
    </div>

    <% if (orderList == null || orderList.isEmpty()) { %>
        <div style="text-align: center; padding: 50px; color: #a0aec0; background: white; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.02);">
            💤 まだデータベースに履歴が刻まれていません
        </div>
    <% } else { 
        for (Order o : orderList) {
    %>
        <div class="history-card">
            <div class="card-header" onclick="toggleDetails(this)">
                <div class="meta-left">
                    <span class="order-id-badge">ORDER #<%= o.getOrderId() %></span>
                    <span class="order-date">🕒 <%= sdf.format(o.getOrderDate()) %></span>
                    <span class="order-staff">👤 担当: <%= o.getStaffName() %></span>
                    <% if(o.getReceiptName() != null && !o.getReceiptName().trim().isEmpty()) { %>
                        <span style="font-size: 12px; color: #b45309; background: #fffbeb; padding: 2px 8px; border-radius: 6px; width: fit-content;">
                            📄 宛名: <%= o.getReceiptName() %>
                        </span>
                    <% } %>
                </div>
                <div class="meta-right">
                    <div class="order-price">￥<%= String.format("%,d", o.getTotalPrice()) %><span class="toggle-icon">▼</span></div>
                    <span class="style-badge <%= "sea".equals(o.getEatStyle()) ? "badge-sea" : "badge-land" %>">
                        <%= "sea".equals(o.getEatStyle()) ? "🌊 海中浸水" : "⛰️ 陸上退避" %>
                    </span>
                </div>
            </div>
            
            <div class="card-details">
                <table class="detail-table">
                    <thead>
                        <tr>
                            <th>商品名</th>
                            <th class="text-right" style="width: 100px;">単価</th>
                            <th class="text-right" style="width: 80px;">数量</th>
                            <th class="text-right" style="width: 120px;">小計</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (o.getDetails() != null) {
                                for (OrderDetail d : o.getDetails()) {
                        %>
                            <tr>
                                <td><strong><%= d.getMenuName() %></strong></td>
                                <td class="text-right" style="color: #718096;">￥<%= String.format("%,d", d.getPrice()) %></td>
                                <td class="text-right" style="font-weight: 600;"><%= d.getQuantity() %></td>
                                <td class="text-right" style="font-weight:700; color:#00704A;">￥<%= String.format("%,d", d.getPrice() * d.getQuantity()) %></td>
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
    function toggleDetails(header) {
        header.classList.toggle('active');
        const details = header.nextElementSibling;
        if (details.style.display === "block") {
            details.style.display = "none";
        } else {
            details.style.display = "block";
        }
    }
</script>

</body>
</html>