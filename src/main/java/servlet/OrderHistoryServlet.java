package servlet;

import java.io.IOException;
import java.util.List;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

// 💡 管理メイン画面などから「/orderHistory」でリンクを貼れるようにする
@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. OrderDAO を使ってデータベースからすべての注文履歴を引っ張ってくる
        OrderDAO dao = new OrderDAO();
        List<Order> orderList = dao.findAllOrders();
        
        // 2. 画面（orderHistory.jsp）に渡すためにリクエストにセット
        request.setAttribute("orderList", orderList);
        
        // 3. 注文履歴画面（JSP）へフォワードして表示！
        request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}