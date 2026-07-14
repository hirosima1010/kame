<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Purchase" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Purchase> purchaseList = (List<Purchase> ) request.getAttribute("purchaseList");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    
    // 累計発注金額の計算
    int totalCost = 0;
    if (purchaseList != null) {
        for (Purchase p : purchaseList) {
            totalCost += (p.getPrice() * p.getQuantity());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>発注・仕入れ管理 | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    body { font-family: 'Montserrat', 'Noto Sans JP', sans-serif; background-color: #f8f9fa; color: #333; margin: 0; padding: 30px 20px; }
    .container { max-width: 900px; margin: 0 auto; }
    
    .header { display: flex; justify-content: space-between; align-items: center; background: #00704A; color: white; padding: 20px 30px; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,112,74,0.15); margin-bottom: 30px; }
    .header h1 { margin: 0; font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
    .btn-back { background: rgba(255,255,255,0.15); color: white; border: 1px solid rgba(255,255,255,0.3); text-decoration: none; padding: 10px 18px; border-radius: 8px; font-weight: bold; font-size: 13px; transition: all 0.2s; }
    .btn-back:hover { background: rgba(255,255,255,0.25); }

    .cost-summary { background: #856404; color: white; padding: 20px 25px; border-radius: 16px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 16px rgba(0,0,0,0.05); background-color: #b45309; }
    .cost-title { font-size: 13px; opacity: 0.9; font-weight: bold; letter-spacing: 0.5px; }
    .cost-amount { font-size: 28px; font-weight: 700; }

    .grid-layout { display: grid; grid-template-columns: 1fr 2fr; gap: 25px; }
    @media (max-width: 768px) { .grid-layout { grid-template-columns: 1fr; } }

    .card-box { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.03); border: 1px solid #edf2f7; height: fit-content; }
    .card-title { font-size: 15px; color: #00704A; font-weight: 700; margin-top: 0; margin-bottom: 20px; border-bottom: 2px solid #f1f3f5; padding-bottom: 10px; }

    /* フォームスタイル */
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; font-size: 12px; font-weight: 600; color: #4a5568; margin-bottom: 6px; }
    .form-control { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 8px; font-size: 14px; box-sizing: border-box; font-family: inherit; }
    .form-control:focus { outline: none; border-color: #00704A; box-shadow: 0 0 0 3px rgba(0,112,74,0.1); }
    .btn-submit { width: 100%; background: #00704A; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: bold; font-size: 14px; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
    .btn-submit:hover { background: #1b5e20; }

    /* テーブルスタイル */
    table { width: 100%; border-collapse: collapse; }
    th { text-align: left; color: #718096; font-size: 12px; padding-bottom: 12px; border-bottom: 1px solid #edf2f7; font-weight: 600; }
    td { padding: 14px 8px; border-bottom: 1px solid #f8f9fa; font-size: 14px; color: #2d3748; }
    .text-right { text-align: right; }
    .item-name { font-weight: 700; color: #1a202c; }
    .staff-badge { font-size: 11px; background: #f1f3f5; color: #4a5568; padding: 2px 6px; border-radius: 4px; }
</style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>📦 カメカフェ発注・仕入れ管理</h1>
        <a href="staff_main.jsp" class="btn-back">メインへ戻る</a>
    </div>

    <!-- 累計経費サマリー -->
    <div class="cost-summary">
        <div>
            <div class="cost-title">☕ TOTAL PURCHASE EXPENSES</div>
            <div style="font-size: 11px; opacity: 0.8; margin-top: 4px;">現在の原材料・資材仕入れ総額</div>
        </div>
        <div class="cost-amount">￥<%= String.format("%,d", totalCost) %></div>
    </div>

    <div class="grid-layout">
        <!-- 左側：発注登録フォーム -->
        <div class="card-box">
            <div class="card-title">📝 新しい発注の記録</div>
            <form action="${pageContext.request.contextPath}/purchase" method="post">
                <div class="form-group">
                    <label>品目・アイテム名</label>
                    <input type="text" name="itemName" class="form-control" placeholder="例: コーヒー豆(ブラジル)" required>
                </div>
                <div class="form-group">
                    <label>数量</label>
                    <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                </div>
                <div class="form-group">
                    <label>購入単価 (税抜)</label>
                    <input type="number" name="price" class="form-control" min="0" placeholder="￥" required>
                </div>
                <button type="submit" class="btn-submit">📦 DBへ発注を記録する</button>
            </form>
        </div>

        <!-- 右側：発注履歴一覧 -->
        <div class="card-box">
            <div class="card-title">📜 直近の仕入れログ一覧</div>
            <% if (purchaseList == null || purchaseList.isEmpty()) { %>
                <p style="color: #a0aec0; text-align: center; padding: 30px 0;">まだ発注データが記録されていません🐢</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>発注日時 / 担当</th>
                            <th>品目名</th>
                            <th class="text-right">単価</th>
                            <th class="text-right">数量</th>
                            <th class="text-right">合計</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Purchase p : purchaseList) { %>
                            <tr>
                                <td style="font-size: 12px; color: #718096;">
                                    <%= sdf.format(p.getPurchaseDate()) %><br>
                                    <span class="staff-badge">👤 <%= p.getStaffName() %></span>
                                </td>
                                <td class="item-name"><%= p.getItemName() %></td>
                                <td class="text-right" style="color: #4a5568;">￥<%= String.format("%,d", p.getPrice()) %></td>
                                <td class="text-right" style="font-weight: 600;"><%= p.getQuantity() %></td>
                                <td class="text-right" style="font-weight: 700; color: #b45309;">
                                    ￥<%= String.format("%,d", p.getPrice() * p.getQuantity()) %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>