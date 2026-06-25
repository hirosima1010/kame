package servlet;

import java.io.IOException;
import java.util.List;

import dao.MenuDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Menu;

@WebServlet("/menuList")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. DAOを使ってDBから全メニューを取得
        MenuDAO dao = new MenuDAO();
        List<Menu> menuList = dao.findAll();
        
        // 2. 取得したリストをリクエスト属性にセット
        request.setAttribute("menuList", menuList);
        
        // 3. JSPへフォワード（画面転送）
        RequestDispatcher dispatcher = request.getRequestDispatcher("/menuList.jsp");
        dispatcher.forward(request, response);
    }
}