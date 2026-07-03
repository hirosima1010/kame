<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>注文入力 | カフェシステムkame</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css" type="text/css">
<style>
/* 🛠️ 追加：売り切れ（disabled）行のスタイル調整 */
.menu-row.sold-out-row {
    background-color: #f5f5f5 !important;
    color: #999 !important;
    opacity: 0.6;
}
.sold-out-badge {
    background-color: #d32f2f;
    color: white;
    padding: 2px 6px;
    font-size: 11px;
    border-radius: 4px;
    margin-left: 5px;
    display: inline-block;
}
.menu-desc {
    display: block;
    font-size: 12px;
    color: #666;
    font-weight: normal;
    margin-top: 4px;
    line-height: 1.4;
}
.sold-out-row .menu-desc {
    color: #aaa;
}
</style>
</head>
<body>

<div class="sea-water" id="seaWater"></div>

<div class="kame-ad kame-ad-left">
    <span class="ad-tag">スポンサーリンク</span>
    <div style="font-size: 32px;">✨🐢✨</div>
    <div class="ad-title">甲羅艶出しワックス</div>
    <div class="ad-desc">ひと塗りで圧倒的な輝き。ご近所のミドリガメに差をつけよう！</div>
    <a href="#" class="ad-btn" onclick="alert('カメ専用ワックス(3,980円)をカートに入れませんでした'); return false;">今すぐ輝く</a>
</div>

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
    
    <%
        java.util.List<model.Menu> menuList = (java.util.List<model.Menu>) request.getAttribute("menuList");
        boolean isDatabaseConnected = (menuList != null && !menuList.isEmpty());
        int globalItemIndex = 1;
    %>

    <% if (!isDatabaseConnected) { %>
        <div style="background: #fff3cd; color: #856404; border: 2px dashed #ffeeba; padding: 20px; border-radius: 10px; text-align: center; margin: 30px 0; font-weight: bold;">
            <p style="font-size: 20px; margin: 0 0 10px 0;">⚠️ データベースのメニューを読み込めませんでした 🐢</p>
            <p style="font-size: 14px; margin: 0;">
                URLが「.../order.jsp」のまま直接開いているか、サーブレット側で request.setAttribute("menuList", ...) の設定がまだ終わっていない可能性があります。<br>
                管理画面（admin）と連携したサーブレット経由でアクセスしてください！
            </p>
        </div>
    <% } %>

    <form action="orderSubmit" method="post" id="orderForm">

        <div class="category-section" id="sec_recommend">
            <h2 class="category-title"><span>✨ 当店おすすめ（カメ推し）</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% 
                    if (isDatabaseConnected) {
                        for (model.Menu m : menuList) {
                            if (m.isRecommend()) {
                                String rowClass = m.isAvailable() ? "" : "sold-out-row";
                    %>
                    <tr class="menu-row <%= rowClass %>" data-category="recommend" data-price="<%= m.isAvailable() ? m.getPrice() : 0 %>">
                        <td>
                            <strong><%= m.getMenuName() %></strong>
                            <% if(!m.isAvailable()) { %><span class="sold-out-badge">売り切れ</span><% } %>
                            <% if(m.getDescription() != null && !m.getDescription().trim().isEmpty()) { %>
                                <span class="menu-desc"><%= m.getDescription() %></span>
                            <% } %>
                        </td>
                        <td><%= m.getPrice() %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn" <%= m.isAvailable() ? "" : "disabled" %>>-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0" <%= m.isAvailable() ? "" : "disabled" %>>
                                <button type="button" class="btn-step inc-btn" <%= m.isAvailable() ? "" : "disabled" %>>+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } } } %>
                </tbody>
            </table>
        </div>

        <div class="category-section" id="sec_drink">
            <h2 class="category-title"><span>☕ カメドリンク</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% 
                    if (isDatabaseConnected) {
                        for (model.Menu m : menuList) {
                            if ("カメドリンク".equals(m.getCategory())) {
                                String rowClass = m.isAvailable() ? "" : "sold-out-row";
                    %>
                    <tr class="menu-row <%= rowClass %>" data-category="drink" data-price="<%= m.isAvailable() ? m.getPrice() : 0 %>">
                        <td>
                            <strong><%= m.getMenuName() %></strong>
                            <% if(!m.isAvailable()) { %><span class="sold-out-badge">売り切れ</span><% } %>
                            <% if(m.getDescription() != null && !m.getDescription().trim().isEmpty()) { %>
                                <span class="menu-desc"><%= m.getDescription() %></span>
                            <% } %>
                        </td>
                        <td><%= m.getPrice() %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn" <%= m.isAvailable() ? "" : "disabled" %>>-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0" <%= m.isAvailable() ? "" : "disabled" %>>
                                <button type="button" class="btn-step inc-btn" <%= m.isAvailable() ? "" : "disabled" %>>+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } } } %>
                </tbody>
            </table>
        </div>

        <div class="category-section" id="sec_food">
            <h2 class="category-title"><span>🍰 カメフード ＆ スイーツ</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% 
                    if (isDatabaseConnected) {
                        for (model.Menu m : menuList) {
                            if ("カメフード".equals(m.getCategory()) || "スイーツ".equals(m.getCategory())) {
                                String rowClass = m.isAvailable() ? "" : "sold-out-row";
                    %>
                    <tr class="menu-row <%= rowClass %>" data-category="food" data-price="<%= m.isAvailable() ? m.getPrice() : 0 %>">
                        <td>
                            <strong><%= m.getMenuName() %></strong>
                            <% if(!m.isAvailable()) { %><span class="sold-out-badge">売り切れ</span><% } %>
                            <% if(m.getDescription() != null && !m.getDescription().trim().isEmpty()) { %>
                                <span class="menu-desc"><%= m.getDescription() %></span>
                            <% } %>
                        </td>
                        <td><%= m.getPrice() %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn" <%= m.isAvailable() ? "" : "disabled" %>>-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0" <%= m.isAvailable() ? "" : "disabled" %>>
                                <button type="button" class="btn-step inc-btn" <%= m.isAvailable() ? "" : "disabled" %>>+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } } } %>
                </tbody>
            </table>
        </div>

        <div class="category-section" id="sec_goods">
            <h2 class="category-title"><span>🎁 カメグッズ ＆ その他お菓子</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <% 
                    if (isDatabaseConnected) {
                        for (model.Menu m : menuList) {
                            if ("コーヒー豆・茶葉".equals(m.getCategory()) || "グッズ・道具".equals(m.getCategory())) {
                                String rowClass = m.isAvailable() ? "" : "sold-out-row";
                    %>
                    <tr class="menu-row <%= rowClass %>" data-category="goods" data-price="<%= m.isAvailable() ? m.getPrice() : 0 %>">
                        <td>
                            <strong><%= m.getMenuName() %></strong>
                            <% if(!m.isAvailable()) { %><span class="sold-out-badge">売り切れ</span><% } %>
                            <% if(m.getDescription() != null && !m.getDescription().trim().isEmpty()) { %>
                                <span class="menu-desc"><%= m.getDescription() %></span>
                            <% } %>
                        </td>
                        <td><%= m.getPrice() %> 円</td>
                        <td>
                            <div class="qty-wrapper">
                                <button type="button" class="btn-step dec-btn" <%= m.isAvailable() ? "" : "disabled" %>>-</button>
                                <input type="number" name="quantity_<%= globalItemIndex %>" class="qty-input" value="0" min="0" <%= m.isAvailable() ? "" : "disabled" %>>
                                <button type="button" class="btn-step inc-btn" <%= m.isAvailable() ? "" : "disabled" %>>+</button>
                            </div>
                        </td>
                    </tr>
                    <% globalItemIndex++; } } } %>
                </tbody>
            </table>
        </div>

        <div class="category-section" id="sec_secret" style="display: none;">
            <h2 class="category-title" style="background-color: #800020;"><span>☠️ 禁断のカメ裏メニュー（時価）</span><span>🐢</span></h2>
            <table>
                <thead><tr><th>MENU</th><th>PRICE</th><th style="width:120px; text-align:center;">QTY</th></tr></thead>
                <tbody>
                    <tr class="menu-row" data-category="secret" data-price="99999">
                        <td>
                            <strong>幻の竜宮城特製パフェ（玉手箱付き）</strong>
                            <span class="menu-desc">開けると一気におじいさんガメになる、注文厳禁の禁断パフェ。</span>
                        </td>
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
        <button type="button" id="submitBtn" class="btn-submit">🐢 登録する 🐢</button>
    </form>
    
    <div class="footer-nav">
        <a href="main.jsp" class="back-link"><span class="egg"></span> メインページに戻る</a>
    </div>
</div>

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

    document.querySelectorAll('.qty-wrapper').forEach(wrapper => {
        const input = wrapper.querySelector('.qty-input');
        if (input.disabled) return; // 売り切れはスキップ
        
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

    function calculateTotal() {
        let total = 0;
        let hasItems = false;
        const rows = document.querySelectorAll('.menu-row');

        rows.forEach(row => {
            const price = parseInt(row.getAttribute('data-price'));
            const qtyInput = row.querySelector('.qty-input');
            const qty = qtyInput ? (parseInt(qtyInput.value) || 0) : 0;
            if (qty > 0) hasItems = true;
            total += price * qty;
        });
        
        if (hasItems && myKameShellCheck.checked) {
            total = Math.max(0, total - 200); 
        }
        
        priceDisplay.textContent = total.toLocaleString();

        const splitCount = Math.max(1, parseInt(splitCountInput.value) || 1);
        const splitPrice = Math.ceil(total / splitCount);
        splitPriceDisplay.textContent = splitPrice.toLocaleString();

        const points = Math.floor(total / 100);
        pointDisplay.textContent = points.toLocaleString();

        if (points === 0) {
            rankDisplay.textContent = "(見習いガメ)";
        } else if (points < 50) {
            rankDisplay.textContent = "(一人前ガメ)";
        } else if (points < 200) {
            rankDisplay.textContent = "(長寿アオウミガメ)";
        } else {
            rankDisplay.textContent = "(神の使い・玄武級)";
        }

        if (total === 0) {
            totalComment.textContent = "💬 なんか頼んでや…";
        } else if (total < 3000) {
            totalComment.textContent = "💬 ええね、のんびりお茶しよか。";
        } else if (total < 10000) {
            totalComment.textContent = "💬 結構頼んだなぁ！甲羅が重なりそうや。";
        } else {
            totalComment.textContent = "💬 豪遊や！竜宮城へご招待レベルやで！";
        }

        const activeStyle = document.querySelector('input[name="eatStyle"]:checked').value;
        if (activeStyle === 'sea' && total > 0) {
            let waterHeight = Math.min(85, Math.floor(total / 300) + 10);
            seaWater.style.height = waterHeight + "vh";
            document.body.classList.add('sea-active');
            summaryBar.classList.add('in-sea');
        } else {
            seaWater.style.height = "0vh";
            document.body.classList.remove('sea-active');
            summaryBar.classList.remove('in-sea');
        }
    }

    splitCountInput.addEventListener('input', calculateTotal);
    myKameShellCheck.addEventListener('change', calculateTotal);
    styleRadios.forEach(radio => radio.addEventListener('change', calculateTotal));

    const needReceiptCheck = document.getElementById('needReceipt');
    const receiptGroup = document.getElementById('receiptGroup');
    needReceiptCheck.addEventListener('change', () => {
        receiptGroup.style.display = needReceiptCheck.checked ? 'block' : 'none';
    });

    document.getElementById('submitBtn').addEventListener('click', () => {
        const currentPrice = parseInt(priceDisplay.textContent.replace(/,/g, '')) || 0;
        if (currentPrice === 0) {
            alert('🐢「何も選ばれてへんで。のんびり選んでな」');
            return;
        }

        if (needReceiptCheck.checked) {
            let nameInput = document.getElementById('receiptName').value.trim();
            if (!nameInput) {
                alert('🐢「領収書が必要なら、お名前を入れてな」');
                return;
            }
            if (!nameInput.endsWith('ガメ') && !nameInput.endsWith('亀') && !nameInput.endsWith('かめ')) {
                nameInput = nameInput + "ガメ";
            }
            document.getElementById('finalReceiptName').value = nameInput;
        }

        document.getElementById('orderForm').submit();
    });

    // 🎰 カメガチャ（売り切れ商品は除外）
    document.getElementById('gachaBtn').addEventListener('click', () => {
        const rows = document.querySelectorAll('.menu-row:not([data-category="secret"]):not(.sold-out-row)');
        if (rows.length === 0) {
            alert('🐢「ガチャを回せる販売中のメニューがないで…」');
            return;
        }
        
        const randomRow = rows[Math.floor(Math.random() * rows.length)];
        const input = randomRow.querySelector('.qty-input');
        
        input.value = (parseInt(input.value) || 0) + 1;
        calculateTotal();

        alert(`🎰 カメガチャ当選❣1つ増えたで🐢！`);
    });

    document.getElementById('resetBtn').addEventListener('click', () => {
        if (confirm('🐢「選んだメニューを全部リセットして、のんびりやり直す？」')) {
            document.querySelectorAll('.qty-input:not([disabled])').forEach(input => input.value = 0);
            splitCountInput.value = 1;
            myKameShellCheck.checked = false;
            needReceiptCheck.checked = false;
            receiptGroup.style.display = 'none';
            document.getElementById('receiptName').value = '';
            calculateTotal();
        }
    });

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
        
        if (scrollTop > 100) {
            kameTower.classList.add('show');
        } else {
            kameTower.classList.remove('show');
        }

        children.forEach((child, index) => {
            const triggerOffset = 200 + (index * 150);
            if (scrollTop > triggerOffset) {
                child.classList.add('visible');
            } else {
                child.classList.remove('visible');
            }
        });
    });

    document.getElementById('toTopBtn').addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
</script>
</body>
</html>