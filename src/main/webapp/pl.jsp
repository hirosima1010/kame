<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>甲羅勘定（損益計算書） | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    body { font-family: 'Montserrat', 'Noto Sans JP', sans-serif; background-color: #f8f9fa; color: #333; margin: 0; padding: 40px 20px; display: flex; justify-content: center; }
    .container { max-width: 600px; width: 100%; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); border-top: 6px solid #00704A; position: relative; }
    
    h1 { font-size: 22px; color: #00704A; margin-top: 0; margin-bottom: 5px; text-align: center; font-weight: 700; }
    .subtitle { font-size: 12px; color: #a0aec0; text-align: center; margin-bottom: 25px; text-transform: uppercase; font-weight: 600; }
    
    /* 🐢 カメのアドバイスボックス */
    .kame-report-box { background-color: #f7fafc; border-left: 4px solid #00704A; padding: 16px; border-radius: 8px; margin-bottom: 30px; font-size: 13px; color: #4a5568; line-height: 1.6; box-shadow: inset 0 1px 3px rgba(0,0,0,0.01); }
    
    table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    th { border-bottom: 2px solid #00704A; color: #00704A; padding: 12px 5px; font-weight: 700; text-align: left; font-size: 13px; }
    td { padding: 16px 5px; border-bottom: 1px solid #edf2f7; font-size: 14px; color: #2d3748; }
    .price-col { text-align: right; font-family: 'Montserrat', sans-serif; font-weight: 700; }

    .row-gross { background-color: #f7fafc; font-weight: 600; }
    .row-gross td { color: #00704A; }
    
    .row-net { font-weight: 700; font-size: 16px; }
    .bg-black-ink { background-color: #f0fdf4; }
    .bg-black-ink td { color: #166534; border-bottom: 2px double #166534; }
    .bg-red-ink { background-color: #fef2f2; }
    .bg-red-ink td { color: #991b1b; border-bottom: 2px double #991b1b; }

    .btn-back { display: block; text-align: center; background-color: #f1f3f5; color: #495057; text-decoration: none; padding: 12px; border-radius: 8px; font-weight: bold; font-size: 13px; transition: background 0.2s; margin-top: 20px; }
    .btn-back:hover { background-color: #e9ecef; }
</style>
</head>
<body>

<%
    // サーブレットからリアルタイム計算された金額を取得
    int sales = request.getAttribute("sales") != null ? (Integer) request.getAttribute("sales") : 0;
    int costOfGoods = request.getAttribute("costOfGoods") != null ? (Integer) request.getAttribute("costOfGoods") : 0;
    int laborCost = request.getAttribute("laborCost") != null ? (Integer) request.getAttribute("laborCost") : 0;
    int expenses = request.getAttribute("expenses") != null ? (Integer) request.getAttribute("expenses") : 0;

    int grossProfit = sales - costOfGoods;
    int netProfit = grossProfit - (laborCost + expenses);

    String kameComment = "";
    String netProfitClass = "";
    if (netProfit > 0) {
        netProfitClass = "bg-black-ink";
        if (netProfit >= 50000) {
            kameComment = "🐢「大豊作や！竜宮城へ財宝を運ぶレベルの黒字やで。この調子でがんがん甲羅を磨こうな！」";
        } else {
            kameComment = "🐢「ええね、堅実に黒字や。のんびり着実にカメの歩みで進んでいけば間違いナシやで」";
        }
    } else if (netProfit == 0) {
        netProfitClass = "bg-black-ink";
        kameComment = "🐢「トントンやね。売上と経費が綺麗に相殺されてもうた。まぁ、お昼寝の時間は確保できたから良しとしよか」";
    } else {
        netProfitClass = "bg-red-ink";
        kameComment = "🐢「あかん！赤字や！仕入れや経費が重すぎて甲羅がひび割れそうやで…ちょっとのんびりしすぎたかもわからんね…」";
    }
%>

<div class="container">
    <h1>🐢 甲羅勘定（損益計算書）</h1>
    <div class="subtitle">Cafe Kame Financial Report</div>

    <!-- カメのリアルタイム経営評価 -->
    <div class="kame-report-box">
        <%= kameComment %>
    </div>

    <table>
        <thead>
            <tr>
                <th>勘定科目</th>
                <th style="text-align: right;">金額</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><strong>総収穫（売上高）</strong></td>
                <td class="price-col">￥<%= String.format("%,d", sales) %></td>
            </tr>
            <tr>
                <td style="color: #718096; padding-left: 15px;">┗ リアルタイム仕入れ値（売上原価）</td>
                <td class="price-col" style="color: #718096;">- ￥<%= String.format("%,d", costOfGoods) %></td>
            </tr>
            <tr class="row-gross">
                <td>甲羅裏利益（売上総利益）</td>
                <td class="price-col">￥<%= String.format("%,d", grossProfit) %></td>
            </tr>
            <tr>
                <td style="color: #718096; padding-left: 15px;">┗ 働きガメへの給与（人件費）</td>
                <td class="price-col" style="color: #718096;">- ￥<%= String.format("%,d", laborCost) %></td>
            </tr>
            <tr>
                <td style="color: #718096; padding-left: 15px;">┗ 巣の維持費（家賃・光熱費等経費）</td>
                <td class="price-col" style="color: #718096;">- ￥<%= String.format("%,d", expenses) %></td>
            </tr>
            <tr class="row-net <%= netProfitClass %>">
                <td>純カメ利益（営業利益）</td>
                <td class="price-col">￥<%= String.format("%,d", netProfit) %></td>
            </tr>
        </tbody>
    </table>

    <a href="staff_main.jsp" class="btn-back">メインページに戻る</a>
</div>

</body>
</html>