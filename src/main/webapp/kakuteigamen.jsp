<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // 💡 文字化け対策
    request.setCharacterEncoding("UTF-8");

    // サーブレットからセッション経由で安全に確定データを受け取るカメ！
    String eatStyle = (String) session.getAttribute("complete_eatStyle");
    String myKameShell = (String) session.getAttribute("complete_myKameShell");
    String needReceipt = (String) session.getAttribute("complete_needReceipt");
    String finalReceiptName = (String) session.getAttribute("complete_finalReceiptName");
    String currentStaffName = (String) session.getAttribute("complete_staffName");
    
    if (currentStaffName == null) {
        currentStaffName = "ゲストスタッフ";
    }

    // すでに計算済みの確定リストを取得
    List<String[]> orderedList = (List<String[]>) session.getAttribute("complete_orderedList");
    if (orderedList == null) {
        orderedList = new ArrayList<String[]>();
    }
    
    // 💡 型の不一致を完全に防ぐ安全なデータ取得処理カメ！
    int subTotal = 0;
    int discount = 0;
    int finalTotal = 0;
    
    if (session.getAttribute("complete_subTotal") != null) {
        subTotal = Integer.parseInt(session.getAttribute("complete_subTotal").toString());
    }
    if (session.getAttribute("complete_discount") != null) {
        discount = Integer.parseInt(session.getAttribute("complete_discount").toString());
    }
    if (session.getAttribute("complete_finalTotal") != null) {
        finalTotal = Integer.parseInt(session.getAttribute("complete_finalTotal").toString());
    }
    
    int kamePoint = finalTotal / 100;

    // カメランク判定
    String kameRank = "見習いガメ";
    String kameComment = "のんびり厨房で作っとるから、万年くらい待っててな〜。";
    if (finalTotal >= 50000) {
        kameRank = "伝説の玄武";
        kameComment = "圧倒的感謝…！この卓のお客様、もしや竜宮城のオーナー様カメ！？";
    } else if (finalTotal >= 10000) {
        kameRank = "深海のボスウミガメ";
        kameComment = "甲羅がピカピカに輝くほどの素晴らしいご注文、ありがとな！";
    } else if (finalTotal >= 3000) {
        kameRank = "エリート陸ガメ";
        kameComment = "たくさん召し上がって、のんびり強い甲羅を育ててほしいカメ。";
    } else if (finalTotal > 0) {
        kameRank = "普通のミドリガメ";
        kameComment = "ご注文ありがとな！のんびり厨房で作っとるから待っててな〜。";
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>注文完了 | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    @keyframes swim {
        0% { background-position: 0 0, 30px 30px, 0 0; }
        100% { background-position: 100px 50px, 130px 80px, -50px 100px; }
    }

    body {
        font-family: 'Montserrat', 'Noto Sans JP', sans-serif;
        color: #212529;
        margin: 0;
        padding: 60px 20px;
        background-color: #eef5f0; 
        background-image: radial-gradient(rgba(0, 112, 74, 0.04) 20%, transparent 20%),
                          radial-gradient(rgba(0, 112, 74, 0.04) 20%, transparent 20%);
        background-size: 60px 60px;
        animation: swim 25s linear infinite; 
    }

    body.style-sea {
        background: linear-gradient(to bottom, #eef5f0 0%, #bde0fe 100%) fixed;
    }

    .layout-wrapper {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        max-width: 1100px;
        margin: 0 auto;
        gap: 30px;
        position: relative;
    }

    .container {
        background: rgba(255, 255, 255, 0.97); 
        padding: 45px 40px;
        border-radius: 16px;
        box-shadow: 0 8px 32px rgba(0, 112, 74, 0.15); 
        max-width: 600px;
        width: 100%;
        box-sizing: border-box;
        border: 2px solid #00704A; 
        text-align: center;
        flex-shrink: 0;
    }

    .side-ad-banner {
        width: 160px;
        height: 600px;
        background-color: #f8f9fa;
        border: 1px dashed #adb5bd;
        border-radius: 8px;
        box-sizing: border-box;
        padding: 15px 10px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        align-items: center;
        text-align: center;
        position: sticky;
        top: 40px;
        flex-shrink: 0;
    }
    .ad-label { font-size: 10px; color: #868e96; letter-spacing: 1px; font-weight: bold; }
    .ad-content { font-size: 13px; color: #212529; font-weight: bold; line-height: 1.5; }
    .ad-dummy-img {
        width: 100%; height: 120px; background: #e9ecef; border-radius: 6px;
        display: flex; justify-content: center; align-items: center; font-size: 28px; color: #6c757d; margin: 10px 0;
    }

    @media (max-width: 1024px) {
        .side-ad-banner { display: none; }
        .layout-wrapper { gap: 0; }
    }

    .success-icon { font-size: 48px; margin-bottom: 10px; }
    h1 { font-size: 26px; color: #00704A; margin-top: 0; font-weight: 700; letter-spacing: 1px; }

    .thank-you-msg {
        font-size: 15px;
        color: #495057;
        line-height: 1.6;
        background: #f1f3f5;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 30px;
        border-left: 4px solid #00704A;
        text-align: left;
    }

    .staff-badge {
        display: inline-block;
        background: #00704A;
        color: #fff;
        padding: 3px 10px;
        font-size: 12px;
        border-radius: 4px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .bill-card {
        border: 1px solid #ced4da; border-radius: 8px; padding: 20px; background: #fff; text-align: left; margin-bottom: 25px;
    }
    .bill-title {
        font-size: 14px; font-weight: bold; color: #00704A; border-bottom: 2px dashed #00704A; padding-bottom: 8px; margin-bottom: 12px;
        display: flex; justify-content: space-between;
    }

    table { width: 100%; border-collapse: collapse; }
    td { padding: 10px 4px; font-size: 14px; border-bottom: 1px dashed #e9ecef; }
    .text-right { text-align: right; }
    .font-bold { font-weight: bold; }

    .summary-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; }
    .total-row { border-top: 2px solid #00704A; margin-top: 10px; padding-top: 12px; font-size: 20px; color: #00704A; }

    .receipt-box {
        background: #fffdf5; border: 2px dashed #e6c645; border-radius: 8px; padding: 20px; text-align: left; margin-bottom: 25px; position: relative;
    }
    .receipt-box::before {
        content: "カメ印"; position: absolute; bottom: 15px; right: 30px; width: 55px; height: 55px;
        border: 2px solid rgba(230, 75, 75, 0.6); color: rgba(230, 75, 75, 0.6); border-radius: 50%;
        text-align: center; line-height: 55px; font-size: 12px; font-weight: bold; transform: rotate(-15deg);
    }

    .kame-badge-box {
        display: flex; justify-content: space-between; align-items: center; background: #eef5f0; padding: 10px 15px; border-radius: 30px; margin-bottom: 30px; border: 1px solid #c2ebd4;
    }
    .badge-title { font-size: 12px; color: #555; }
    .badge-value { font-size: 14px; font-weight: bold; color: #00704A; }

    .btn-home {
        display: inline-block; background-color: #00704A; color: #ffffff; text-decoration: none; padding: 14px 35px; font-size: 15px; font-weight: 700; border-radius: 50px;
    }
</style>
</head>
<body class="<%= "sea".equals(eatStyle) ? "style-sea" : "" %>">

<div class="layout-wrapper">

    <div class="side-ad-banner">
        <div class="ad-label">SPONSORED</div>
        <div>
            <div class="ad-content" style="color: #d90429;">万年走れる!?</div>
            <div class="ad-content">驚異の超長寿<br>100%化学合成<br>カメパワーオイル</div>
            <div class="ad-dummy-img">⚙️🏍️</div>
            <div class="ad-content" style="font-size: 11px; color: #666; font-weight: normal; margin-top:10px;">超高回転のエンジンでも、のんびり走るカメ並みに超長持ち！高粘度設計。</div>
        </div>
        <div class="ad-label">kame-rider-ads</div>
    </div>

    <div class="container">
        <div class="success-icon">
            <%= orderedList.isEmpty() ? "🐢💤" : "🐢🎉" %>
        </div>
        <h1>注文登録の完了</h1>
        
        <div class="thank-you-msg">
            <div class="staff-badge">担当スタッフ：<%= currentStaffName %></div><br>
            注文のデータベース登録、および厨房への送信が正常に完了したカメ！<br>
            <%= kameComment %><br>
            <span style="font-size: 12px; color: #868e96;">※スタイル：<%= "sea".equals(eatStyle) ? "イートイン（海中浸水）" : "テイクアウト（陸上退避）" %></span>
        </div>

        <div class="bill-card">
            <div class="bill-title">
                <span>📄 お品書き注文明細</span>
                <span>cafe kame</span>
            </div>
            <table>
                <tbody>
                    <% if(orderedList.isEmpty()) { %>
                        <tr>
                            <td colspan="2" style="text-align: center; color: #868e96;">注文されたメニューはありませんカメ…</td>
                        </tr>
                    <% } else { 
                        for(String[] item : orderedList) {
                    %>
                        <tr>
                            <td>
                                <strong><%= item[0] %></strong><br>
                                <span style="font-size: 11px; color:#868e96;"><%= String.format("%,d", Integer.parseInt(item[1])) %>円 × <%= item[2] %></span>
                            </td>
                            <td class="text-right font-bold" style="vertical-align: middle;"><%= String.format("%,d", Integer.parseInt(item[3])) %> 円</td>
                        </tr>
                    <% 
                        }
                    } 
                    %>
                </tbody>
            </table>
            
            <div style="margin-top: 15px;">
                <div class="summary-row">
                    <span>小計</span>
                    <span><%= String.format("%,d", subTotal) %> 円</span>
                </div>
                <% if(discount > 0) { %>
                <div class="summary-row" style="color: #2b8a3e;">
                    <span>🌱 マイ甲羅割引</span>
                    <span>-<%= discount %> 円</span>
                </div>
                <% } %>
                <div class="summary-row total-row font-bold">
                    <span>最終お会計合計</span>
                    <span><%= String.format("%,d", finalTotal) %> 円</span>
                </div>
            </div>
        </div>

        <% if(needReceipt != null && "true".equals(needReceipt)) { %>
        <div class="receipt-box">
            <div style="text-align: center; font-weight: bold; font-size: 16px; letter-spacing: 4px; margin-bottom: 10px; color:#856404;">領 収 書</div>
            <div style="font-size: 15px; border-bottom: 1px solid #212529; padding-bottom: 5px; margin-bottom: 15px;">
                <strong><%= (finalReceiptName != null && !finalReceiptName.trim().isEmpty()) ? finalReceiptName : "お客様 殿" %></strong>
            </div>
            <div style="font-size: 22px; text-align: center; font-weight: bold; margin-bottom: 15px; font-family: 'Montserrat';">
                ￥<%= String.format("%,d", finalTotal) %> -
            </div>
            <div style="font-size: 12px; color: #555;">
                但し、のんびりカメカフェ利用代金として上記正に領収いたしました。<br>
                <span style="font-size: 10px; color: #868e96;">※お客様の甲羅に貼って保管するようお伝えください。</span>
            </div>
        </div>
        <% } %>

        <div class="kame-badge-box">
            <div>
                <span class="badge-title">付与予定ポイント:</span>
                <span class="badge-value" style="margin-left: 5px;"><%= String.format("%,d", kamePoint) %> pt</span>
            </div>
            <div>
                <span class="badge-title">この卓のカメ度:</span>
                <span class="badge-value" style="color: #0b5ed7; margin-left: 5px;"><%= kameRank %></span>
            </div>
        </div>

        <div>
            <a href="staff_main.jsp" class="btn-home">🐢 マイページへ戻る</a>
        </div>
    </div>

    <div class="side-ad-banner">
        <div class="ad-label">SPONSORED</div>
        <div>
            <div class="ad-content" style="color: #028090;">ライダー必須！</div>
            <div class="ad-content">万が一の転倒に！<br>リアル甲羅構造<br>最強チェストガード</div>
            <div class="ad-dummy-img">🛡️🏍️🐢</div>
            <div class="ad-content" style="font-size: 11px; color: #666; font-weight: normal; margin-top:10px;">どんな衝撃もハネ返す、ウミガメの背中を科学した特許素材。これで峠攻めも安心。</div>
        </div>
        <div class="ad-label">kame-rider-ads</div>
    </div>

</div>

</body>
</html>