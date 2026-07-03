<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Menu" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>メニュー編集</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="container">
        <h1>Edit Cafe Menu</h1>
        
        <%
            Menu menu = (Menu) request.getAttribute("menu");
            if (menu == null) {
        %>
            <div class="error-msg">メニューデータが見つかりませんでした。</div>
            <div class="footer-nav">
                <a href="${pageContext.request.contextPath}/registerMenu" class="btn-back">← メニュー一覧へ戻る</a>
            </div>
        <%
                return;
            }
        %>
        
        <form action="${pageContext.request.contextPath}/editMenu" method="post">
            
            <input type="hidden" name="id" value="<%= menu.getId() %>">
            
            <div class="form-section">
                <h3>Menu Basic Info <span class="required">必須</span></h3>
                <div class="form-group">
                    <label>メニュー名</label>
                    <input type="text" name="menuName" required value="<%= menu.getMenuName() %>">
                </div>
                <div class="form-group">
                    <label>フリガナ (音順ソート用)</label>
                    <input type="text" name="kanaName" required value="<%= menu.getKanaName() %>">
                </div>
                <div class="form-group">
                    <label>価格 (円)</label>
                    <input type="number" name="price" required min="0" value="<%= menu.getPrice() %>">
                </div>
                <div class="form-group">
                    <label>カテゴリ</label>
                    <select name="category" required>
                        <option value="カメドリンク" <%= "カメドリンク".equals(menu.getCategory()) ? "selected" : "" %>>カメドリンク</option>
                        <option value="カメフード" <%= "カメフード".equals(menu.getCategory()) ? "selected" : "" %>>カメフード</option>
                        <option value="スイーツ" <%= "スイーツ".equals(menu.getCategory()) ? "selected" : "" %>>スイーツ</option>
                        <option value="コーヒー豆・茶葉" <%= "コーヒー豆・茶葉".equals(menu.getCategory()) ? "selected" : "" %>>コーヒー豆・茶葉</option>
                        <option value="グッズ・道具" <%= "グッズ・道具".equals(menu.getCategory()) ? "selected" : "" %>>グッズ・道具</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>販売ステータス</label>
                    <select name="isAvailable" required>
                        <option value="true" <%= menu.isAvailable() ? "selected" : "" %>>🟢 販売中</option>
                        <option value="false" <%= !menu.isAvailable() ? "selected" : "" %>>🔴 売り切れ</option>
                    </select>
                </div>
            </div>
            
            <div class="form-section">
                <h3>Details & Marketing</h3>
                <div class="form-group">
                    <label>商品説明 (メニュー表示用)</label>
                    <textarea name="description" rows="3" class="w-full" placeholder="深煎りでコクのある、当店自慢のブレンドです。"><%= menu.getDescription() != null ? menu.getDescription().trim() : "" %></textarea>
                </div>
                <div class="form-group">
                    <label>アレルギー情報</label>
                    <input type="text" name="allergyInfo" value="<%= menu.getAllergyInfo() != null ? menu.getAllergyInfo() : "なし" %>">
                </div>
                <div class="form-group" style="display: flex; gap: 20px; align-items: center; margin-top: 15px;">
                    <label style="margin: 0;">
                        <input type="checkbox" name="isRecommend" value="true" <%= menu.isRecommend() ? "checked" : "" %>> ⭐ おすすめ商品にする
                    </label>
                    <label style="margin: 0;">
                        <input type="checkbox" name="isLimited" value="true" <%= menu.isLimited() ? "checked" : "" %>> 📅 期間限定商品にする
                    </label>
                </div>
            </div>

            <div class="text-center" style="margin-top: 20px; display: flex; gap: 15px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/registerMenu" class="btn-back" style="text-decoration: none; line-height: 2.5;">キャンセル</a>
                <button type="submit" class="btn-submit">メニュー情報を更新する</button>
            </div>
        </form>
    </div>
</body>
</html>