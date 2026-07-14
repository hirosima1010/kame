<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.AppUser" %>
<%
    // ① セッションから LoginServlet が保存した "loginuser" を正しく取得する
    AppUser loginUser = (AppUser) session.getAttribute("loginuser");

    // 安全対策：もし直接このURLを叩くなどしてログインしてない場合は、ログイン画面へ
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>スタッフポータル | カフェシステムkame</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            font-family: 'Montserrat', 'Noto Sans JP', sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 40px 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        /* ユーザーウェルカムエリア */
        .welcome-hero {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            text-align: center;
            margin-bottom: 30px;
            border-top: 5px solid #00704A;
        }
        .welcome-hero h1 {
            font-size: 22px;
            color: #00704A;
            margin: 0 0 10px 0;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .user-name {
            font-size: 18px;
            font-weight: 700;
            color: #212529;
        }
        .user-meta {
            font-size: 12px;
            color: #868e96;
            margin-top: 4px;
        }

        /* メニューグリッド */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        /* タイルカードスタイル */
        .menu-card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.02);
            text-decoration: none;
            color: #333;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s ease;
            border: 1px solid #edf2f7;
            position: relative;
            overflow: hidden;
        }
        .menu-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0, 112, 74, 0.08);
            border-color: rgba(0, 112, 74, 0.2);
        }
        .card-icon {
            font-size: 28px;
            margin-bottom: 15px;
        }
        .card-title {
            font-size: 15px;
            font-weight: 700;
            color: #212529;
            margin-bottom: 8px;
        }
        .card-desc {
            font-size: 12px;
            color: #718096;
            line-height: 1.5;
        }
        
        /* 各カードのアクセントカラーバー */
        .menu-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
        }
        .card-order::before { background: #00704A; }
        .card-shift::before { background: #4db6ac; }
        .card-sales::before { background: #388e3c; }
        .card-history::before { background: #f57c00; }
        .card-pl::before { background: #ffc107; } /* 💡 新設した甲羅勘定（plt項目）のカラーバー */

        .logout-container {
            text-align: center;
        }
        .btn-logout {
            display: inline-block;
            background-color: #e2e8f0;
            color: #4a5568;
            text-decoration: none;
            padding: 12px 30px;
            font-size: 13px;
            font-weight: bold;
            border-radius: 30px;
            transition: background 0.2s;
        }
        .btn-logout:hover {
            background-color: #cbd5e0;
        }
    </style>
</head>
<body>

    <div class="container">
        
        <!-- ウェルカムエリア -->
        <div class="welcome-hero">
            <h1>🐢 KAME CAFE SYSTEM</h1>
            <div class="user-name">Welcome back, <%= loginUser.getFullName() %> さん</div>
            <div class="user-meta">STAFF ID: <%= loginUser.getUsername() %> • 一般スタッフモード</div>
        </div>
        
        <!-- 機能メニューグリッド -->
        <div class="menu-grid">
            
            <!-- ① 注文入力 -->
            <a href="${pageContext.request.contextPath}/menuList" class="menu-card card-order">
                <div>
                    <div class="card-icon">🛒</div>
                    <div class="card-title">注文入力・メニュー</div>
                    <div class="card-desc">カメ仕様のオーダーを受け付け、PostgreSQLへデータを安全に記録します。</div>
                </div>
            </a>
            
            <!-- ② シフト確認 -->
            <a href="${pageContext.request.contextPath}/viewStaffShifts?username=<%= loginUser.getUsername() %>" class="menu-card card-shift">
                <div>
                    <div class="card-icon">🗓️</div>
                    <div class="card-title">シフト・給料明細</div>
                    <div class="card-desc">当月の担当シフトスケジュールおよび支給明細をリアルタイムに確認します。</div>
                </div>
            </a>
            
            <!-- ③ 当日売上モニタ -->
            <a href="${pageContext.request.contextPath}/sales" class="menu-card card-sales">
                <div>
                    <div class="card-icon">📊</div>
                    <div class="card-title">売上プロット分析 (plt)</div>
                    <div class="card-desc">Chart.jsで可視化された本日の売上、売れ筋ランキングのグラフを分析します。</div>
                </div>
            </a>
            
            <!-- ④ 注文履歴 -->
            <a href="orderHistory" class="menu-card card-history">
                <div>
                    <div class="card-icon">📜</div>
                    <div class="card-title">注文履歴ログ</div>
                    <div class="card-desc">データベースに蓄積された過去の注文詳細とレシート内訳を確認・管理します。</div>
                </div>
            </a>

            <!-- ⑤ 甲羅勘定（plt連携先） -->
            <a href="${pageContext.request.contextPath}/pl" class="menu-card card-pl">
                <div>
                    <div class="card-icon">💰</div>
                    <div class="card-title">甲羅勘定（損益計算）</div>
                    <div class="card-desc">売上原価や人件費などの固定経費を差し引いた、お店の純カメ利益を算出します。</div>
                </div>
            </a>
            <!-- ⑥ 発注・仕入れ管理（新設） -->
			<a href="${pageContext.request.contextPath}/purchase" class="menu-card card-history" style="border-top-color: #b45309;">
    			<div>
        			<div class="card-icon">📦</div>
        			<div class="card-title">発注・仕入れ管理</div>
        			<div class="card-desc">コーヒー豆やエサ代などの仕入れ原価を入力し、リアルタイム経費としてDBに計上します。</div>
    			</div>
			</a>
            
        </div>
        
        <!-- ログアウトエリア -->
        <div class="logout-container">
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">ログアウト</a>
        </div>
    </div>

</body>
</html>