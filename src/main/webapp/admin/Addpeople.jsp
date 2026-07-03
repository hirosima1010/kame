<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>スタッフ・管理者詳細登録</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="container">
        <h1>Cafe Staff Management</h1>
        
        <% if (request.getAttribute("message") != null && !((String)request.getAttribute("message")).isEmpty()) { %>
            <div class="status-msg">${message}</div>
        <% } %>

        <% if (request.getAttribute("error") != null && !((String)request.getAttribute("error")).isEmpty()) { %>
            <div class="error-msg">${error}</div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/registerUser" method="post">
            
            <div class="form-section">
                <h3>Account Setting <span class="required">必須</span></h3>
                <div class="form-group">
                    <label>ユーザーID</label>
                    <input type="text" name="username" required placeholder="ログイン用IDを入力">
                </div>
                <div class="form-group">
                    <label>パスワード</label>
                    <input type="password" name="password" required placeholder="パスワードを入力">
                </div>
                <div class="form-group">
                    <label>権限（役割）</label>
                    <select name="role">
                        <option value="staff">一般スタッフ (staff)</option>
                        <option value="admin">管理者 (admin)</option>
                    </select>
                </div>
            </div>
            
            <div class="form-section">
                <h3>Personal Information</h3>
                <div class="form-group">
                    <label>氏名（本名）</label>
                    <input type="text" name="fullName" required placeholder="山田 太郎">
                </div>
                <div class="form-group">
                    <label>フリガナ</label>
                    <input type="text" name="kanaName" placeholder="ヤマダ タロウ">
                </div>
                <div class="form-group">
                    <label>性別</label>
                    <select name="gender">
                        <option value="">選択してください</option>
                        <option value="男">男</option>
                        <option value="女">女</option>
                        <option value="その他">その他</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>生年月日</label>
                    <input type="date" name="birthDate">
                </div>
            </div>
            
            <div class="form-section">
                <h3>Contact & Address</h3>
                <div class="form-group">
                    <label>電話番号</label>
                    <input type="text" name="phone" placeholder="090-0000-0000">
                </div>
                <div class="form-group">
                    <label>メールアドレス</label>
                    <input type="email" name="email" placeholder="example@email.com">
                </div>
                <div class="form-group">
                    <label>郵便番号</label>
                    <input type="text" name="postalCode" placeholder="123-4567">
                </div>
                <div class="form-group">
                    <label>住所</label>
                    <input type="text" name="address" class="w-full" placeholder="東京都〇〇区...">
                </div>
            </div>
            
            <div class="form-section">
                <h3>Salary & Bank Account</h3>
                <div class="form-group">
                    <label>時給 (円)</label>
                    <input type="text" name="hourlyWage" value="0">
                </div>
                <div class="form-group">
                    <label>交通費 (円)</label>
                    <input type="text" name="transportationFee" value="0">
                </div>
                <div class="form-group">
                    <label>銀行名</label>
                    <input type="text" name="bankName" placeholder="〇〇銀行">
                </div>
                <div class="form-group">
                    <label>支店名</label>
                    <input type="text" name="bankBranch" placeholder="〇〇支店">
                </div>
                <div class="form-group">
                    <label>口座番号</label>
                    <input type="text" name="accountNumber" placeholder="1234567">
                </div>
            </div>

            <div class="text-center">
                <button type="submit" class="btn-submit">作成する</button>
            </div>
        </form>
        
        <hr>
        
        <h2>現在の登録ユーザー（スタッフ）一覧</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>氏名 (本名)</th>
                        <th>権限</th>
                        <th>時給</th>
                        <th>電話番号</th>
                        <th>入社日</th>
                        <th>アクション</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    java.util.List<model.AppUser> list = (java.util.List<model.AppUser>) request.getAttribute("userList");
                    if (list != null && !list.isEmpty()) {
                        for (model.AppUser u : list) {
                %>
                <tr>
                    <td><span class="badge-id"><%= u.getUsername() %></span></td>
                    <td class="font-bold">
                        <%= u.getFullName() %>
                        <% 
                            if (u.getBirthDate() != null) {
                                java.time.LocalDate birth = u.getBirthDate().toLocalDate();
                                java.time.LocalDate now = java.time.LocalDate.now();
                                long age = java.time.temporal.ChronoUnit.YEARS.between(birth, now);
                        %>
                            <span style="font-size: 12px; color: #8c7667; font-weight: normal; margin-left: 5px;">(<%= age %>歳)</span>
                        <% 
                            } 
                        %>
                    </td>
                    <td><%= u.getRole().equals("admin") ? "管理者" : "スタッフ" %></td>
                    <td class="price"><%= String.format("%,d円", u.getHourlyWage()) %></td>
                    <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
                    <td><%= u.getHireDate() %></td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/userDetail?username=<%= u.getUsername() %>" class="link-edit">詳細・編集</a>
                        <a href="${pageContext.request.contextPath}/deleteUser?username=<%= u.getUsername() %>" 
                           onclick="return confirm('<%= u.getFullName() %> さんを削除（退職処理）してもよろしいですか？');" class="link-delete">削除</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="text-muted">登録されているスタッフはいません。</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
        
        <hr>
        
        <h2>過去の登録ユーザー（退職済み）一覧</h2>
        <div class="table-container">
            <table class="inactive-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>氏名 (本名)</th>
                        <th>権限</th>
                        <th>アクション</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    java.util.List<model.AppUser> inactiveList = (java.util.List<model.AppUser>) request.getAttribute("inactiveList");
                    if (inactiveList != null && !inactiveList.isEmpty()) {
                        // 👈 変数名を u から inactiveUser に完全に変更して衝突を回避！
                        for (model.AppUser inactiveUser : inactiveList) {
                %>
                <tr>
                    <td><span class="badge-id"><%= inactiveUser.getUsername() %></span></td>
                    <td class="font-bold">
                        <%= inactiveUser.getFullName() %>
                        <% 
                            if (inactiveUser.getBirthDate() != null) {
                                java.time.LocalDate birth = inactiveUser.getBirthDate().toLocalDate();
                                java.time.LocalDate now = java.time.LocalDate.now();
                                long age = java.time.temporal.ChronoUnit.YEARS.between(birth, now);
                        %>
                            <span style="font-size: 12px; color: #8c7667; font-weight: normal; margin-left: 5px;">(<%= age %>歳)</span>
                        <% 
                            } 
                        %>
                    </td>
                    <td><%= inactiveUser.getRole().equals("admin") ? "管理者" : "スタッフ" %></td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/reactivateUser?username=<%= inactiveUser.getUsername() %>" 
                           onclick="return confirm('<%= inactiveUser.getFullName() %> さんを現職に復元しますか？');" class="link-restore">現職に復元する</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" class="text-muted">退職処理されたスタッフはいません。</td>
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