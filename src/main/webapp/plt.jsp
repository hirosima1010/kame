<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>PLT（損益計算書）</h1>
    
    <%
        // サーブレット側で計算された各金額を取得（なければ0）
        int sales = request.getAttribute("sales") != null ? (Integer) request.getAttribute("sales") : 0;
        int costOfGoods = request.getAttribute("costOfGoods") != null ? (Integer) request.getAttribute("costOfGoods") : 0;
        int laborCost = request.getAttribute("laborCost") != null ? (Integer) request.getAttribute("laborCost") : 0;
        int expenses = request.getAttribute("expenses") != null ? (Integer) request.getAttribute("expenses") : 0;
        
        // 粗利益、営業利益の計算
        int grossProfit = sales - costOfGoods;
        int netProfit = grossProfit - (laborCost + expenses);
    %>
    
    <table border="1" style="width: 300px; border-collapse: collapse;">
        <tr style="background-color: #e6f7ff;">
            <th>項目</th>
            <th>金額</th>
        </tr>
        <tr>
            <td><strong>売上高</strong></td>
            <td style="text-align: right;"><%= sales %> 円</td>
        </tr>
        <tr>
            <td>売上原価 (食材費等)</td>
            <td style="text-align: right;">- <%= costOfGoods %> 円</td>
        </tr>
        <tr style="background-color: #fafafa; font-weight: bold;">
            <td>売上総利益 (粗利)</td>
            <td style="text-align: right;"><%= grossProfit %> 円</td>
        </tr>
        <tr>
            <td>人件費</td>
            <td style="text-align: right;">- <%= laborCost %> 円</td>
        </tr>
        <tr>
            <td>その他経費 (家賃・光熱費等)</td>
            <td style="text-align: right;">- <%= expenses %> 円</td>
        </tr>
        <tr style="background-color: #ffe6e6; font-weight: bold; font-size: 1.1em;">
            <td>営業利益</td>
            <td style="text-align: right;"><%= netProfit %> 円</td>
        </tr>
    </table>
    
    <br>
    <a href="main.jsp">メインページに戻る</a>
</body>
</html>