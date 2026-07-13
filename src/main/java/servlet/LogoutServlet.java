package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ① 現在のセッションを取得
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // ② セッションを完全に無効化（ログイン情報やメッセージを消去）
            session.invalidate();
        }
        
        // ③ ログイン画面（login.jsp）へリダイレクト
        // ※環境に合わせてログイン画面のパス（"/login.jsp" など）に調整してください
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}