<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.AppUser" %>
<%@ page import="model.Shift" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>個人詳細・給与明細 | カフェシステムkame</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 明細書風の専用デザイン調整 */
        .pay-slip-container {
            background: #fff;
            border: 2px solid #333;
            padding: 30px;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .pay-slip-header {
            text-align: center;
            border-bottom: 2px double #333;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .pay-box {
            border: 1px solid #ccc;
            padding: 15px;
            border-radius: 6px;
            background: #fdfdfd;
        }
        .pay-box h3 {
            margin-top: 0;
            font-size: 14px;
            color: #555;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
        }
        .pay-value {
            font-size: 20px;
            font-weight: bold;
            text-align: right;
            margin-top: 10px;
            color: #2e7d32;
        }
        .total-pay-section {
            background: #e8f5e9;
            border: 2px solid #2e7d32;
            padding: 20px;
            border-radius: 6px;
            text-align: center;
            margin: 20px 0;
        }
        .total-pay-title {
            font-size: 16px;
            font-weight: bold;
            color: #1b5e20;
        }
        .total-pay-value {
            font-size: 32px;
            font-weight: bold;
            color: #2e7d32;
            margin-top: 5px;
        }
        .bank-info {
            background: #fafafa;
            border: 1px dashed #bbb;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>🐢 Staff Personal Profile 🐢</h1>
        
        <%
            // サーブレット（ShiftAuthServlet）から渡されたデータを取得
            AppUser user = (AppUser) request.getAttribute("targetUser");
            List<Shift> myShifts = (List<Shift>) request.getAttribute("myShifts");

            if (user == null) {
        %>
            <div class="error-msg">ユーザーデータの読み込みに失敗しました。</div>
            <div class="text-center" style="margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/shift" class="btn-back">シフト一覧へ戻る</a>
            </div>
        <%
                return;
            }

            // --- 💰 給与自動計算ロジック ---
            double totalHours = 0.0;
            int hourlyWage = user.getHourlyWage();
            int transFee = user.getTransportationFee();

            if (myShifts != null) {
                for (Shift s : myShifts) {
                    totalHours += s.getWorkingHours(); // 各シフトの実働時間を足していく
                }
            }

            // 基本給 = 時給 × 総実働時間
            int basePay = (int) Math.round(totalHours * hourlyWage);
            // 💡 1日でも出勤実績があれば交通費を支給するロジック（出勤日数×交通費にする場合は、シフトの件数を掛けてください）
            int totalTrans = (myShifts != null && !myShifts.isEmpty()) ? transFee : 0;
            // 総支給額
            int totalPay = basePay + totalTrans;
        %>

        <div class="pay-slip-container">
            <div class="pay-slip-header">
                <h2>給与明細・勤務実績一覧</h2>
                <p>スタッフID: <%= user.getUsername() %> &nbsp;|&nbsp; 氏名: <strong><%= user.getFullName() %></strong> 殿</p>
            </div>

            <div class="grid-3">
                <div class="pay-box">
                    <h3>基本情報</h3>
                    <p style="margin: 5px 0; font-size: 13px;">登録時給: <strong><%= hourlyWage %> 円</strong></p>
                    <p style="margin: 5px 0; font-size: 13px;">設定交通費: <strong><%= transFee %> 円</strong></p>
                </div>
                <div class="pay-box">
                    <h3>今月の勤務実績</h3>
                    <p style="margin: 5px 0; font-size: 13px;">総出勤日数: <strong><%= (myShifts != null) ? myShifts.size() : 0 %> 日</strong></p>
                    <div class="pay-value"><%= String.format("%.1f", totalHours) %> <span style="font-size:13px; color:#666;">H</span></div>
                </div>
                <div class="pay-box">
                    <h3>内訳（概算）</h3>
                    <p style="margin: 5px 0; font-size: 13px;">基本給与: <strong><%= String.format("%,d", basePay) %> 円</strong></p>
                    <p style="margin: 5px 0; font-size: 13px;">支給交通費: <strong><%= String.format("%,d", totalTrans) %> 円</strong></p>
                </div>
            </div>

            <div class="total-pay-section">
                <div class="total-pay-title">💵 差引概算総支給額</div>
                <div class="total-pay-value">￥ <%= String.format("%,d", totalPay) %> -</div>
            </div>

            <div class="bank-info">
                <strong>【給与振込先口座情報】</strong><br>
                銀行名: <%= (user.getBankName() != null && !user.getBankName().isEmpty()) ? user.getBankName() : "未登録" %> &nbsp;|&nbsp;
                支店名: <%= (user.getBankBranch() != null && !user.getBankBranch().isEmpty()) ? user.getBankBranch() : "未登録" %> &nbsp;|&nbsp;
                口座番号: <%= (user.getAccountNumber() != null && !user.getAccountNumber().isEmpty()) ? user.getAccountNumber() : "未登録" %>
            </div>
        </div>

        <h3 style="margin-top: 30px;">🗓️ 出勤実績詳細</h3>
        <table class="style-table" style="width: 100%; border-collapse: collapse; margin-top: 10px;">
            <thead>
                <tr style="background: #f4f4f4;">
                    <th style="padding: 10px; border: 1px solid #ddd;">出勤日</th>
                    <th style="padding: 10px; border: 1px solid #ddd;">勤務時間</th>
                    <th style="padding: 10px; border: 1px solid #ddd;">休憩</th>
                    <th style="padding: 10px; border: 1px solid #ddd;">実働時間</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (myShifts != null && !myShifts.isEmpty()) {
                        for (Shift s : myShifts) {
                %>
                <tr style="text-align: center;">
                    <td style="padding: 10px; border: 1px solid #ddd;"><%= s.getWorkDate() %></td>
                    <td style="padding: 10px; border: 1px solid #ddd;"><%= s.getStartTime() %> ～ <%= s.getEndTime() %></td>
                    <td style="padding: 10px; border: 1px solid #ddd;"><%= s.getBreakMinutes() %> 分</td>
                    <td style="padding: 10px; border: 1px solid #ddd; font-weight: bold; color: #0d47a1;"><%= String.format("%.1f", s.getWorkingHours()) %> 時間</td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" style="text-align: center; color: #999; padding: 20px;">出勤データがありません。</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div class="text-center" style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/shift" class="btn-back" style="text-decoration: none;">⬅ シフト一覧へ戻る</a>
        </div>
    </div>

</body>
</html>