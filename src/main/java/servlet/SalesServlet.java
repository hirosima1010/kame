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

@WebServlet("/sales")
public class SalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        OrderDAO dao = new OrderDAO();
        
        // ① 全期間の注文（全体の集計用）
        List<Order> allOrders = dao.findAllOrders();
        request.setAttribute("allOrders", allOrders);
        
        // ② 期間別ランキング（日・月・年）
        request.setAttribute("rankDay", dao.findMenuRankingByPeriod("DAY"));
        request.setAttribute("rankMonth", dao.findMenuRankingByPeriod("MONTH"));
        request.setAttribute("rankYear", dao.findMenuRankingByPeriod("YEAR"));
        
        // ③ 年齢層別の人気トップ3
        request.setAttribute("rankKids", dao.findMenuRankingByAge("kids"));
        request.setAttribute("rankYouth", dao.findMenuRankingByAge("youth"));
        request.setAttribute("rankAdult", dao.findMenuRankingByAge("adult"));
        request.setAttribute("rankSenior", dao.findMenuRankingByAge("senior"));
        
        // ④ 年齢層別の売上サマリー
        request.setAttribute("ageSalesSummary", dao.findSalesSummaryByAge());
        
        // スタイル比率（既存）
        int[] styleCounts = dao.findTodayStyleCount();
        request.setAttribute("seaCount", styleCounts[0]);
        request.setAttribute("landCount", styleCounts[1]);
        
        request.getRequestDispatcher("/sales.jsp").forward(request, response);
    }
}