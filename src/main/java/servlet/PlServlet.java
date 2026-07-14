package servlet;

import java.io.IOException;
import java.util.List;

import dao.OrderDAO;
import dao.PurchaseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.Purchase;

@WebServlet("/pl")
public class PlServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        OrderDAO orderDao = new OrderDAO();
        PurchaseDAO purchaseDao = new PurchaseDAO();
        
        // ① PostgreSQLからこれまでの「総売上」をリアルタイム計算
        List<Order> allOrders = orderDao.findAllOrders();
        int totalSales = 0;
        if (allOrders != null) {
            for (Order o : allOrders) {
                totalSales += o.getTotalPrice();
            }
        }
        
        // ② PostgreSQLからこれまでの「実際の発注総額（エサ代）」をリアルタイム計算
        List<Purchase> allPurchases = purchaseDao.findAllPurchases();
        int costOfGoods = 0;
        if (allPurchases != null) {
            for (Purchase p : allPurchases) {
                costOfGoods += (p.getPrice() * p.getQuantity());
            }
        }
        
        // ③ 固定経費（働きガメへの給与や巣の維持費）
        int laborCost = 45000;                     // 働きガメへの給与
        int expenses = 20000;                      // 巣の維持費（家賃・光熱費）

        // ④ JSP（甲羅勘定ページ）へデータをセット
        request.setAttribute("sales", totalSales);
        request.setAttribute("costOfGoods", costOfGoods);
        request.setAttribute("laborCost", laborCost);
        request.setAttribute("expenses", expenses);
        
        // 💡 ファイル名は「pl.jsp」として呼び出します
        request.getRequestDispatcher("/pl.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}