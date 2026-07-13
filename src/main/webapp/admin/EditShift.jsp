<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Shift" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>シフト編集 | 管理者コンソール</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/shift.css">
</head>
<body>

    <div class="container">
        <h1 style="text-align: center; font-family: 'Times New Roman', serif; letter-spacing: 2px; margin-top: 30px; color: #3e2723;">
            EDIT SHIFT
        </h1>

        <div class="form-section">
            <%
                // サーブレットから渡された、編集対象のシフトデータを取得
                Shift shift = (Shift) request.getAttribute("shift");
                if (shift != null) {
            %>
                <form action="${pageContext.request.contextPath}/editShift" method="post">
                    <%-- 💡 どのシフトを更新するか識別するため、IDを隠しデータ（hidden）として送信 --%>
                    <input type="hidden" name="id" value="<%= shift.getId() %>">

                    <div class="form-group">
                        <label>スタッフID</label>
                        <%-- 誰のシフトか変更させないために disabled にし、値は隠しデータでも送る --%>
                        <input type="text" class="form-control" value="<%= shift.getUsername() %>" disabled>
                        <input type="hidden" name="username" value="<%= shift.getUsername() %>">
                    </div>

                    <div class="form-group">
                        <label>勤務日</label>
                        <input type="date" name="workDate" class="form-control" value="<%= shift.getWorkDate() %>" required>
                    </div>

                    <div class="time-range-container">
                        <div class="time-box form-group">
                            <label>開始時間</label>
                            <input type="time" name="startTime" class="form-control" value="<%= shift.getStartTime() != null ? shift.getStartTime().toString().substring(0, 5) : "" %>" required>
                        </div>
                        <div class="time-box form-group">
                            <label>終了時間</label>
                            <input type="time" name="endTime" class="form-control" value="<%= shift.getEndTime() != null ? shift.getEndTime().toString().substring(0, 5) : "" %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>休憩時間（分）</label>
                        <input type="number" name="breakMinutes" class="form-control" value="<%= shift.getBreakMinutes() %>" min="0" required>
                    </div>

                    <button type="submit" class="btn-submit">変更を保存する</button>
                </form>
            <%
                } else {
            %>
                <p style="text-align: center; color: #c62828;">該当するシフトデータが見つかりませんでした。</p>
            <%
                }
            %>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/addShift" style="color: #8d6e63;">戻る</a>
            </div>
        </div>
    </div>

</body>
</html>