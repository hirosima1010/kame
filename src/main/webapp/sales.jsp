<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>売上実績一覧</h1>
    
    <table border="1">
        <tr>
            <th>売上日時</th>
            <th>注文ID</th>
            <th>合計金額</th>
        </tr>
        <%
            List<Sales> salesList = (List<Sales>) request.getAttribute("salesList");
            int totalSales = 0;
            if (salesList != null) {
                for (Sales sales : salesList) {
                    totalSales += sales.getAmount();
        %>
        <tr>
            <td><%= sales.getDateTime() %></td>
            <td><%= sales.getOrderId() %></td>
            <td><%= sales.getAmount() %> 円</td>
        </tr>
        <%
                }
            }
        %>
        <tr style="background-color: #f2f2f2; font-weight: bold;">
            <td colspan="2" style="text-align: right;">総合計：</td>
            <td><%= totalSales %> 円</td>
        </tr>
    </table>
    
    <br>
    <a href="main.jsp">メインページに戻る</a>
</body>
</html>