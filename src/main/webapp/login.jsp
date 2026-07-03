<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ログイン - Cafe System</title>
    
    <style>
        /* ==========================================================================
           🌿 サードウェーブ・カフェスタイル ログイン画面専用インラインCSS
           ========================================================================== */
        
        /* 画面いっぱいに広げて、ログインボックスを完全に中央ロック */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f5f1ea; /* リッチなミルクティーベージュ */
            color: #2b221e; /* 深煎りコーヒーのビターブラウン */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        /* 中央寄せコンテナ */
        .login-container {
            width: 100%;
            max-width: 420px;
            padding: 20px;
            box-sizing: border-box;
        }

        /* ロゴエリア */
        .login-logo {
            text-align: center;
            margin-bottom: 35px;
        }
        .login-logo span {
            font-size: 36px;
            display: block;
            margin-bottom: 10px;
            animation: coffeeFloat 3s ease-in-out infinite; /* カフェの湯気のようにふんわり揺れる */
        }
        .login-logo h1 {
            font-family: 'Cinzel', 'Didot', 'Hiragino Mincho ProN', serif;
            font-size: 20px;
            font-weight: 400;
            letter-spacing: 0.2em;
            color: #2b221e;
            margin: 0;
            text-transform: uppercase;
        }

        /* エラーメッセージ（スタイリッシュな警告ボックス） */
        .error-msg {
            padding: 14px;
            border-radius: 8px;
            font-size: 13px;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
            letter-spacing: 0.05em;
            background-color: #fbf2f2;
            color: #a63a3a;
            border: 1px solid #f2dadb;
        }

        /* ログインカード（浮かび上がるホワイトカード） */
        .login-card {
            background: #ffffff;
            padding: 40px 35px;
            border-radius: 12px;
            border: 1px solid #ebdcd0;
            box-shadow: 0 10px 40px rgba(74, 59, 50, 0.06);
        }

        .login-card h2 {
            font-size: 15px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: #8c7667;
            text-align: center;
            margin-top: 0;
            margin-bottom: 35px;
        }

        /* 縦並びの美しく揃うフォームグループ */
        .form-group-login {
            margin-bottom: 25px;
        }

        .form-group-login label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            color: #8c8275;
            letter-spacing: 0.1em;
            margin-bottom: 8px;
        }

        /* 入力欄（横幅を100%に広げてピシッと揃える） */
        .form-group-login input[type="text"],
        .form-group-login input[type="password"] {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #dcd3c4;
            border-radius: 6px;
            background-color: #faf9f6;
            color: #2b221e;
            font-size: 14px;
            transition: all 0.25s ease;
            box-sizing: border-box;
        }

        .form-group-login input:focus {
            outline: none;
            border-color: #2b221e;
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(43, 34, 30, 0.08);
        }

        /* ログインボタン（フラットモダン） */
        .btn-login {
            width: 100%;
            background-color: #2b221e;
            color: #ffffff;
            padding: 15px 0;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.15em;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(43, 34, 30, 0.15);
            margin-top: 10px;
        }

        .btn-login:hover {
            background-color: #4a3b32;
            box-shadow: 0 6px 16px rgba(43, 34, 30, 0.25);
        }

        /* コピーライト */
        .login-footer {
            text-align: center;
            font-size: 11px;
            color: #aba094;
            margin-top: 30px;
            letter-spacing: 0.05em;
        }

        /* ☕️ アイコンがふんわり浮き沈みするアニメーション */
        @keyframes coffeeFloat {
            0% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
            100% { transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-logo">
            <span>☕️</span>
            <h1>CAFE MANAGEMENT</h1>
        </div>
        
        <%-- エラーメッセージがあれば表示 --%>
        <% if (request.getAttribute("error") != null && !((String)request.getAttribute("error")).isEmpty()) { %>
            <div class="error-msg">${error}</div>
        <% } %>
        
        <div class="login-card">
            <h2>Sign In</h2>
            <form action="login" method="post">
                <div class="form-group-login">
                    <label>USER ID</label>
                    <input type="text" name="username" placeholder="ユーザーIDを入力" required autocomplete="username">
                </div>
                
                <div class="form-group-login">
                    <label>PASSWORD</label>
                    <input type="password" name="password" placeholder="パスワードを入力" required autocomplete="current-password">
                </div>
                
                <button type="submit" class="btn-login">LOGIN</button>
            </form>
        </div>
        
        <div class="login-footer">
            &copy; 2026 Your Brand Cafe System. All Rights Reserved.
        </div>
    </div>

</body>
</html>