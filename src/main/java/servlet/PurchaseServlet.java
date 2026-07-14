package servlet;

import java.io.IOException;
import java.util.List;

import dao.PurchaseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AppUser;
import model.Purchase;

@WebServlet("/purchase")
public class PurchaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 表示処理（発注画面を開いたとき）
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションからログインユーザーを確認
        HttpSession session = request.getSession();
        AppUser loginUser = (AppUser) session.getAttribute("loginuser");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 過去の発注履歴を取得してリクエストにセット
        PurchaseDAO dao = new PurchaseDAO();
        List<Purchase> purchaseList = dao.findAllPurchases();
        request.setAttribute("purchaseList", purchaseList);

        // purchase.jsp へフォワード
        request.getRequestDispatcher("/purchase.jsp").forward(request, response);
    }

    // 登録処理（発注ボタンを押したとき）
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        AppUser loginUser = (AppUser) session.getAttribute("loginuser");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // フォームから入力値を取得
        request.setCharacterEncoding("UTF-8");
        String itemName = request.getParameter("itemName");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int price = Integer.parseInt(request.getParameter("price"));
        
        // 本名を取得
        String staffName = loginUser.getFullName(); 
        
        // 💡 修正ポイント：userIdが int型 である前提の安全チェックに変更
        if (staffName == null || staffName.trim().isEmpty()) {
            // userIdが0より大きければ（有効なIDがあれば）それを文字にして使う
            if (loginUser.getUserId() > 0) {
                staffName = "ID: " + loginUser.getUserId();
            } else {
                staffName = "ログインスタッフ"; 
            }
        }

        // モデルにセットしてDAOでDB登録
        Purchase p = new Purchase();
        p.setItemName(itemName);
        p.setQuantity(quantity);
        p.setPrice(price);
        p.setStaffName(staffName); // 安全対策済みの名前をセット

        PurchaseDAO dao = new PurchaseDAO();
        dao.insertPurchase(p);

        // 登録が終わったら再読み込み（二重送信防止のためリダイレクト）
        response.sendRedirect(request.getContextPath() + "/purchase");
    }
}