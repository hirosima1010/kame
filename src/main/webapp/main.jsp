<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>メインページ</title>
</head>
<body>
	<h1>メインページ</h1>
	<p>ようこそ、 <%= session.getAttribute("user") %>さん！</p>
	
	<a href="menuList">メニュー一覧</a>
	<br>
	<a href="logout">ログアウト</a>
</body>
</html>