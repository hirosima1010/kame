<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理者メイン画面</title>
    <%-- 💡 管理者側はすべてあなたのCSS（shift.css）で統一！ --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/shift.css">
    <style>
        .admin-box {
            background-color: #f7f5f2;
            border: 2px dashed #8d6e63;
            border-radius: 12px;
            padding: 25px;
            margin-top: 20px;
        }
        .admin-menu-list {
            list-style: none;
            padding: 0;
        }
        .admin-menu-list li {
            margin: 15px 0;
        }
        .admin-link {
            display: inline-block;
            color: #5d4037;
            font-weight: bold;
            text-decoration: none;
            padding: 5px 10px;
            border-bottom: 2px solid #d7ccc8;
            transition: all 0.2s;
        }
        .admin-link:hover {
            color: #8d6e63;
            border-bottom-color: #8d6e63;
            padding-left: 15px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1 style="text-align: center; font-family: 'Times New Roman', serif; letter-spacing: 2px; margin-top: 30px; color: #3e2723;">
            ADMINISTRATOR MENU
        </h1>
  
        <div class="form-section">
            <p style="text-align: center; color: #777; font-size: 14px;">
                現在のログインユーザー: <strong>${sessionScope.user}</strong> さん (管理者モード)
            </p>

            <div class="admin-box">
                <h3 style="margin-top: 0; color: #3e2723; border-bottom: 1px solid #8d6e63; padding-bottom: 5px;">📋 管理メニュー</h3>
                <ul class="admin-menu-list">
                    <li>
                        <a href="${pageContext.request.contextPath}/registerUser" class="admin-link">
                            👤 スタッフ・管理者を新規追加する
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/registerMenu" class="admin-link">
                            ☕ 新しいメニューを登録する
                        </a>
                    </li>
                    <li>
                        <%-- 💡 修正：あなたの作ったブラウン系のシフト登録・一覧画面（AddShift.jsp）へ正しく繋ぎました！ --%>
                        <a href="${pageContext.request.contextPath}/addShift" class="admin-link">
                            🗓️ シフトスケジュールを確認・管理する
                        </a>
                    </li>
                </ul>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/logout" class="back-link" style="background-color: #8d6e63; color: white; padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 13px;">ログアウト</a>
            </div>
        </div>
    </div>

</body>
</html>