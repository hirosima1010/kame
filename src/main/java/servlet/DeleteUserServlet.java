package servlet;

import java.io.IOException;
import java.util.List;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppUser;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // リンクの後ろについてる ?username=xxx を取得
        String username = request.getParameter("username");
        
        UserDAO dao = new UserDAO();
        
        if (username != null && !username.isEmpty()) {
            // 退職処理を実行
            boolean isSuccess = dao.deleteUser(username);
            
            if (isSuccess) {
                request.setAttribute("message", "ユーザー「" + username + "」さんを一覧から削除（退職処理）しました。");
            } else {
                request.setAttribute("error", "削除処理に失敗しました。");
            }
        }
        
        // 最新の「在籍スタッフのみ」の一覧を取得し直す
        List<AppUser> userList = dao.findAllUsers();
        request.setAttribute("userList", userList);
        
        // 🔥【超重要】退職済み一覧も取得し直してセットする！
        List<AppUser> inactiveList = dao.findInactiveUsers();
        request.setAttribute("inactiveList", inactiveList);
        
        // 一覧画面（Addpeople.jsp）へ戻る
        request.getRequestDispatcher("/admin/Addpeople.jsp").forward(request, response);
    }
}