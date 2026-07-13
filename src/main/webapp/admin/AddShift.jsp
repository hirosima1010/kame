<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.AppUser" %>
<%@ page import="model.Shift" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>シフト管理 | 管理者コンソール</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/shift.css">
</head>
<body>

    <div class="container">
        <h1 style="text-align: center; font-family: 'Times New Roman', serif; letter-spacing: 2px; margin-top: 30px; color: #3e2723;">
            SHIFT REGISTRATION & MANAGEMENT
        </h1>

        <div class="form-section">
            <%-- メッセージ表示エリア --%>
            <% String message = (String) request.getAttribute("message"); %>
            <% String error = (String) request.getAttribute("error"); %>
            <% if (message != null) { %>
                <div class="msg msg-success">✔ <%= message %></div>
            <% } %>
            <% if (error != null) { %>
                <div class="msg msg-error">⚠ <%= error %></div>
            <% } %>

            <%-- 📝 上半分：登録フォーム --%>
            <form action="${pageContext.request.contextPath}/addShift" method="post">
                <div class="form-group">
                    <label>スタッフを選択</label>
                    <select name="username" required>
                        <option value="">-- スタッフを選択してください --</option>
                        <% 
                            List<AppUser> userList = (List<AppUser>) request.getAttribute("userList");
                            if (userList != null) {
                                for (AppUser u : userList) {
                                    if (!"admin".equals(u.getRole())) { // 管理者は除外
                        %>
                                    <option value="<%= u.getUsername() %>"><%= u.getFullName() %> (<%= u.getUsername() %>)</option>
                        <% 
                                    }
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label>勤務日</label>
                    <input type="date" name="workDate" required>
                </div>

                <div class="time-range-container">
                    <div class="time-box form-group">
                        <label>開始時間</label>
                        <input type="time" name="startTime" required>
                    </div>
                    <div class="time-box form-group">
                        <label>終了時間</label>
                        <input type="time" name="endTime" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>休憩時間（分）</label>
                    <input type="number" name="breakMinutes" min="0" value="0" required>
                </div>

                <button type="submit" class="btn-submit">シフトを登録する</button>
            </form>

            <hr style="border: 0; border-top: 1px dashed #d7ccc8; margin: 40px 0;">

            <%-- 📋 下半分：登録済みシフト一覧 --%>
            <h2 style="color: #4e342e; font-size: 18px; margin-bottom: 15px;">📋 登録済みシフト一覧</h2>
            <div class="table-wrapper">
                <table class="shift-table">
                    <thead>
                        <tr>
                            <th>スタッフ名</th>
                            <th>勤務日</th>
                            <th>開始時間</th>
                            <th>終了時間</th>
                            <th>休憩</th>
                            <th>予定時間</th>
                            <th>概算給与</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
    <%
        List<Shift> currentShiftList = (List<Shift>) request.getAttribute("shiftList");
        if (currentShiftList != null && !currentShiftList.isEmpty()) {
            for (Shift s : currentShiftList) {
                
                long displayHours = 0;
                long displayMinutes = 0;
                
                if (s.getStartTime() != null && s.getEndTime() != null) {
                    // 💡 getHour()やgetMinute()を使わず、Stringから安全に切り出す
                    String startStr = s.getStartTime().toString(); 
                    String endStr = s.getEndTime().toString();     
                    
                    int startH = Integer.parseInt(startStr.substring(0, 2));
                    int startM = Integer.parseInt(startStr.substring(3, 5));
                    int endH = Integer.parseInt(endStr.substring(0, 2));
                    int endM = Integer.parseInt(endStr.substring(3, 5));
                    
                    int totalDiffMin = (endH * 60 + endM) - (startH * 60 + startM);
                    
                    // 休憩時間をマイナス
                    int finalWorkMin = totalDiffMin - s.getBreakMinutes();
                    
                    if (finalWorkMin > 0) {
                        displayHours = finalWorkMin / 60;
                        displayMinutes = finalWorkMin % 60;
                    }
                }
    %>
        <tr>
            <%-- 💡 エラーの原因だった getUserFullName や getEstimatedPay を完全に排除した、あなたの本来のフィールド構成 --%>
            <td><%= s.getUsername() %></td>
            <td><%= s.getWorkDate() %></td>
            <td><%= s.getStartTime() != null ? s.getStartTime().toString().substring(0, 5) : "" %></td>
            <td><%= s.getEndTime() != null ? s.getEndTime().toString().substring(0, 5) : "" %></td>
            <td><%= s.getBreakMinutes() %>分</td>
            
            <%-- 💡 予定時間を正しく計算して表示！ --%>
            <td><strong><%= displayHours %>時間<%= displayMinutes %>分</strong></td>
            
            <td>
                <div class="action-container">
                    <a href="${pageContext.request.contextPath}/editShift?shiftId=<%= s.getId() %>" class="btn-edit">編集</a>

                    <form action="${pageContext.request.contextPath}/manageShifts" method="post" onsubmit="return confirm('このシフトを本当に削除しますか？');" class="delete-form">
                        <input type="hidden" name="shiftId" value="<%= s.getId() %>">
                        <button type="submit" class="btn-delete">削除</button>
                    </form>
                </div>
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
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/admin/admin_main.jsp" style="color: #8d6e63; text-decoration: none; font-weight: bold;">← 管理者メインへ戻る</a>
            </div>
        </div>
    </div>

</body>
</html>