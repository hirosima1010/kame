<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>売上実績一覧 | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    /* カメが背景をのんびり泳ぐアニメーション */
    @keyframes swim {
        0% { background-position: 0 0, 30px 30px, 0 0; }
        100% { background-position: 100px 50px, 130px 80px, -50px 100px; }
    }

    /* 全体のベース */
    body {
        font-family: 'Montserrat', 'Noto Sans JP', sans-serif;
        color: #212529;
        margin: 0;
        padding: 60px 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
        box-sizing: border-box;

        background-color: #eef5f0; 
        background-image: radial-gradient(rgba(0, 112, 74, 0.04) 20%, transparent 20%),
                          radial-gradient(rgba(0, 112, 74, 0.04) 20%, transparent 20%);
        background-size: 60px 60px;
        animation: swim 20s linear infinite; 
        
        /* マウスカーソルをカメに変更 */
        cursor: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='32' height='32' style='font-size:24px'><text y='24'>🐢</text></svg>"), auto;
    }

    /* 背景のカメ絵文字 */
    body::before {
        content: "🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢";
        font-size: 28px;
        opacity: 0.06; 
        position: fixed;
        top: 0; 
        left: 0; 
        width: 100%; 
        height: 100%;
        z-index: -2; 
        word-wrap: break-word;
        letter-spacing: 40px;
        line-height: 80px;
        padding: 20px;
        pointer-events: none;
    }

    /* コンテナ */
    .container {
        background: rgba(255, 255, 255, 0.97); 
        padding: 45px 40px;
        border-radius: 16px;
        box-shadow: 0 8px 32px rgba(0, 112, 74, 0.1); 
        max-width: 650px;
        width: 100%;
        box-sizing: border-box;
        position: relative; 
        border: 2px solid #00704A; 
    }

    .container::after {
        content: "📜";
        position: absolute;
        font-size: 24px;
        bottom: -15px;
        right: -15px;
    }

    /* ヘッダー */
    h1 {
        font-size: 24px;
        color: #00704A; 
        margin-top: 0;
        margin-bottom: 10px;
        text-align: center;
        font-weight: 700;
        letter-spacing: 1px;
    }

    .subtitle {
        font-size: 13px;
        color: #6c757d;
        text-align: center;
        margin-bottom: 30px;
    }

    /* カメのつぶやきボックス */
    .kame-report-box {
        background-color: #f1f3f5;
        border-left: 4px solid #00704A;
        padding: 12px 16px;
        border-radius: 4px;
        margin-bottom: 25px;
        font-size: 13px;
        color: #495057;
        line-height: 1.5;
    }

    /* テーブルスタイル */
    table {
        width: 100%;
        border-collapse: separate; 
        border-spacing: 0;
        margin-bottom: 20px;
    }
    th {
        border-bottom: 2px solid #00704A;
        color: #00704A;
        padding: 12px 10px;
        font-weight: 700;
        text-align: left;
        font-size: 13px;
    }
    td {
        padding: 14px 10px;
        border-bottom: 1px solid #e9ecef;
        color: #212529;
        font-size: 13px;
    }
    tr:hover td {
        background-color: #f2f7f4; 
    }

    /* カレンダースタイル風の文字、数値表記 */
    .date-text {
        font-family: 'Montserrat', sans-serif;
        color: #495057;
    }
    .id-badge {
        font-family: 'Montserrat', sans-serif;
        background-color: #e2e8f0;
        color: #475569;
        padding: 2px 6px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: bold;
    }
    .price-col {
        text-align: right;
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
    }
    
    /* 総合計行 */
    .row-total td {
        background-color: #00704A;
        color: #ffffff;
        font-size: 15px;
        font-weight: bold;
        border-top: 2px solid #004d34;
        border-bottom: none; 
    }
    .row-total td:first-child {
        border-radius: 0 0 0 8px;
    }
    .row-total td:last-child {
        border-radius: 0 0 8px 0;
    }

    /* 空っぽのとき */
    .empty-message {
        text-align: center;
        padding: 40px 0;
        color: #868e96;
        font-size: 14px;
    }

    /* 戻るリンク */
    .back-link {
        display: block;
        text-align: center;
        color: #00704A;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        margin-top: 10px;
    }
    .back-link:hover { text-decoration: underline; }
</style>
</head>
<body>

    <%
        // 【対策】Sales型を使わず、汎用的なListオブジェクトとして安全に取得
        List<?> salesList = (List<?>) request.getAttribute("salesList");
        
        int totalSales = 0;
        int salesCount = 0;
        
        if (salesList != null) {
            salesCount = salesList.size();
            // 合計金額の計算はJavaリフレクション（型が不明でもメソッドを強制実行する技）で安全に処理
            for (Object obj : salesList) {
                try {
                    java.lang.reflect.Method method = obj.getClass().getMethod("getAmount");
                    Integer amount = (Integer) method.invoke(obj);
                    if (amount != null) {
                        totalSales += amount;
                    }
                } catch (Exception e) {
                    // 万が一メソッドが呼べなくてもエラーで落とさない
                }
            }
        }

        // 件数に応じたカメのコメント
        String statusComment = "";
        if (salesCount == 0) {
            statusComment = "🐢「まだ今日の注文履歴はないみたいやね。のんびり最初の波が来るのを待とうか…」";
        } else if (salesCount < 5) {
            statusComment = "🐢「ポツポツと注文が入っとるね。カメの歩みのごとく、1歩ずつ確実に売上を重ねていこか！」";
        } else {
            statusComment = "🐢「おぉ、大繁盛やん！伝票が甲羅みたいに積み重なっとる。働きガメのみんな、ほんまにお疲れ様やで！」";
        }
    %>

<div class="container">
    <h1>🐢 売上実績一覧（航海ログ） 📜</h1>
    <div class="subtitle">Cafe kame Sales History</div>
    
    <!-- カメ店長の状況つぶやき -->
    <div class="kame-report-box">
        <%= statusComment %>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>売上日時（漂流時刻）</th>
                <th>注文ID</th>
                <th style="text-align: right;">合計金額</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (salesList != null && !salesList.isEmpty()) {
                    for (Object sales : salesList) {
                        // 【対策】型エラーを避けるため、各値もリフレクションで動的に引っ張る
                        String dateTime = "";
                        int orderId = 0;
                        int amount = 0;
                        try {
                            dateTime = String.valueOf(sales.getClass().getMethod("getDateTime").invoke(sales));
                            orderId = (Integer) sales.getClass().getMethod("getOrderId").invoke(sales);
                            amount = (Integer) sales.getClass().getMethod("getAmount").invoke(sales);
                        } catch(Exception e) {
                            dateTime = "データエラー";
                        }
            %>
            <tr>
                <td class="date-text"><%= dateTime %></td>
                <td><span class="id-badge">ID: <%= orderId %></span></td>
                <td class="price-col"><%= String.format("%,d", amount) %> 円</td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="3" class="empty-message">
                    🏝️ まだ売上データがありまへん。<br>のんびりお茶でも飲んで待ちまひょ。
                </td>
            </tr>
            <%
                }
            %>
            
            <% if (salesList != null && !salesList.isEmpty()) { %>
            <tr class="row-total">
                <td colspan="2" style="text-align: right;">🐢 総合計（すべての甲羅）：</td>
                <td class="price-col"><%= String.format("%,d", totalSales) %> 円</td>
            </tr>
            <% } %>
        </tbody>
    </table>
    
    <a href="main.jsp" class="back-link">🐢 陸（メインページ）に戻る</a>
</div>

</body>
</html>