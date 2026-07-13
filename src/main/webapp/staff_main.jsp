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
    <title>メインページ | カフェシステムkame</title>
    <%-- スタッフ側なので、友達の作ったグリーン系のCSS（style.css）を適用 --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .staff-box {
            background-color: #fff;
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 30px;
            margin-top: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .staff-menu-list {
            list-style: none;
            padding: 0;
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 25px;
        }
        .btn-staff-link {
            display: block;
            text-align: center;
            background-color: #2e7d32; /* 友達のテーマカラー（深緑） */
            color: white;
            text-decoration: none;
            padding: 15px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 16px;
            transition: background-color 0.2s;
        }
        .btn-staff-link:hover {
            background-color: #1b5e20;
        }
        .logout-container {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>🐢 Staff Main Portal 🐢</h1>
        
        <div class="staff-box">
            <p style="text-align: center; font-size: 18px; margin-bottom: 10px;">
                ようこそ、 <strong><%= loginUser.getFullName() %></strong> さん！
            </p>
            <p style="text-align: center; color: #666; font-size: 13px; margin-bottom: 20px;">
                スタッフID: <%= loginUser.getUsername() %> (一般スタッフモード)
            </p>

            <ul class="staff-menu-list">
                <li>
                    <%-- メニューデータを準備して order.jsp へフォワードするサーブレットを呼び出す --%>
                    <a href="${pageContext.request.contextPath}/menuList" class="btn-staff-link">
                        🛒 注文入力・カフェメニュー一覧（カメ仕様）
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/viewStaffShifts?username=<%= loginUser.getUsername() %>" class="btn-staff-link" style="background-color: #4db6ac;">
                        🗓️ シフト・給料明細を確認する
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/sales" class="btn-staff-link" style="background-color: #388e3c;">
                        📋 当日売上モニタ（Sales）を確認する
                    </a>
                </li>
                <li>
                    <%-- 💡 修正：周りのボタンと共通のクラスを適用して、色をかっこいいゴールドオレンジ風（#f57c00）にしたカメ！ --%>
                    <a href="orderHistory" class="btn-staff-link" style="background-color: #f57c00;">
                        📜 注文履歴を見る（PostgreSQL売上管理）
                    </a>
                </li>
            </ul>
        </div>
        
        <div class="logout-container">
            <a href="${pageContext.request.contextPath}/logout" class="btn-back" style="text-decoration: none; background-color: #bbb;">ログアウト</a>
        </div>
    </div>

</body>
</html>