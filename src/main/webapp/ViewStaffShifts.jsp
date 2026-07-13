<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Shift" %>
<%@ page import="model.AppUser" %> <%-- 💡 これでAppUserのgetFullName()が使えるようになります --%>
<%
    List<Shift> myShiftList = (List<Shift>) request.getAttribute("myShiftList");
    if (myShiftList == null) {
        myShiftList = (List<Shift>) request.getAttribute("shiftList");
    }
    
    String staffName = "";
    // 💡 リストではなくセッション(loginuser)から現在ログイン中の本物のユーザーを呼ぶ
    AppUser realLoginUser = (AppUser) session.getAttribute("loginuser");
    if (realLoginUser != null) {
        // 💡 確定した getFullName() を使用して本名を取得！
        staffName = realLoginUser.getFullName(); 
        
        if (staffName == null || staffName.isEmpty()) {
            staffName = realLoginUser.getUsername(); 
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>マイシフト＆仲間確認 | カフェシステムkame</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .shift-table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #fff; }
        .shift-table th, .shift-table td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        .shift-table th { background-color: #e8f5e9; color: #2e7d32; font-weight: bold; }
        .btn-detail { background-color: #2e7d32; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
        .btn-detail:hover { background-color: #1b5e20; }
        .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: #fff; margin: 15% auto; padding: 30px; border-radius: 10px; width: 350px; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .modal-input { width: 80%; padding: 10px; margin: 15px 0; border: 1px solid #ccc; border-radius: 4px; font-size: 16px; text-align: center; }
        .modal-buttons { display: flex; justify-content: center; gap: 10px; }
        .btn-cancel { background-color: #bbb; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
        .btn-confirm { background-color: #007bff; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>

    <div class="container">
        <h1>🐢 My Shift & Team Schedule 🐢</h1>
        
        <p style="text-align: center; color: #666; margin-bottom: 30px;">
            現在のログインユーザー: <strong><%= (staffName == null || staffName.isEmpty()) ? "スタッフ" : staffName %></strong> さん (のんびり働こうな🐢)
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <p style="color: red; text-align: center; font-weight: bold;"><%= request.getAttribute("error") %></p>
        <% } %>

        <table class="shift-table">
            <thead>
                <tr>
                    <th>スタッフ名</th>
                    <th>勤務日</th>
                    <th>開始</th>
                    <th>終了</th>
                    <th>休憩</th>
                    <th>予定時間</th>
                    <th>個人情報・明細</th>
                </tr>
            </thead>
            <tbody>
    <%
        if (myShiftList != null && !myShiftList.isEmpty()) {
            for (Shift s : myShiftList) {
                
                long displayHours = 0;
                long displayMinutes = 0;
                
                if (s.getStartTime() != null && s.getEndTime() != null) {
                    String startStr = s.getStartTime().toString(); 
                    String endStr = s.getEndTime().toString();     
                    
                    int startH = Integer.parseInt(startStr.substring(0, 2));
                    int startM = Integer.parseInt(startStr.substring(3, 5));
                    int endH = Integer.parseInt(endStr.substring(0, 2));
                    int endM = Integer.parseInt(endStr.substring(3, 5));
                    
                    int startTotalMin = startH * 60 + startM;
                    int endTotalMin = endH * 60 + endM;
                    
                    if (endTotalMin <= startTotalMin) {
                        endTotalMin += 24 * 60; 
                    }
                    
                    int totalDiffMin = endTotalMin - startTotalMin;
                    int finalWorkMin = totalDiffMin - s.getBreakMinutes();
                    
                    if (finalWorkMin > 0) {
                        displayHours = finalWorkMin / 60;
                        displayMinutes = finalWorkMin % 60;
                    }
                }
                
                String displayName = s.getStaffFullName();
                if (displayName == null || displayName.isEmpty()) {
                    displayName = s.getUsername(); 
                }
    %>
        <tr>
            <td><%= displayName %></td>
            <td><%= s.getWorkDate() %></td>
            <td><%= s.getStartTime() != null ? s.getStartTime().toString().substring(0, 5) : "" %></td>
            <td><%= s.getEndTime() != null ? s.getEndTime().toString().substring(0, 5) : "" %></td>
            <td><%= s.getBreakMinutes() %>分</td>
            <td><strong style="color: #2e7d32;"><%= displayHours %>時間<%= displayMinutes %>分</strong></td>
            <td>
                <button type="button" class="btn-detail" onclick="openAuthModal('<%= s.getUsername() %>', '<%= displayName %>')">
                    🔒 詳細表示
                </button>
            </td>
        </tr>
    <%
            }
        } else {
    %>
        <tr>
            <td colspan="7" style="color: #999; text-align: center; padding: 20px;">登録されているシフトがありません。</td>
        </tr>
    <%
        }
    %>
</tbody>
        </table>

        <div class="text-center" style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/staff_main.jsp" class="btn-back" style="text-decoration: none; background-color: #bbb; color: white; padding: 10px 20px; border-radius: 4px;">スタッフメインへ戻る</a>
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
        function openAuthModal(username, fullName) {
            document.getElementById('targetUsername').value = username; 
            document.getElementById('modalTitle').textContent = fullName + " さんの本人確認"; 
            document.getElementById('authModal').style.display = "block";
        }
        function closeAuthModal() {
            document.getElementById('authModal').style.display = "none";
        }
        window.onclick = function(event) {
            const modal = document.getElementById('authModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>