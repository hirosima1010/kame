<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>注文入力</h1>
    <p>ようこそ、 <%= session.getAttribute("user") %>さん！</p>
    
    <form action="orderSubmit" method="post">
        <table border="1">
            <tr>
                <th>メニュー名</th>
                <th>価格</th>
                <th>数量</th>
            </tr>
            <%
                List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
                if (menuList != null) {
                    for (Menu menu : menuList) {
            %>
            <tr>
                <td><%= menu.getName() %></td>
                <td><%= menu.getPrice() %> 円</td>
                <td>
                    <input type="number" name="quantity_<%= menu.getId() %>" value="0" min="0" style="width: 60px;">
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
        <br>
        <button type="submit">注文を確定する</button>
    </form>
    
    <br>
    <a href="main.jsp">メインページに戻る</a>
</body>
</html>