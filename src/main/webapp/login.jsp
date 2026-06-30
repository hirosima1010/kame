<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
    <h2>ログイン</h2>
    <%-- エラーメッセージがあれば表示 --%>
    <p style="color:red">${error}</p>
    
    <form action="login" method="post">
        ID: <input type="text" name="username"><br>
        PASS: <input type="password" name="password"><br>
        <button type="submit">ログイン</button>
    </form>
</body>
</html>