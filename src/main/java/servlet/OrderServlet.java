package servlet;

import java.io.IOException;
import java.util.List;

import dao.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Menu;

@WebServlet("/order") // 👈 ブラウザで localhost:8080/kame/order で開けるようにする
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ① あなたが作ったMenuDAOを使って、PostgreSQLから最新のメニュー全件（26件）を取得
        MenuDAO dao = new MenuDAO();
        List<Menu> menuList = dao.findAllMenus();
        
        // ② 取得したリストを「menuList」という名前でリクエストに詰め込む
        request.setAttribute("menuList", menuList);
        
        // ③ お友達が作った注文画面（order.jsp）を表示する
        request.getRequestDispatcher("/order.jsp").forward(request, response);
    }
}