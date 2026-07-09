<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Enumeration" %>
<%
    // 前の画面から送信されたデータの受け取り
    request.setCharacterEncoding("UTF-8");

    String eatStyle = request.getParameter("eatStyle"); // sea or land
    String myKameShell = request.getParameter("myKameShell"); // "true" or null
    String needReceipt = request.getParameter("needReceipt"); // "true" or null
    String finalReceiptName = request.getParameter("finalReceiptName"); // カメ変換された宛名

    // 商品名と価格のマスター（前画面のglobalItemIndexと同期させるための配列）
    String[] allMenus = {
        // おすすめ (1-7)
        "カメバックス ドリップ コーヒー (Grande),4500",
        "ミドリガメ 抹茶 クリーム フラペチーノ (Grande),6300",
        "ウミガメ ダーク モカ チップ フラペチーノ (Grande),6350",
        "カメの甲羅 チョコレートクランチスコーン,3000",
        "タートル ニューヨークチーズケーキ,4850",
        "カメねるねるねるね（メロン味）,900",
        "カメうまい棒（コーンポタージュ味）,300",
        // ドリンク (8-42)
        "ソイ カメ ラテ (Grande),5500", "カメバックス 特製ラテ (Grande),4950", "亀の甲羅 キャラメル マキアート (Grande),5900",
        "のんびり抽出 コールドブリュー コーヒー (Grande),4800", "カメバックス アメリカーノ (Grande),4400", "カメプッチーノ (Grande),5300",
        "カフェ カメモカ (Grande),5800", "ホワイト カメモカ (Grande),6000", "リクガメ アーモンドミルク ラテ (Grande),5700",
        "のんびり育った オーツミルク ラテ (Grande),5800", "カメの休息 ほうじ茶 ティー ラテ (Grande),5400", "タートル チャイ ティー ラテ (Grande),5500",
        "クラシック カメ ティー ラテ (Grande),5300", "エスプレッソ カメパンナ,4000", "エスプレッソ カメマキアート,4100",
        "カメマキアート (Grande),5200", "万年長寿 キャラメル フラペチーノ (Grande),6200", "白い甲羅 バニラ クリーム フラペチーノ (Grande),6100",
        "南の島のウミガメ マンゴー フラペチーノ (Grande),6400", "カメバックス アフォガート フラペチーノ (Grande),6800", "赤ミドリガメ ストロベリー フラペチーノ (Grande),6600",
        "泥亀 トリプル チョコレート フラペチーノ (Grande),6700", "カメの楽園 シトラス ミント ティー,4800", "のんびり夜更かし カモミール ティー,4800",
        "アールグレイ カメティー,4800", "ゆず シトラス カメティー (Grande),5900", "アイス カメティー ブラック (Grande),4400",
        "アイス パッションタートルティー (Grande),4400", "カメカオ ココア (Grande),5300", "カメ牧場 ミルク (Grande),4200",
        "キャラメル カメスチーマー (Grande),5400", "すっぽん アップル ジュース,4000", "お日様ぽかぽか オレンジ ジュース,4000",
        "亀の甲羅の湧き水 ミネラルウォーター,2500", "シュワシュワ 炭酸カメウォーター,3000",
        // フード (43-78)
        "ホシガメ ブルーベリースコーン,3100", "アールグレイ カメミルクティースコーン,3200", "カメの渦巻き シナモンロール,3800",
        "甲羅型 シュガードーナツ,3000", "緑の甲羅 抹茶ピスタチオドーナツ,3500", "宇治抹茶 カメシフォンケーキ,4600",
        "泥亀 クラシックチョコレートケーキ,5000", "ガパゴス ストロベリータルト,5500", "のんびり焼き上げた アップルパイ,4900",
        "カメの親子 バナナロールケーキ,4400", "レモン カメパウンドケーキ,3800", "砂浜のキャロットケーキ,4200",
        "カラフル カメマカロン（3個入り）,4500", "黒カメ カヌレ,2800", "カメの足跡 マドレーヌ,2500",
        "黄金の甲羅 フィナンシェ,2600", "カメさん バタークッキーアソート,3500", "カメの甲羅風 メロンパンサンドイッチ,6800",
        "スモークサーモン タートルベーグル,7200", "カメの好物 チキン＆アボカド サラダラップ,6500", "ヘルシー 根菜カメサラダラップ,6200",
        "ホカホカ 焼きカメパニーニ,5800", "ミドリガメカラーのカプレーゼ フォカッチャ,6000", "カメの背中 クロックムッシュ,5500",
        "あらびきカメソーセージパイ,4200", "タートル ミートパイ,4500", "のんびり朝食 フレンチトースト,5000",
        "カメの絵柄 ホットケーキ,5200", "小さな甲羅 エッグタルト,2900", "カメの足跡 ティラミス,5200",
        "贅沢 カメプリン・アラモード,6500", "ゆっくり固めた コーヒーゼリーパフェ,5800", "ミドリガメ 抹茶パフェ,6200",
        "カメバニラ アイスクリーム,3500", "泥カメ チョコレートジェラート,3800", "カメグリーン ピスタチオアイスクリーム,4200",
        // グッズ (79-100)
        "カメバックス厳選 コーヒー豆,14800", "カメさんイラスト タンブラー,15000", "親亀子亀のお皿,18000",
        "亀山特選 茶葉,10800", "カメバックス オリジナルロゴマグカップ,12000", "ステンレスボトル（甲羅ホワイト）,16500",
        "ステンレスボトル（甲羅ブラック）,16500", "カメさんお散歩 コットントートバッグ,8500", "亀の甲羅型 コースター（4枚セット）,4000",
        "カメのイラスト入り キャニスター缶,3500", "ペーパーフィルター（カメのロゴ付き）,1200", "カメの首型 ハンドドリップドリッパー,4500",
        "のんびり挽く コーヒーミル（手挽き）,28000", "特製カメデカフェコーヒー豆,15500", "シングルオリジン（ガラパゴス諸島産）,18000",
        "シングルオリジン（カメ農園グアテマラ）,17500", "水出しカメコーヒーパック,6500", "プチプチ（カメの卵風梱包材）,500",
        "カメチロルチョコ,200", "鶴は千年亀は万年 おつまみ柿の種,800", "ポップコーン（カメの産卵塩味）,1500",
        "緑のカメわたあめ,1200",
        // 裏メニュー (101)
        "幻の竜宮城特製パフェ（玉手箱付き）,99999"
    };

    // 選択された注文データを格納するリスト
    List<String[]> orderedList = new ArrayList<String[]>();
    int subTotal = 0;

    // quantity_1 から順番にパラメータをチェック
    for (int i = 0; i < allMenus.length; i++) {
        String qtyParam = request.getParameter("quantity_" + (i + 1));
        if (qtyParam != null && !qtyParam.equals("") && !qtyParam.equals("0")) {
            int qty = Integer.parseInt(qtyParam);
            String[] menuData = allMenus[i].split(",");
            String name = menuData[0];
            int price = Integer.parseInt(menuData[1]);
            int totalItemPrice = price * qty;
            
            subTotal += totalItemPrice;
            orderedList.add(new String[]{name, String.valueOf(price), String.valueOf(qty), String.valueOf(totalItemPrice)});
        }
    }

    // 各種計算
    int discount = (myKameShell != null && myKameShell.equals("true") && subTotal > 0) ? 200 : 0;
    int finalTotal = Math.max(0, subTotal - discount);
    int kamePoint = finalTotal / 100;

    // カメランク判定
    String kameRank = "見習いガメ";
    String kameComment = "のんびり厨房で作っとるから、万年くらい待っててな〜。";
    if (finalTotal >= 50000) {
        kameRank = "伝説の玄武";
        kameComment = "圧倒的感謝…！お主、もしや竜宮城のオーナー様かカメ？";
    } else if (finalTotal >= 10000) {
        kameRank = "深海のボスウミガメ";
        kameComment = "甲羅がピカピカに輝いとる！最高の注文、ありがとな！";
    } else if (finalTotal >= 3000) {
        kameRank = "エリート陸ガメ";
        kameComment = "たくさん食べて、のんびり強い甲羅を育てるんやで。";
    } else if (finalTotal > 0) {
        kameRank = "普通のミドリガメ";
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

    /* 広告と中央コンテンツを横並びにするレイアウトベース */
    .layout-wrapper {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        max-width: 1100px;
        margin: 0 auto;
        gap: 30px;
        position: relative;
    }

    /* 中央のメインコンテンツ */
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

    /* 📄 両サイドの広告枠スタイル */
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
    .ad-label {
        font-size: 10px;
        color: #868e96;
        letter-spacing: 1px;
        font-weight: bold;
    }
    .ad-content {
        font-size: 13px;
        color: #212529;
        font-weight: bold;
        line-height: 1.5;
    }
    .ad-dummy-img {
        width: 100%;
        height: 120px;
        background: #e9ecef;
        border-radius: 6px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 28px;
        color: #6c757d;
        margin: 10px 0;
    }

    /* 📱 画面の横幅が狭いときは広告を非表示にする */
    @media (max-width: 1024px) {
        .side-ad-banner {
            display: none;
        }
        .layout-wrapper {
            gap: 0;
        }
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

    /* 伝票エリア */
    .bill-card {
        border: 1px solid #ced4da;
        border-radius: 8px;
        padding: 20px;
        background: #fff;
        text-align: left;
        margin-bottom: 25px;
        box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
    }
    .bill-title {
        font-size: 14px;
        font-weight: bold;
        color: #00704A;
        border-bottom: 2px dashed #00704A;
        padding-bottom: 8px;
        margin-bottom: 12px;
        display: flex;
        justify-content: space-between;
    }

    table { width: 100%; border-collapse: collapse; }
    td { padding: 10px 4px; font-size: 14px; border-bottom: 1px dashed #e9ecef; }
    .text-right { text-align: right; }
    .font-bold { font-weight: bold; }

    .summary-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; }
    .total-row { border-top: 2px solid #00704A; margin-top: 10px; padding-top: 12px; font-size: 20px; color: #00704A; }

    /* パロディ領収書 */
    .receipt-box {
        background: #fffdf5;
        border: 2px dashed #e6c645;
        border-radius: 8px;
        padding: 20px;
        text-align: left;
        margin-bottom: 25px;
        position: relative;
    }
    .receipt-box::before {
        content: "カメ印";
        position: absolute;
        bottom: 15px;
        right: 30px;
        width: 55px;
        height: 55px;
        border: 2px solid rgba(230, 75, 75, 0.6);
        color: rgba(230, 75, 75, 0.6);
        border-radius: 50%;
        text-align: center;
        line-height: 55px;
        font-size: 12px;
        font-weight: bold;
        transform: rotate(-15deg);
    }

    /* バッジ */
    .kame-badge-box {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #eef5f0;
        padding: 10px 15px;
        border-radius: 30px;
        margin-bottom: 30px;
        border: 1px solid #c2ebd4;
    }
    .badge-title { font-size: 12px; color: #555; }
    .badge-value { font-size: 14px; font-weight: bold; color: #00704A; }

    /* ボタン */
    .btn-home {
        display: inline-block;
        background-color: #00704A;
        color: #ffffff;
        text-decoration: none;
        padding: 14px 35px;
        font-size: 15px;
        font-weight: 700;
        border-radius: 50px;
        transition: background-color 0.2s;
        box-shadow: 0 4px 12px rgba(0, 112, 74, 0.2);
    }
    .btn-home:hover { background-color: #00593b; }
</style>
</head>
<body class="<%= "sea".equals(eatStyle) ? "style-sea" : "" %>">

<!-- 📄 左右広告対応のレイアウト用ラッパー -->
<div class="layout-wrapper">

    <!-- 📢 左側広告：バイクオイル -->
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

    <!-- 🛒 中央メインコンテンツ -->
    <div class="container">
        <div class="success-icon">🐢🎉</div>
        <h1>注文の確定・送信完了</h1>
        
        <div class="thank-you-msg">
            <strong><%= session.getAttribute("user") %> ガメ 殿</strong>、ご注文おおきに！<br>
            <%= kameComment %><br>
            <span style="font-size: 12px; color: #868e96;">※利用スタイル：<%= "sea".equals(eatStyle) ? "イートイン（海中浸水）" : "テイクアウト（陸上退避）" %></span>
        </div>

        <!-- 注文明細 -->
        <div class="bill-card">
            <div class="bill-title">
                <span>📄 お品書き明細</span>
                <span>cafe kame</span>
            </div>
            <table>
                <tbody>
                    <% if(orderedList.isEmpty()) { %>
                        <tr>
                            <td colspan="2" style="text-align: center; color: #868e96;">何も注文されませんでしたカメ…</td>
                        </tr>
                    <% } else { 
                        for(String[] item : orderedList) {
                    %>
                        <tr>
                            <td><%= item[0] %><br><span style="font-size: 11px; color:#868e96;"><%= String.format("%,d", Integer.parseInt(item[1])) %>円 × <%= item[2] %></span></td>
                            <td class="text-right font-bold"><%= String.format("%,d", Integer.parseInt(item[3])) %> 円</td>
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
                    <span>合計金額</span>
                    <span><%= String.format("%,d", finalTotal) %> 円</span>
                </div>
            </div>
        </div>

        <!-- 📄 領収書 -->
        <% if(needReceipt != null && "true".equals(needReceipt)) { %>
        <div class="receipt-box">
            <div style="text-align: center; font-weight: bold; font-size: 16px; letter-spacing: 4px; margin-bottom: 10px; color:#856404;">領 収 書</div>
            <div style="font-size: 15px; border-bottom: 1px solid #212529; padding-bottom: 5px; margin-bottom: 15px;">
                <strong><%= (finalReceiptName != null && !finalReceiptName.equals("")) ? finalReceiptName : session.getAttribute("user") + "ガメ 殿" %></strong>
            </div>
            <div style="font-size: 22px; text-align: center; font-weight: bold; margin-bottom: 15px; font-family: 'Montserrat';">
                ￥<%= String.format("%,d", finalTotal) %> -
            </div>
            <div style="font-size: 12px; color: #555;">
                但し、のんびりカメカフェ利用代金として上記正に領収いたしました。<br>
                <span style="font-size: 10px; color: #868e96;">※甲羅に貼って保管してください。</span>
            </div>
        </div>
        <% } %>

        <!-- カメステータスバッジ -->
        <div class="kame-badge-box">
            <div>
                <span class="badge-title">今回の獲得ポイント:</span>
                <span class="badge-value" style="margin-left: 5px;"><%= String.format("%,d", kamePoint) %> pt</span>
            </div>
            <div>
                <span class="badge-title">現在のカメ称号:</span>
                <span class="badge-value" style="color: #0b5ed7; margin-left: 5px;"><%= kameRank %></span>
            </div>
        </div>

        <div>
            <a href="main.jsp" class="btn-home">🐢 マイページへ戻る</a>
        </div>
    </div>

    <!-- 📢 右側広告：プロテクター -->
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