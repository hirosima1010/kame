package servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppUser;

@WebServlet("/registerUser")
public class RegisterUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GETリクエスト時：一覧データを読み込んで登録画面を表示する
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        UserDAO dao = new UserDAO();
        // 最新の一覧データを取得し直して、画面を再表示する
        List<AppUser> userList = dao.findAllUsers();
        List<AppUser> inactiveList = dao.findInactiveUsers();
        
        request.setAttribute("userList", userList);
        request.setAttribute("inactiveList", inactiveList);
        request.getRequestDispatcher("/admin/Addpeople.jsp").forward(request, response);
    }

    // POSTリクエスト時：画面からデータを受け取ってデータベースに登録する
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 文字化け対策
        request.setCharacterEncoding("UTF-8");
        
        // 1. 画面（JSP）からパラメータを取得
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        String fullName = request.getParameter("fullName");
        String kanaName = request.getParameter("kanaName");
        String gender = request.getParameter("gender");
        String birthDateStr = request.getParameter("birthDate");
        
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String postalCode = request.getParameter("postalCode");
        String address = request.getParameter("address");
        
        String hourlyWageStr = request.getParameter("hourlyWage");
        String transportationFeeStr = request.getParameter("transportationFee");
        String bankName = request.getParameter("bankName");
        String bankBranch = request.getParameter("bankBranch");
        String accountNumber = request.getParameter("accountNumber");

        // 2. データの型変換と安全対策
        AppUser user = new AppUser();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        user.setFullName(fullName);
        user.setKanaName(kanaName);
        user.setGender(gender);
        user.setPhone(phone);
        user.setEmail(email);
        user.setPostalCode(postalCode);
        user.setAddress(address);
        user.setBankName(bankName);
        user.setBankBranch(bankBranch);
        user.setAccountNumber(accountNumber);

        // 生年月日の変換（空欄の場合はNULLにする安全処理）
        if (birthDateStr != null && !birthDateStr.isEmpty()) {
            try {
                user.setBirthDate(Date.valueOf(birthDateStr)); // yyyy-mm-dd 形式を変換
            } catch (IllegalArgumentException e) {
                // 日付フォーマットが不正な場合はスルー
            }
        }

        // 時給の変換（空欄や文字だった場合は0にする安全処理）
        try {
            int hourlyWage = Integer.parseInt(hourlyWageStr);
            user.setHourlyWage(hourlyWage);
        } catch (NumberFormatException e) {
            user.setHourlyWage(0);
        }

        // 交通費の変換（同上）
        try {
            int transportationFee = Integer.parseInt(transportationFeeStr);
            user.setTransportationFee(transportationFee);
        } catch (NumberFormatException e) {
            user.setTransportationFee(0);
        }

        // 3. DAOを使ってデータベースに登録
        UserDAO dao = new UserDAO();
        boolean isSuccess = dao.registerUser(user);
        
        if (isSuccess) {
            request.setAttribute("message", "ユーザー「" + fullName + "」さんを正常に登録しました！");
        } else {
            request.setAttribute("error", "登録に失敗しました。ユーザーIDが既に使われている可能性があります。");
        }
        
        // 4. 最新の一覧データを取得し直して、画面を再表示する
        List<AppUser> userList = dao.findAllUsers();
        request.setAttribute("userList", userList);
        
        // 🔥【ここにも追加】新規追加した時も退職者一覧が消えないように取得してセットする！
        List<AppUser> inactiveList = dao.findInactiveUsers();
        request.setAttribute("inactiveList", inactiveList);
        
        request.getRequestDispatcher("/admin/Addpeople.jsp").forward(request, response);
    }
}