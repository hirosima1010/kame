<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 👇 ここにインポート文を追加します --%>
<%@ page import="java.util.List" %>
<%@ page import="model.Shift" %> <%-- ⚠️「model」の部分は実際のShiftクラスのパッケージ名に合わせて書き換えてください --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>シフトスケジュール</title>
</head>
<body>
<h1>シフトスケジュール</h1>
    
    <table border="1">
        <tr>
            <th>日付</th>
            <th>スタッフ名</th>
            <th>開始時間</th>
            <th>終了時間</th>
        </tr>
        <%
            List<Shift> shiftList = (List<Shift>) request.getAttribute("shiftList");
            if (shiftList != null) {
                for (Shift shift : shiftList) {
        %>
        <tr>
            <td><%= shift.getDate() %></td>
            <td><%= shift.getStaffName() %></td>
            <td><%= shift.getStartTime() %></td>
            <td><%= shift.getEndTime() %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
    
    <br>
    <a href="main.jsp">メインページに戻る</a>
</body>
</html>