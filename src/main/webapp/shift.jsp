<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Shift" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>シフト管理 | カフェシステムkame</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* シフト画面専用の追加スタイル */
        .shift-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .shift-table th, .shift-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        .shift-table th {
            background-color: #f4f4f4;
            font-weight: bold;
        }
        .btn-detail {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
        }
        .btn-detail:hover {
            background-color: #45a049;
        }
        /* 🔒 パスワード入力用ポップアップ（モーダル）のスタイル */
        .modal {
            display: none; /* 最初は隠しておく */
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5); /* 背景を暗くする */
        }
        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 30px;
            border-radius: 10px;
            width: 350px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .modal-content h3 {
            margin-top: 0;
            color: #333;
        }
        .modal-input {
            width: 80%;
            padding: 10px;
            margin: 15px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
            text-align: center;
        }
        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .btn-cancel {
            background-color: #bbb;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-confirm {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>🐢 Staff Shift Schedule 🐢</h1>
        
        <p style="text-align: center; color: #666;">
            現在のログインユーザー: <strong>${sessionScope.user}</strong> さん (のんびり働こうな🐢)
        </p>

        <table class="shift-table">
            <thead>
                <tr>
                    <th>日付</th>
                    <th>スタッフ名</th>
                    <th>勤務時間</th>
                    <th>休憩</th>
                    <th>個人情報・明細</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Shift> shiftList = (List<Shift>) request.getAttribute("shiftList");
                    if (shiftList != null && !shiftList.isEmpty()) {
                        for (Shift s : shiftList) {
                %>
                <tr>
                    <td><strong><%= s.getWorkDate() %></strong></td>
                    <td><%= s.getStaffFullName() %></td>
                    <td><span class="status-badge" style="background:#e3f2fd; color:#0d47a1; padding:4px 8px;"><%= s.getStartTime() %> ～ <%= s.getEndTime() %></span></td>
                    <td><%= s.getBreakMinutes() %> 分</td>
                    <td>
                        <button class="btn-detail" onclick="openAuthModal('<%= s.getUsername() %>', '<%= s.getStaffFullName() %>')">
                            🔒 詳細表示
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5" style="color: #999; padding: 30px;">現在登録されているシフトはありません。🐢</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div class="text-center" style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/admin_main.jsp" class="btn-back" style="text-decoration: none;">管理メインへ戻る</a>
        </div>
    </div>

    <div id="authModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle">本人確認</h3>
            <p style="font-size: 13px; color: #666;">
                給料明細等の個人情報を表示します。<br>パスワードを入力してください。
            </p>
            
            <form action="${pageContext.request.contextPath}/shiftAuth" method="post">
                <input type="hidden" id="targetUsername" name="targetUsername">
                
                <input type="password" name="password" class="modal-input" placeholder="Password" required autocomplete="off">
                
                <div class="modal-buttons">
                    <button type="button" class="btn-cancel" onclick="closeAuthModal()">キャンセル</button>
                    <button type="submit" class="btn-confirm">認証して進む</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // ポップアップを開くJavaScript
        function openAuthModal(username, fullName) {
            document.getElementById('targetUsername').value = username;
            document.getElementById('modalTitle').textContent = fullName + " さんの本人確認";
            document.getElementById('authModal').style.display = "block";
        }

        // ポップアップを閉じるJavaScript
        function closeAuthModal() {
            document.getElementById('authModal').style.display = "none";
        }

        // ポップアップの外側をクリックした時も閉じるようにする
        window.onclick = function(event) {
            const modal = document.getElementById('authModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>