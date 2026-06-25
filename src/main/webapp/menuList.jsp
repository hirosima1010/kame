<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Menu" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>メニュー一覧 | カフェシステムkame</title>
</head>
<body>
    <h1>カフェメニュー一覧</h1>
    <h1>亀井晃弘</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>メニュー名</th>
            <th>価格</th>
        </tr>
        <%
            // サーブレットから受け取ったリストを取得
            List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
            if (menuList != null) {
                for (Menu menu : menuList) {
        %>
        <tr>
            <td><%= menu.getId() %></td>
            <td><%= menu.getName() %></td>
            <td><%= menu.getPrice() %> 円</td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>