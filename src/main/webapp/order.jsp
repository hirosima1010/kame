<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>注文入力 | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<style>
    /* カメが背景をのんびり泳ぐアニメーション */
    @keyframes swim {
        0% { background-position: 0 0, 30px 30px, 0 0; }
        100% { background-position: 100px 50px, 130px 80px, -50px 100px; }
    }

    /* 隠しコマンド用：爆速アニメーション */
    @keyframes fast-swim {
        0% { background-position: 0 0, 30px 30px, 0 0; }
        100% { background-position: 500px 250px, 530px 280px, -250px 500px; }
    }

    /* 💡 機能5：水中でゆらゆら揺れるアニメーション */
    @keyframes water-wave {
        0% { transform: translateY(0) skewX(0deg); }
        50% { transform: translateY(-4px) skewX(1deg); }
        100% { transform: translateY(0) skewX(0deg); }
    }

    /* 全体のベース */
    body {
        font-family: 'Montserrat', 'Noto Sans JP', sans-serif;
        color: #212529;
        margin: 0;
        padding: 40px 20px 180px 20px; 
        display: flex;
        flex-direction: column;
        align-items: center;

        background-color: #eef5f0; 
        background-image: radial-gradient(rgba(0, 112, 74, 0.04) 20%, transparent 20%),
                          radial-gradient(rgba(0, 112, 74, 0.04) 20%, transparent 20%);
        background-size: 60px 60px;
        position: relative;
        animation: swim 20s linear infinite; 
        
        /* マウスカーソルをカメに変更 */
        cursor: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='32' height='32' style='font-size:24px'><text y='24'>🐢</text></svg>"), auto;
    }

    /* 隠しコマンド発動時 */
    body.turbo-kame {
        animation: fast-swim 2s linear infinite !important;
        background-color: #d4ebd9;
    }
    body.turbo-kame::before {
        animation: fast-swim 3s linear infinite !important;
        opacity: 0.2;
    }

    /* 背景のカメ絵文字 */
    body::before {
        content: "🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢 🐢";
        font-size: 28px;
        opacity: 0.09; 
        position: fixed;
        top: 0; 
        left: 0; 
        width: 100%; 
        height: 100%;
        z-index: -2; 
        word-wrap: break-word;
        letter-spacing: 40px;
        line-height: 70px;
        padding: 20px;
        pointer-events: none;
    }

    /* 💡 機能5：海中浸水レイヤー（z-indexを下げて、文字の後ろに配置して視認性確保！） */
    .sea-water {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 0vh; /* JSで変更 */
        background: linear-gradient(to top, rgba(0, 119, 182, 0.35) 0%, rgba(0, 180, 216, 0.15) 80%, transparent 100%);
        backdrop-filter: blur(1px);
        z-index: -1; /* コンテナやテキストの背景として機能させる */
        pointer-events: none;
        transition: height 0.8s cubic-bezier(0.19, 1, 0.22, 1);
    }

    /* 💡 海中モード時、水没する下部コンテンツの視認性を上げるための白エフェクト */
    body.sea-active .receipt-section,
    body.sea-active #sec_goods,
    body.sea-active #sec_secret {
        text-shadow: 1px 1px 3px #ffffff, -1px -1px 3px #ffffff, 1px -1px 3px #ffffff, -1px 1px 3px #ffffff;
    }

    /* 架空の広告枠 */
    .kame-ad {
        position: fixed;
        top: 100px;
        width: 160px;
        background: #ffffff;
        border: 2px solid #00704A;
        border-radius: 8px;
        padding: 15px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        text-align: center;
        box-sizing: border-box;
        z-index: 10;
    }
    .kame-ad-left { left: 40px; }
    .kame-ad-right { right: 40px; border-color: #0b5ed7; } 
    .ad-tag { font-size: 10px; color: #adb5bd; display: block; text-align: left; margin-bottom: 5px; }
    .ad-title { font-size: 14px; font-weight: 700; color: #2b8a3e; margin: 5px 0; }
    .ad-title-blue { color: #0b5ed7; }
    .ad-desc { font-size: 11px; color: #495057; line-height: 1.4; }
    .ad-btn { display: inline-block; margin-top: 10px; background: #00704A; color: #fff; font-size: 11px; padding: 4px 10px; border-radius: 20px; text-decoration: none; font-weight: bold; }
    .ad-btn-blue { background: #0b5ed7; }

    @media (max-width: 1000px) {
        .kame-ad { display: none; }
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
        content: "🐢";
        position: absolute;
        font-size: 24px;
        bottom: -15px;
        right: -15px;
        transform: rotate(-30deg);
    }
    .container-kame-left {
        position: absolute;
        font-size: 24px;
        top: -15px;
        left: -15px;
        transform: rotate(15deg);
    }

    /* ヘッダー */
    h1 {
        font-size: 28px;
        color: #00704A; 
        margin-top: 0;
        margin-bottom: 8px;
        text-align: center;
        font-weight: 700;
        letter-spacing: 2px;
        cursor: pointer;
        user-select: none;
    }
    
    /* カテゴリー見出し */
    .category-section {
        margin-top: 40px;
        margin-bottom: 15px;
    }
    .category-title {
        font-size: 18px;
        color: #fff;
        background-color: #00704A;
        padding: 8px 16px;
        border-radius: 4px;
        margin: 0;
        font-weight: 700;
        letter-spacing: 1px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .user-info {
        font-size: 13px;
        color: #6c757d;
        text-align: center;
        margin-bottom: 30px;
    }

    /* 時計とつぶやき */
    .live-clock-wrapper {
        margin-top: 8px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
    }
    .kame-clock {
        background-color: #f1f3f5;
        border-radius: 20px;
        padding: 4px 12px;
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
        color: #00704A;
        border: 1px solid #e2e8f0;
    }
    .kame-talk {
        font-size: 11px;
        color: #868e96;
        font-style: italic;
    }

    /* テーブル */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 10px;
    }
    th {
        border-bottom: 2px solid #00704A;
        color: #00704A;
        padding: 12px 8px;
        font-weight: 700;
        text-align: left;
        font-size: 13px;
        text-transform: uppercase;
    }
    td {
        padding: 14px 8px;
        border-bottom: 1px solid #e9ecef;
        color: #212529;
        font-size: 14px;
    }
    tr:hover td {
        background-color: #f2f7f4; 
    }

    /* 数量入力とミニボタン */
    .qty-wrapper {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 4px;
    }
    .btn-step {
        background: #e2e8f0;
        border: 1px solid #cbd5e1;
        color: #475569;
        border-radius: 4px;
        width: 24px;
        height: 24px;
        font-size: 12px;
        font-weight: bold;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .btn-step:hover { background: #cbd5e1; }
    
    input[type="number"] {
        width: 45px;
        padding: 4px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 14px;
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
        text-align: center;
        outline: none;
    }

    /* カスタム・領収書セクション */
    .receipt-section {
        background-color: #f8f9fa;
        border: 1px dashed #00704A;
        border-radius: 8px;
        padding: 15px;
        margin-top: 40px;
        margin-bottom: 25px;
        transition: text-shadow 0.3s;
    }
    .receipt-title, .eco-title {
        font-size: 13px;
        font-weight: bold;
        color: #00704A;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .receipt-input-group {
        display: none;
        margin-top: 10px;
    }
    .receipt-input-group input[type="text"] {
        width: 100%;
        padding: 8px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        box-sizing: border-box;
        font-size: 13px;
    }
    .eco-section {
        margin-bottom: 12px;
        padding-bottom: 12px;
        border-bottom: 1px dashed #ced4da;
    }
    .style-section {
        margin-bottom: 12px;
        padding-bottom: 12px;
        border-bottom: 1px dashed #ced4da;
        font-size: 13px;
        font-weight: bold;
        color: #00704A;
    }

    /* 注文ボタン */
    .btn-submit {
        display: block;
        width: 100%;
        background-color: #00704A;
        color: #ffffff;
        border: none;
        padding: 16px;
        font-size: 16px;
        font-weight: 700;
        border-radius: 50px;
        cursor: pointer;
        transition: background-color 0.2s, transform 0.1s;
        letter-spacing: 1px;
    }
    .btn-submit:hover { background-color: #00593b; }
    .btn-submit:active { transform: scale(0.98); }

    /* 戻るリンク */
    .back-link {
        display: inline-block;
        margin-top: 24px;
        color: #00704A;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
    }
    .back-link:hover { text-decoration: underline; }
    .back-link .egg::before { content: "🥚"; }
    .back-link:hover .egg::before { content: "🐢"; }
    .footer-nav { text-align: center; }

    /* リアルタイム合計金額バー */
    .kame-summary-bar {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background: rgba(0, 112, 74, 0.95);
        color: white;
        padding: 15px 20px;
        box-shadow: 0 -4px 15px rgba(0,0,0,0.15);
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
        z-index: 100;
        box-sizing: border-box;
        backdrop-filter: blur(5px);
        transition: background 0.5s;
    }
    
    /* 💡 機能5：海中モード時にバー自体を少し濃い青にし、白文字を引き立てて揺らす */
    .kame-summary-bar.in-sea {
        background: rgba(0, 90, 140, 0.95) !important;
        animation: water-wave 3s ease-in-out infinite;
        box-shadow: 0 -4px 20px rgba(0, 119, 182, 0.4);
    }

    .summary-main-row {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 20px;
        width: 100%;
        flex-wrap: wrap;
    }
    .summary-item { font-size: 15px; font-weight: 500; }
    .summary-price { font-size: 22px; font-weight: 700; font-family: 'Montserrat', sans-serif; color: #fff; border-bottom: 2px solid #fff; padding-bottom: 2px; }
    .summary-comment { font-size: 12px; background: rgba(255,255,255,0.2); padding: 4px 12px; border-radius: 15px; font-style: italic; max-width: 250px; }
    
    /* 割り勘・ポイントエリア */
    .kame-split-box {
        font-size: 12px;
        background: rgba(255,255,255,0.15);
        padding: 4px 12px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .split-input {
        width: 40px;
        background: white;
        border: none;
        border-radius: 4px;
        padding: 2px;
        text-align: center;
        font-weight: bold;
    }
    .kame-point-badge {
        background: #fff;
        color: #00704A;
        padding: 2px 8px;
        border-radius: 10px;
        font-weight: bold;
    }

    /* 各種操作ボタン */
    .btn-gacha {
        background: #ffc107;
        color: #212529;
        border: none;
        padding: 8px 14px;
        font-weight: 700;
        border-radius: 20px;
        cursor: pointer;
        font-size: 11px;
        transition: transform 0.1s;
    }
    .btn-gacha:hover { background: #e0a800; }
    .btn-gacha:active { transform: scale(0.95); }
    .btn-reset { background: #6c757d; color: white; }
    .btn-reset:hover { background: #5a6268; }

    /* 💡 機能7：積み重なるタワーコンテナ */
    .kame-tower-wrapper {
        position: fixed;
        bottom: 150px; 
        right: 30px;
        display: flex;
        flex-direction: column;
        align-items: center;
        z-index: 90;
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s, visibility 0.3s;
    }
    .kame-tower-wrapper.show { opacity: 1; visibility: visible; }

    /* 積み重なる子亀たち */
    .child-kame {
        font-size: 16px;
        margin-bottom: -6px; 
        transform: scale(0);
        transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }
    .child-kame.visible { transform: scale(1); }

    /* 親亀ボタン本体 */
    .kame-totop {
        background: #ffffff;
        color: #00704A;
        border: 2px solid #00704A;
        width: 54px;
        height: 54px;
        border-radius: 50%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        font-size: 22px;
        cursor: pointer;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        transform: translateY(0);
        transition: transform 0.2s;
    }
    .kame-totop:hover { transform: translateY(-5px); background: #f2f7f4; }
    .kame-totop span { font-size: 9px; font-weight: bold; margin-top: -2px; }
</style>
</head>
<body>

<!-- 💡 機能5：海中浸水用レイヤー -->
<div class="sea-water" id="seaWater"></div>

<!-- 左側の架空広告 -->
<div class="kame-ad kame-ad-left">
    <span class="ad-tag">スポンサーリンク</span>
    <div style="font-size: 32px;">✨🐢✨</div>
    <div class="ad-title">甲羅艶出しワックス</div>
    <div class="ad-desc">ひと塗りで圧倒的な輝き。ご近所のミドリガメに差をつけよう！</div>
    <a href="#" class="ad-btn" onclick="alert('カメ専用ワックス(3,980円)をカートに入れませんでした'); return false;">今すぐ輝く</a>
</div>

<!-- 右側の架空広告（パロディ広告） -->
<div class="kame-ad kame-ad-right">
    <span class="ad-tag">おもしろ広告</span>
    <div style="font-size: 32px;">📦🐢</div>
    <div class="ad-title ad-title-blue">かめさんマークの引越し</div>
    <div class="ad-desc">「まごころ込めて、万年かけて運びます。」ありさんマークより圧倒的に遅いですが丁寧です。</div>
    <a href="#" class="ad-btn ad-btn-blue" onclick="alert('見積もり完了までに3年ほどかかります🐢'); return false;">のんびり見積もり</a>
</div>

<div class="container">
    <div class="container-kame-left">🐢</div>

    <h1 id="kameTitle">🐢 ORDER 🐢</h1>
    <div class="user-info">
        <div>Welcome to cafe kame, <strong>${sessionScope.user}</strong> 🐢</div>
        <div class="live-clock-wrapper">
            <span class="kame-clock" id="liveClock">00:00:00</span>
            <span class="kame-talk" id="kameSpeech">💬 のんびりいこうな…</span>
        </div>
    </div>
    
    <form action="orderSubmit" method="post" id="orderForm">
        <%
            String[] recommendMenus = {
                "カメバックス ドリップ コーヒー (Grande),4500",
                "ミドリガメ 抹茶 クリーム フラペチーノ (Grande),6300",
                "ウミガメ ダーク モカ チップ フラペチーノ (Grande),6350",
                "カメの甲羅 チョコレートクランチスコーン,3000",
                "タートル ニューヨークチーズケーキ,4850",
                "カメねるねるねるね（メロン味）,900",
                "カメうまい棒（コーンポタージュ味）,300"
            };

            String[] drinkMenus = {
                "ソイ カメ ラテ (Grande),5500",
                "カメバックス 特製ラテ (Grande),4950",
                "亀の甲羅 キャラメル マキアート (Grande),5900",
                "のんびり抽出 コールドブリュー コーヒー (Grande),4800",
                "カメバックス アメリカーノ (Grande),4400",
                "カメプッチーノ (Grande),5300",
                "カフェ カメモカ (Grande),5800",
                "ホワイト カメモカ (Grande),6000",
                "リクガメ アーモンドミルク ラテ (Grande),5700",
                "のんびり育った オーツミルク ラテ (Grande),5800",
                "カメの休息 ほうじ茶 ティー ラテ (Grande),5400",
                "タートル チャイ ティー ラテ (Grande),5500",
                "クラシック カメ ティー ラテ (Grande),5300",
                "エスプレッソ カメパンナ,4000",
                "エスプレッソ カメマキアート,4100",
                "カメマキアート (Grande),5200",
                "万年長寿 キャラメル フラペチーノ (Grande),6200",
                "白い甲羅 バニラ クリーム フラペチーノ (Grande),6100",
                "南の島のウミガメ マンゴー フラペチーノ (Grande),6400",
                "カメバックス アフォガート フラペチーノ (Grande),6800",
                "赤ミドリガメ ストロベリー フラペチーノ (Grande),6600",
                "泥亀 トリプル チョコレート フラペチーノ (Grande),6700",
                "カメの楽園 シトラス ミント ティー,4800",
                "のんびり夜更かし カモミール ティー,4800",
                "アールグレイ カメティー,4800",
                "ゆず シトラス カメティー (Grande),5900",
                "アイス カメティー ブラック (Grande),4400",
                "アイス パッションタートルティー (Grande),4400",
                "カメカオ ココア (Grande),5300",
                "カメ牧場 ミルク (Grande),4200",
                "キャラメル カメスチーマー (Grande),5400",
                "すっぽん アップル ジュース,4000",
                "お日様ぽかぽか オレンジ ジュース,4000",
                "亀の甲羅の湧き水 ミネラルウォーター,2500",
                "シュワシュワ 炭酸カメウォーター,3000"
            };

            String[] foodMenus = {
                "ホシガメ ブルーベリースコーン,3100",
                "アールグレイ カメミルクティースコーン,3200",
                "カメの渦巻き シナモンロール,3800",
                "甲羅型 シュガードーナツ,3000",
                "緑の甲羅 抹茶ピスタチオドーナツ,3500",
                "宇治抹茶 カメシフォンケーキ,4600",
                "泥亀 クラシックチョコレートケーキ,5000",
                "ガパゴス ストロベリータルト,5500",
                "のんびり焼き上げた アップルパイ,4900",
                "カメの親子 バナナロールケーキ,4400",
                "レモン カメパウンドケーキ,3800",
                "砂浜のキャロットケーキ,4200",
                "カラフル カメマカロン（3個入り）,4500",
                "黒カメ カヌレ,2800",
                "カメの足跡 マドレーヌ,2500",
                "黄金の甲羅 フィナンシェ,2600",
                "カメさん バタークッキーアソート,3500",
                "カメの甲羅風 メロンパンサンドイッチ,6800",
                "スモークサーモン タートルベーグル,7200",
                "カメの好物 チキン＆アボカド サラダラップ,6500",
                "ヘルシー 根菜カメサラダラップ,6200",
                "ホカホカ 焼きカメパニーニ,5800",
                "ミドリガメカラーのカプレーゼ フォカッチャ,6000",
                "カメの背中 クロックムッシュ,5500",
                "あらびきカメソーセージパイ,4200",
                "タートル ミートパイ,4500",
                "のんびり朝食 フレンチトースト,5000",
                "カメの絵柄 ホットケーキ,5200",
                "小さな甲羅 エッグタルト,2900",
                "カメの足跡 ティラミス,5200",
                "贅沢 カメプリン・アラモード,6500",
                "ゆっくり固めた コーヒーゼリーパフェ,5800",
                "ミドリガメ 抹茶パフェ,6200",
                "カメバニラ アイスクリーム,3500",
                "泥カメ チョコレートジェラート,3800",
                "カメグリーン ピスタチオアイスクリーム,4200"
            };

            String[] goodsMenus = {
                "カメバックス厳選 コーヒー豆,14800",
                "カメさんイラスト タンブラー,15000",
                "親亀子亀のお皿,18000",
                "亀山特選 茶葉,10800",
                "カメバックス オリジナルロゴマグカップ,12000",
                "ステンレスボトル（甲羅ホワイト）,16500",
                "ステンレスボトル（甲羅ブラック）,16500",
                "カメさんお散歩 コットントートバッグ,8500",
                "亀の甲羅型 コースター（4枚セット）,4000",
                "カメのイラスト入り キャニスター缶,3500",
                "ペーパーフィルター（カメのロゴ付き）,1200",
                "カメの首型 ハンドドリップドリッパー,4500",
                "のんびり挽く コーヒーミル（手挽き）,28000",
                "特製カメデカフェコーヒー豆,15500",
                "シングルオリジン（ガラパゴス諸島産）,18000",
                "シングルオリジン（カメ農園グアテマラ）,17500",
                "水出しカメコーヒーパック,6500",
                "プチプチ（カメの卵風梱包材）,500",
                "カメチロルチョコ,200",
                "鶴は千年亀は万年 おつまみ柿の種,800",
                "ポップコーン（カメの産卵塩味）,1500",
                "緑のカメわたあめ,1200"
            };

            int globalItemIndex = 1;
        %>

        <!-- おすすめカテゴリー -->
        <div class="category-section" id="sec_recommend">
            <h2 class="category-title"><span>✨ 当店おすすめ（カメ推し）</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% for (String item : recommendMenus) {
                        String[] data = item.split(",");
                    %>
                    <tr class="menu-row" data-category="recommend" data-price="<%= data[1] %>">
                        <td><strong><%= data[0] %></strong></td>
                        <td><%= data[1] %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn">-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0">
                                <button type="button" class="btn-step inc-btn">+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } %>
                </tbody>
            </table>
        </div>

        <!-- ドリンクカテゴリー -->
        <div class="category-section" id="sec_drink">
            <h2 class="category-title"><span>☕ カメドリンク</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% for (String item : drinkMenus) {
                        String[] data = item.split(",");
                    %>
                    <tr class="menu-row" data-category="drink" data-price="<%= data[1] %>">
                        <td><strong><%= data[0] %></strong></td>
                        <td><%= data[1] %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn">-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0">
                                <button type="button" class="btn-step inc-btn">+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } %>
                </tbody>
            </table>
        </div>

        <!-- フードカテゴリー -->
        <div class="category-section" id="sec_food">
            <h2 class="category-title"><span>🍰 カメフード ＆ スイーツ</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% for (String item : foodMenus) {
                        String[] data = item.split(",");
                    %>
                    <tr class="menu-row" data-category="food" data-price="<%= data[1] %>">
                        <td><strong><%= data[0] %></strong></td>
                        <td><%= data[1] %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn">-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0">
                                <button type="button" class="btn-step inc-btn">+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } %>
                </tbody>
            </table>
        </div>

        <!-- グッズ・その他カテゴリー -->
        <div class="category-section" id="sec_goods">
            <h2 class="category-title"><span>🎁 カメグッズ ＆ その他お菓子</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% for (String item : goodsMenus) {
                        String[] data = item.split(",");
                    %>
                    <tr class="menu-row" data-category="goods" data-price="<%= data[1] %>">
                        <td><strong><%= data[0] %></strong></td>
                        <td><%= data[1] %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn">-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0">
                                <button type="button" class="btn-step inc-btn">+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } %>
                </tbody>
            </table>
        </div>

        <!-- 隠し裏メニュー -->
        <div class="category-section" id="sec_secret" style="display: none;">
            <h2 class="category-title" style="background-color: #800020;"><span>☠️ 禁断のカメ裏メニュー（時価）</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <tr class="menu-row" data-category="secret" data-price="99999">
                        <td><strong>幻の竜宮城特製パフェ（玉手箱付き）</strong></td>
                        <td>99,999 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn">-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0">
                                <button type="button" class="btn-step inc-btn">+</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- 領収書 ＆ カスタマイズセクション -->
        <div class="receipt-section">
            <div class="style-section">
                <span>🍽️ 利用スタイルを選んでな：</span>
                <label><input type="radio" name="eatStyle" value="sea" checked> イートイン（海中）</label>
                <label style="margin-left: 10px;"><input type="radio" name="eatStyle" value="land"> テイクアウト（陸上）</label>
            </div>

            <div class="eco-section">
                <label class="eco-title">
                    <input type="checkbox" id="myKameShell" name="myKameShell" value="true">
                    🌱 マイ甲羅（タンブラー）を持参した（カメ環境割引 -200円）
                </label>
            </div>

            <label class="receipt-title">
                <input type="checkbox" id="needReceipt" name="needReceipt" value="true"> 
                📄 領収書を発行する（宛名カメ変換機能付き）
            </label>
            <div class="receipt-input-group" id="receiptGroup">
                <input type="text" id="receiptName" name="receiptName" placeholder="お名前を入力してください（例：山田 → 山田ガメ 殿になります）">
            </div>
        </div>
        
        <input type="hidden" id="finalReceiptName" name="finalReceiptName" value="">
        <button type="button" id="submitBtn" class="btn-submit">🐢 注文を確定する 🐢</button>
    </form>
    
    <div class="footer-nav">
        <a href="main.jsp" class="back-link"><span class="egg"></span> メインページに戻る</a>
    </div>
</div>

<!-- 画面下部固定：リアルタイム合計金額バー ＆ 各種コントロール -->
<div class="kame-summary-bar" id="summaryBar">
    <div class="summary-main-row">
        <div class="summary-item">
            合計金額: <span class="summary-price" id="totalPriceDisplay">0</span> 円
        </div>
        
        <div class="kame-split-box">
            <span>🐢 甲羅割り:</span>
            <input type="number" id="splitCount" class="split-input" value="1" min="1">
            <span>匹で分けると、1匹 <strong id="splitPriceDisplay">0</strong> 円</span>
        </div>

        <div class="kame-split-box">
            <span>🐢 カメの恩返し:</span>
            <span class="kame-point-badge"><span id="kamePoint">0</span> pt</span>
            <span id="kameRank" style="font-size: 11px; margin-left:2px;">(見習いガメ)</span>
        </div>

        <div class="summary-comment" id="totalComment">💬 なんか頼んでや…</div>
        
        <button type="button" class="btn-gacha" id="gachaBtn">🎰 カメガチャ</button>
        <button type="button" class="btn-gacha btn-reset" id="resetBtn">🍃 リセット</button>
    </div>
</div>

<!-- 💡 機能7：積み重なる親亀子亀タワー -->
<div class="kame-tower-wrapper" id="kameTower">
    <div class="child-kame" id="child5">🐢</div>
    <div class="child-kame" id="child4">🐢</div>
    <div class="child-kame" id="child3">🐢</div>
    <div class="child-kame" id="child2">🐢</div>
    <div class="child-kame" id="child1">🐢</div>
    <div class="kame-totop" id="toTopBtn">
        🐢
        <span>上へ</span>
    </div>
</div>

<script>
    // リアルタイムデジタル時計＆つぶやき
    function updateClock() {
        const now = new Date();
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');
        
        document.getElementById('liveClock').textContent = hours + ":" + minutes + ":" + seconds;
        
        const currentPrice = parseInt(document.getElementById('totalPriceDisplay').textContent.replace(/,/g, '')) || 0;
        const speech = document.getElementById('kameSpeech');
        
        if (currentPrice >= 100000) {
            speech.textContent = "💬 カメ、破産せんように気いつけや…";
            return;
        }

        const currentHour = now.getHours();
        if (currentHour >= 5 && currentHour < 11) {
            speech.textContent = "💬 朝やね。コーヒー飲んでゆっくりシャキッとこな。";
        } else if (currentHour >= 11 && currentHour < 17) {
            speech.textContent = "💬 お昼時や。フラペチーノでも飲んで、のんびりいこうな。";
        } else if (currentHour >= 17 && currentHour < 22) {
            speech.textContent = "💬 もう夕方かぁ。今日も一日よう頑張ったなぁ、カメ。";
        } else {
            speech.textContent = "💬 夜更かしはお肌（甲羅）に響くで…はよ寝よな…";
        }
    }
    setInterval(updateClock, 1000);
    updateClock();

    // 各種DOM要素
    const priceDisplay = document.getElementById('totalPriceDisplay');
    const splitPriceDisplay = document.getElementById('splitPriceDisplay');
    const splitCountInput = document.getElementById('splitCount');
    const totalComment = document.getElementById('totalComment');
    const myKameShellCheck = document.getElementById('myKameShell');
    const pointDisplay = document.getElementById('kamePoint');
    const rankDisplay = document.getElementById('kameRank');
    const styleRadios = document.querySelectorAll('input[name="eatStyle"]');
    const seaWater = document.getElementById('seaWater');
    const summaryBar = document.getElementById('summaryBar');

    // 増減イベント
    document.querySelectorAll('.qty-wrapper').forEach(wrapper => {
        const input = wrapper.querySelector('.qty-input');
        wrapper.querySelector('.inc-btn').addEventListener('click', () => {
            input.value = (parseInt(input.value) || 0) + 1;
            calculateTotal();
        });
        wrapper.querySelector('.dec-btn').addEventListener('click', () => {
            input.value = Math.max(0, (parseInt(input.value) || 0) - 1);
            calculateTotal();
        });
        input.addEventListener('input', calculateTotal);
    });

    // リアルタイム計算 ＆ 💡 機能5：海中水没・視認性制御
    function calculateTotal() {
        let total = 0;
        let hasItems = false;
        const rows = document.querySelectorAll('.menu-row');

        rows.forEach(row => {
            const price = parseInt(row.getAttribute('data-price'));
            const qty = parseInt(row.querySelector('.qty-input').value) || 0;
            if (qty > 0) hasItems = true;
            total += price * qty;
        });
        
        if (hasItems && myKameShellCheck.checked) {
            total = Math.max(0, total - 200); 
        }
        
        priceDisplay.textContent = total.toLocaleString();

        // 割り勘の計算
        const splitCount = Math.max(1, parseInt(splitCountInput.value) || 1);
        const splitPrice = Math.ceil(total / splitCount);
        splitPriceDisplay.textContent = splitPrice.toLocaleString();

        // カメの恩返しポイント (100円につき1pt)
        const points = Math.floor(total / 100);
        pointDisplay.textContent = points.toLocaleString();

        // カメランクの更新
        if (points === 0) {
            rankDisplay.textContent = "(見習いガメ)";
        } else if (points < 50) {
            rankDisplay.textContent = "(一人前ガメ)";
        } else if (points < 200) {
            rankDisplay.textContent = "(長寿アオウミガメ)";
        } else {
            rankDisplay.textContent = "(神の使い・玄武級)";
        }

        // 金額に応じたカメのつぶやき
        if (total === 0) {
            totalComment.textContent = "💬 なんか頼んでや…";
        } else if (total < 3000) {
            totalComment.textContent = "💬 ええね、のんびりお茶しよか。";
        } else if (total < 10000) {
            totalComment.textContent = "💬 結構頼んだなぁ！甲羅が重なりそうや。";
        } else {
            totalComment.textContent = "💬 豪遊や！竜宮城へご招待レベルやで！";
        }

        // 💡 機能5：利用スタイル（海中）と金額に応じた水没シミュレーション
        const activeStyle = document.querySelector('input[name="eatStyle"]:checked').value;
        if (activeStyle === 'sea' && total > 0) {
            // 金額に応じて水位が上昇（最大85vh）
            let waterHeight = Math.min(85, Math.floor(total / 300) + 10);
            seaWater.style.height = waterHeight + "vh";
            document.body.classList.add('sea-active');
            summaryBar.classList.add('in-sea');
        } else {
            // テイクアウト（陸上）または合計0円の時は水を引く
            seaWater.style.height = "0vh";
            document.body.classList.remove('sea-active');
            summaryBar.classList.remove('in-sea');
        }
    }

    // 割り勘・マイ甲羅割引・スタイルの変更イベント検知
    splitCountInput.addEventListener('input', calculateTotal);
    myKameShellCheck.addEventListener('change', calculateTotal);
    styleRadios.forEach(radio => radio.addEventListener('change', calculateTotal));

    // 領収書の宛名入力エリアの開閉
    const needReceiptCheck = document.getElementById('needReceipt');
    const receiptGroup = document.getElementById('receiptGroup');
    needReceiptCheck.addEventListener('change', () => {
        receiptGroup.style.display = needReceiptCheck.checked ? 'block' : 'none';
    });

    // 注文確定時のバリデーションとカメ変換
    document.getElementById('submitBtn').addEventListener('click', () => {
        const currentPrice = parseInt(priceDisplay.textContent.replace(/,/g, '')) || 0;
        if (currentPrice === 0) {
            alert('🐢「何も選ばれてへんで。のんびり選んでな」');
            return;
        }

        // 領収書の名前変換
        if (needReceiptCheck.checked) {
            let nameInput = document.getElementById('receiptName').value.trim();
            if (!nameInput) {
                alert('🐢「領収書が必要なら、お名前を入れてな」');
                return;
            }
            // 末尾が「ガメ」や「亀」でなければ「ガメ」を付与するパロディ処理
            if (!nameInput.endsWith('ガメ') && !nameInput.endsWith('亀') && !nameInput.endsWith('かめ')) {
                nameInput = nameInput + "ガメ";
            }
            document.getElementById('finalReceiptName').value = nameInput;
        }

        // フォーム送信
        document.getElementById('orderForm').submit();
    });

    // 🎰 カメガチャ（ランダムで数量が1増える）
    document.getElementById('gachaBtn').addEventListener('click', () => {
        const rows = document.querySelectorAll('.menu-row:not([data-category="secret"])');
        if (rows.length === 0) return;
        
        const randomRow = rows[Math.floor(Math.random() * rows.length)];
        const input = randomRow.querySelector('.qty-input');
        const menuName = randomRow.querySelector('td strong').textContent;
        
        input.value = (parseInt(input.value) || 0) + 1;
        calculateTotal();

        alert(`🎰 カメガチャ当選❣1つ増えたで🐢！`);
    });

    // 🍃 リセットボタン
    document.getElementById('resetBtn').addEventListener('click', () => {
        if (confirm('🐢「選んだメニューを全部リセットして、のんびりやり直す？」')) {
            document.querySelectorAll('.qty-input').forEach(input => input.value = 0);
            splitCountInput.value = 1;
            myKameShellCheck.checked = false;
            needReceiptCheck.checked = false;
            receiptGroup.style.display = 'none';
            document.getElementById('receiptName').value = '';
            calculateTotal();
        }
    });

    // 隠しコマンド：タイトル5回クリックで「爆速ターボカメモード」＆裏メニュー解禁
    let clickCount = 0;
    document.getElementById('kameTitle').addEventListener('click', () => {
        clickCount++;
        if (clickCount === 5) {
            document.body.classList.add('turbo-kame');
            document.getElementById('sec_secret').style.display = 'block';
            document.getElementById('kameSpeech').textContent = "💬 ！？ カメが本気を出したようです！裏メニュー解禁！";
            alert('🐢💨【隠しコマンド発動】\nカメが最高速度に達しました！禁断の裏メニューが解禁されます！');
        }
    });

    // 💡 機能7：スクロール連動・積み重なる親亀子亀タワー（ページトップ）
    const kameTower = document.getElementById('kameTower');
    const children = [
        document.getElementById('child1'),
        document.getElementById('child2'),
        document.getElementById('child3'),
        document.getElementById('child4'),
        document.getElementById('child5')
    ];

    window.addEventListener('scroll', () => {
        const scrollTop = window.scrollY;
        
        // 100px以上スクロールしたら親亀（ボタン）を表示
        if (scrollTop > 100) {
            kameTower.classList.add('show');
        } else {
            kameTower.classList.remove('show');
        }

        // スクロール量に応じて子亀が下から順番に「ピョコッ」と重なっていく
        children.forEach((child, index) => {
            const triggerOffset = 200 + (index * 150); // 各150pxごとに1匹出現
            if (scrollTop > triggerOffset) {
                child.classList.add('visible');
            } else {
                child.classList.remove('visible');
            }
        });
    });

    // スルッと最上部へ戻る（カメらしからぬスムーズな動き）
    document.getElementById('toTopBtn').addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
</script>
</body>
</html>