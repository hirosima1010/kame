<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>管理者メイン画面</title>
</head>
<body>
    <h1>管理者メニュー</h1>
  
    <hr>
    
    <h3>メニュー</h3>
	<ul>
    	<li><a href="${pageContext.request.contextPath}/registerUser">スタッフ・管理者を新規追加する</a></li>
    	
    	<li><a href="${pageContext.request.contextPath}/registerMenu" class="btn-admin-add">新しいメニューを登録する</a>
		
    </ul>
</body>
</html>