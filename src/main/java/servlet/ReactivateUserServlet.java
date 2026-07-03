package servlet;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reactivateUser")
public class ReactivateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        
        if (username != null && !username.isEmpty()) {
            UserDAO dao = new UserDAO();
            boolean isSuccess = dao.reactivateUser(username);
            
            if (isSuccess) {
                request.setAttribute("message", "ユーザー「" + username + "」さんを現職に復元しました！");
            } else {
                request.setAttribute("error", "復元処理に失敗しました。");
            }
        }
        
        // 登録画面サーブレット（一覧の再読み込み処理があるところ）に丸投げして画面を戻す
        request.getRequestDispatcher("/registerUser").forward(request, response);
    }
}