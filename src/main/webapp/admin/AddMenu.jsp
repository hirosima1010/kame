<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>メニュー登録・管理</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="container">
        <h1>Cafe Menu Management</h1>
        
        <% 
            // セッションからメッセージを取得
            String statusMsg = (String) session.getAttribute("message");
            String errorMsg = (String) session.getAttribute("error");
            
            // 一度取得したらセッションからは削除する（リロード時に消すため）
            if (statusMsg != null) session.removeAttribute("message");
            if (errorMsg != null) session.removeAttribute("error");
        %>

        <% if (statusMsg != null && !statusMsg.isEmpty()) { %>
            <div class="status-msg"><%= statusMsg %></div>
        <% } %>

        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="error-msg"><%= errorMsg %></div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/registerMenu" method="post">
            
            <div class="form-section">
                <h3>Menu Basic Info <span class="required">必須</span></h3>
                <div class="form-group">
                    <label>メニュー名</label>
                    <input type="text" name="menuName" required placeholder="例: ブレンドコーヒー">
                </div>
                <div class="form-group">
                    <label>フリガナ (音順ソート用)</label>
                    <input type="text" name="kanaName" required placeholder="例: ブレンドコーヒー">
                </div>
                <div class="form-group">
                    <label>価格 (円)</label>
                    <input type="number" name="price" required min="0" value="0">
                </div>
                <div class="form-group">
                    <label>カテゴリ</label>
                    <select name="category" required>
                        <option value="カメドリンク">カメドリンク</option>
                        <option value="カメフード">カメフード</option>
                        <option value="スイーツ">スイーツ</option>
                        <option value="コーヒー豆・茶葉">コーヒー豆・茶葉</option>
                        <option value="グッズ・道具">グッズ・道具</option>
                    </select>
                </div>
            </div>
            
            <div class="form-section">
                <h3>Details & Marketing</h3>
                <div class="form-group">
                    <label>商品説明 (メニュー表示用)</label>
                    <textarea name="description" rows="3" class="w-full" placeholder="深煎りでコクのある、当店自慢のブレンドです。"></textarea>
                </div>
                <div class="form-group">
                    <label>アレルギー情報</label>
                    <input type="text" name="allergyInfo" value="なし" placeholder="例: 卵, 乳, 小麦">
                </div>
                <div class="form-group" style="display: flex; gap: 20px; align-items: center; margin-top: 15px;">
                    <label style="margin: 0;">
                        <input type="checkbox" name="isRecommend" value="true"> ⭐ おすすめ商品にする
                    </label>
                    <label style="margin: 0;">
                        <input type="checkbox" name="isLimited" value="true"> 📅 期間限定商品にする
                    </label>
                </div>
            </div>

            <div class="text-center">
                <button type="submit" class="btn-submit">メニューを登録する</button>
            </div>
        </form>
        
        <hr>
        
        <h2>登録済みメニュー一覧</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-category">カテゴリ</th>
                        <th class="col-name">メニュー名</th>
                        <th class="col-kana">フリガナ</th>
                        <th class="col-price">価格</th>
                        <th class="col-allergy">アレルギー</th>
                        <th class="col-status">ステータス</th>
                        <th class="col-actions">アクション</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    java.util.List<model.Menu> menuList = (java.util.List<model.Menu>) request.getAttribute("menuList");
                    if (menuList != null && !menuList.isEmpty()) {
                        for (model.Menu m : menuList) {
                            
                            String badgeColor = "#708090";
                            String categoryStr = m.getCategory() != null ? m.getCategory() : "";
                            
                            if (categoryStr.equals("カメドリンク")) { badgeColor = "#6f4e37"; }
                            else if (categoryStr.equals("カメフード")) { badgeColor = "#d2b48c"; }
                            else if (categoryStr.equals("スイーツ")) { badgeColor = "#e6a8d7"; }
                            else if (categoryStr.equals("コーヒー豆・茶葉")) { badgeColor = "#4a3b32"; }
                            else if (categoryStr.equals("グッズ・道具")) { badgeColor = "#4682b4"; }
                %>
                <tr>
                    <td class="text-center"><span class="badge-id"><%= m.getId() %></span></td>
                    <td class="text-center">
                        <span class="badge-role" style="background-color: <%= badgeColor %>;">
                            <%= categoryStr %>
                        </span>
                    </td>
                    <td class="font-bold menu-name-cell">
                        <%= m.getMenuName() %>
                        <% if (m.isRecommend()) { %><span class="label-recommend">⭐おすすめ</span><% } %>
                        <% if (m.isLimited()) { %><span class="label-limited">📅限定</span><% } %>
                    </td>
                    <td class="menu-kana-cell"><%= m.getKanaName() %></td>
                    <td class="price-cell"><%= String.format("%,d円", m.getPrice()) %></td>
                    <td class="text-center allergy-cell"><%= m.getAllergyInfo() %></td>
                    <td class="text-center status-cell">
                        <%= m.isAvailable() ? "🟢 販売中" : "🔴 売り切れ" %>
                    </td>
                    <td class="text-center">
                        <a href="${pageContext.request.contextPath}/editMenu?id=<%= m.getId() %>" class="link-edit">詳細・編集</a>
                        <a href="${pageContext.request.contextPath}/deleteMenu?id=<%= m.getId() %>" 
                           onclick="return confirm('<%= m.getMenuName() %> を削除してもよろしいですか？');" class="link-delete">削除</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" class="text-muted" style="text-align: center; padding: 30px;">登録されているメニューはありません。</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
        
        <div class="footer-nav">
            <a href="${pageContext.request.contextPath}/admin/admin_main.jsp" class="btn-back">← 管理者メニューへ戻る</a>
        </div>
    </div>
</body>
</html>