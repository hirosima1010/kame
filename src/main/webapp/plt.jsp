<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>甲羅勘定（損益計算書） | カフェシステムkame</title>
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
        max-width: 550px;
        width: 100%;
        box-sizing: border-box;
        position: relative; 
        border: 2px solid #00704A; 
    }

    .container::after {
        content: "📊";
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
        border-collapse: collapse;
        margin-bottom: 30px;
    }
    th {
        border-bottom: 2px solid #00704A;
        color: #00704A;
        padding: 12px 10px;
        font-weight: 700;
        text-align: left;
        font-size: 14px;
    }
    td {
        padding: 14px 10px;
        border-bottom: 1px solid #e9ecef;
        color: #212529;
        font-size: 14px;
    }
    .price-col {
        text-align: right;
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
    }
    
    /* 各利益行のハイライト */
    .row-gross {
        background-color: #f2f7f4;
        font-weight: bold;
    }
    .row-gross td {
        color: #00704A;
        border-bottom: 2px solid #00704A;
    }
    
    .row-net {
        font-weight: bold;
        font-size: 16px;
    }
    /* 黒字・赤字用のクラス（JSP側で判定） */
    .bg-black-ink {
        background-color: #e6f4ea;
    }
    .bg-black-ink td {
        color: #137333;
        border-bottom: 2px double #137333;
    }
    .bg-red-ink {
        background-color: #fce8e6;
    }
    .bg-red-ink td {
        color: #c5221f;
        border-bottom: 2px double #c5221f;
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
        // サーブレット側で計算された各金額を取得（なければ0）
        int sales = request.getAttribute("sales") != null ? (Integer) request.getAttribute("sales") : 0;
        int costOfGoods = request.getAttribute("costOfGoods") != null ? (Integer) request.getAttribute("costOfGoods") : 0;
        int laborCost = request.getAttribute("laborCost") != null ? (Integer) request.getAttribute("laborCost") : 0;
        int expenses = request.getAttribute("expenses") != null ? (Integer) request.getAttribute("expenses") : 0;
        
        // 粗利益、営業利益の計算
        int grossProfit = sales - costOfGoods;
        int netProfit = grossProfit - (laborCost + expenses);

        // カメの経営評価つぶやき
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
            kameComment = "🐢「あかん！赤字や！経費が重すぎて甲羅がひび割れそうやで…ちょっとのんびりしすぎたかもわからんね…」";
        }
    %>

<div class="container">
    <h1>🐢 甲羅勘定（損益計算書） 📊</h1>
    <div class="subtitle">Cafe kame Financial Report</div>
    
    <!-- カメの経営アドバイス -->
    <div class="kame-report-box">
        <%= kameComment %>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>勘定科目（カメ風）</th>
                <th style="text-align: right;">金額</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><strong>総収穫（売上高）</strong></td>
                <td class="price-col"><%= String.format("%,d", sales) %> 円</td>
            </tr>
            <tr>
                <td style="color: #6c757d; padding-left: 20px;">┗ エサ代（売上原価）</td>
                <td class="price-col" style="color: #6c757d;">- <%= String.format("%,d", costOfGoods) %> 円</td>
            </tr>
            <tr class="row-gross">
                <td>甲羅裏利益（売上総利益）</td>
                <td class="price-col"><%= String.format("%,d", grossProfit) %> 円</td>
            </tr>
            <tr>
                <td style="color: #6c757d; padding-left: 20px;">┗ 働きガメへの給与（人件費）</td>
                <td class="price-col" style="color: #6c757d;">- <%= String.format("%,d", laborCost) %> 円</td>
            </tr>
            <tr>
                <td style="color: #6c757d; padding-left: 20px;">┗ 巣の維持費（家賃・光熱費等経費）</td>
                <td class="price-col" style="color: #6c757d;">- <%= String.format("%,d", expenses) %> 円</td>
            </tr>
            <tr class="row-net <%= netProfitClass %>">
                <td>純カメ利益（営業利益）</td>
                <td class="price-col"><%= String.format("%,d", netProfit) %> 円</td>
            </tr>
        </tbody>
    </table>
    
    <a href="main.jsp" class="back-link">🐢 陸（メインページ）に戻る</a>
</div>

</body>
</html>