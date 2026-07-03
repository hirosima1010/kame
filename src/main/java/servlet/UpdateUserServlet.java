package servlet;

import java.io.IOException;
import java.sql.Date;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppUser;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. 画面からパラメータを取得
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

        // 2. AppUserオブジェクトにセット
        AppUser user = new AppUser();
        user.setUsername(username); // WHERE句で使う大事なID
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

        // 安全な型変換（日付）
        if (birthDateStr != null && !birthDateStr.isEmpty()) {
            try { user.setBirthDate(Date.valueOf(birthDateStr)); } catch (IllegalArgumentException e) {}
        }
        // 安全な型変換（時給・交通費）
        try { user.setHourlyWage(Integer.parseInt(hourlyWageStr)); } catch (NumberFormatException e) { user.setHourlyWage(0); }
        try { user.setTransportationFee(Integer.parseInt(transportationFeeStr)); } catch (NumberFormatException e) { user.setTransportationFee(0); }

        // 3. DAOでデータベースをUPDATE
        UserDAO dao = new UserDAO();
        boolean isSuccess = dao.updateUser(user);
        
        if (isSuccess) {
            request.setAttribute("message", "情報を正常に更新しました！");
        } else {
            request.setAttribute("message", "更新に失敗しました。");
        }
        
        // 更新後の最新データをもう一度取得して、詳細画面に戻る
        AppUser updatedUser = dao.findByUsername(username);
        request.setAttribute("user", updatedUser);
        request.getRequestDispatcher("/admin/UserDetail.jsp").forward(request, response);
    }
}