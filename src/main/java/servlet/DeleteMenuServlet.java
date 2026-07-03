package servlet;

import java.io.IOException;

import dao.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteMenu")
public class DeleteMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 画面から送られてきた削除したいメニューのIDを取得
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            
            // DAOを使ってデータベースから削除
            MenuDAO dao = new MenuDAO();
            dao.deleteMenu(id);
        }
        
        // 削除が終わったら、元の登録＆一覧画面（/registerMenu）へ自動でリダイレクトして画面を更新
        response.sendRedirect(request.getContextPath() + "/registerMenu");
    }
}