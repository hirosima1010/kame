package servlet;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppUser;

@WebServlet("/userDetail")
public class UserDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // リンクの後ろについてる ?username=xxx を取得
        String username = request.getParameter("username");
        
        if (username != null && !username.isEmpty()) {
            UserDAO dao = new UserDAO();
            // データベースからその人の全データを1人分だけ取得
            AppUser user = dao.findByUsername(username);
            
            // データをJSPに引き渡す
            request.setAttribute("user", user);
        }
        
        // 詳細・編集画面へジャンプ
        request.getRequestDispatcher("/admin/UserDetail.jsp").forward(request, response);
    }
}