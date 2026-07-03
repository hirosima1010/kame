<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.AppUser" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>スタッフ詳細・編集</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="container">
        <%
            AppUser user = (AppUser) request.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/registerUser");
                return;
            }
        %>

        <h1>Staff Detail & Edit</h1>
        
        <% if (request.getAttribute("message") != null && !((String)request.getAttribute("message")).isEmpty()) { %>
            <div class="status-msg">${message}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/updateUser" method="post">
            
            <div class="form-section">
                <h3>Account Setting</h3>
                <div class="form-group">
                    <label>ユーザーID</label>
                    <input type="text" name="username" value="<%= user.getUsername() %>" class="readonly-field" readonly>
                </div>
                <div class="form-group">
                    <label>パスワード</label>
                    <input type="password" name="password" value="<%= user.getPassword() %>" required>
                </div>
                <div class="form-group">
                    <label>権限（役割）</label>
                    <select name="role">
                        <option value="staff" <%= user.getRole().equals("staff") ? "selected" : "" %>>一般スタッフ (staff)</option>
                        <option value="admin" <%= user.getRole().equals("admin") ? "selected" : "" %>>管理者 (admin)</option>
                    </select>
                </div>
            </div>
            
            <div class="form-section">
                <h3>Personal Information</h3>
                <div class="form-group">
                    <label>氏名（本名）</label>
                    <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
                </div>
                <div class="form-group">
                    <label>フリガナ</label>
                    <input type="text" name="kanaName" value="<%= user.getKanaName() != null ? user.getKanaName() : "" %>">
                </div>
                <div class="form-group">
                    <label>性別</label>
                    <select name="gender">
                        <option value="">選択してください</option>
                        <option value="男" <%= "男".equals(user.getGender()) ? "selected" : "" %>>男</option>
                        <option value="女" <%= "女".equals(user.getGender()) ? "selected" : "" %>>女</option>
                        <option value="その他" <%= "other".equals(user.getGender()) ? "selected" : "" %>>その他</option>
                    </select>
                </div>
               <div class="form-group">
    				<label>生年月日</label>
    				<input type="date" name="birthDate" value="<%= user.getBirthDate() != null ? user.getBirthDate() : "" %>">
    				<% 
        				if (user.getBirthDate() != null) {
            				java.time.LocalDate birth = user.getBirthDate().toLocalDate();
            				java.time.LocalDate now = java.time.LocalDate.now();
            				long age = java.time.temporal.ChronoUnit.YEARS.between(birth, now);
    				%>
        				<span class="info-text" style="margin-left: 15px; font-size: 13px; color: #8c7667;">(現在: <%= age %>歳)</span>
    				<% 
        				} 
    				%>
				</div>
            </div>
            
            <div class="form-section">
                <h3>Contact & Address</h3>
                <div class="form-group">
                    <label>電話番号</label>
                    <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                </div>
                <div class="form-group">
                    <label>メールアドレス</label>
                    <input type="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>">
                </div>
                <div class="form-group">
                    <label>郵便番号</label>
                    <input type="text" name="postalCode" value="<%= user.getPostalCode() != null ? user.getPostalCode() : "" %>">
                </div>
                <div class="form-group">
                    <label>住所</label>
                    <input type="text" name="address" class="w-full" value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                </div>
            </div>
            
            <div class="form-section">
                <h3>Salary & Bank Account</h3>
                <div class="form-group">
                    <label>時給 (円)</label>
                    <input type="text" name="hourlyWage" value="<%= user.getHourlyWage() %>">
                </div>
                <div class="form-group">
                    <label>交通費 (円)</label>
                    <input type="text" name="transportationFee" value="<%= user.getTransportationFee() %>">
                </div>
                <div class="form-group">
                    <label>銀行名</label>
                    <input type="text" name="bankName" value="<%= user.getBankName() != null ? user.getBankName() : "" %>">
                </div>
                <div class="form-group">
                    <label>支店名</label>
                    <input type="text" name="bankBranch" value="<%= user.getBankBranch() != null ? user.getBankBranch() : "" %>">
                </div>
                <div class="form-group">
                    <label>口座番号</label>
                    <input type="text" name="accountNumber" value="<%= user.getAccountNumber() != null ? user.getAccountNumber() : "" %>">
                </div>
            </div>
            
            <div class="form-section">
                <h3>Management</h3>
                <div class="form-group">
                    <label>入社日</label>
                    <span class="info-text"><%= user.getHireDate() %></span>
                </div>
            </div>

            <div class="btn-container">
                <button type="submit" class="btn-submit">この内容に更新する</button>
                <a href="${pageContext.request.contextPath}/registerUser" class="btn-back-link">一覧へ戻る</a>
            </div>
        </form>
    </div>

</body>
</html>