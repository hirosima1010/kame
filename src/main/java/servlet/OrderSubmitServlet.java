package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.MenuDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AppUser;
import model.Menu;
import model.Order;
import model.OrderDetail;

@WebServlet("/orderSubmit")
public class OrderSubmitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 文字化け対策
        request.setCharacterEncoding("UTF-8");

        // 2. セッションからログインしているスタッフの情報を取得
        HttpSession session = request.getSession();
        String staffName = "ゲストスタッフ";
        AppUser loginUser = (AppUser) session.getAttribute("loginuser");
        if (loginUser != null) {
            staffName = loginUser.getFullName();
            if (staffName == null || staffName.isEmpty()) {
                staffName = loginUser.getUsername();
            }
        }

        // 3. order.jsp から送られてきたパラメーターを確実にキャッチ
        String eatStyle = request.getParameter("eatStyle");
        String myKameShellStr = request.getParameter("myKameShell");
        boolean myKameShell = "true".equals(myKameShellStr);
        String needReceipt = request.getParameter("needReceipt");
        String finalReceiptName = request.getParameter("finalReceiptName");
        
        // 💡 追加した年齢層（ageGroup）をここで確実に取得！
        String ageGroup = request.getParameter("ageGroup");
        if (ageGroup == null || ageGroup.trim().isEmpty()) {
            ageGroup = "unknown";
        }

        // 4. 最新のメニューリストをDBから取得して、注文された数量から金額を計算する
        MenuDAO menuDao = new MenuDAO();
        List<Menu> menuList = menuDao.findAllMenus();
        
        List<OrderDetail> detailsList = new ArrayList<>();
        int subTotal = 0;

        // 💡 ここが超重要！order.jspのループインデックス（globalItemIndex）と完全に一致させる
        if (menuList != null) {
            int globalItemIndex = 1;
            for (Menu m : menuList) {
                // quantity_1, quantity_2 ... という名前で画面から送られてくる数量を取得
                String qtyParam = request.getParameter("quantity_" + globalItemIndex);
                
                if (qtyParam != null && !qtyParam.trim().isEmpty() && !qtyParam.equals("0")) {
                    try {
                        int qty = Integer.parseInt(qtyParam.trim());
                        
                        if (qty > 0) {
                            // 明細オブジェクト（OrderDetail）を作ってリストに詰める
                            OrderDetail detail = new OrderDetail();
                            detail.setMenuName(m.getMenuName());
                            detail.setPrice(m.getPrice());
                            detail.setQuantity(qty);
                            detailsList.add(detail);
                            
                            // 小計をどんどん足していく
                            subTotal += m.getPrice() * qty;
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("⚠️ 数量の数値変換に失敗したカメ: " + qtyParam);
                    }
                }
                globalItemIndex++;
            }
        }

        // 割引と最終合計金額の計算（マイ甲羅があれば200円引き）
        int discount = (myKameShell && subTotal > 0) ? 200 : 0;
        int finalTotal = Math.max(0, subTotal - discount);

        // 5. データベース保存用の「Orderオブジェクト」を組み立てる
        Order order = new Order();
        order.setStaffName(staffName);
        order.setEatStyle(eatStyle != null ? eatStyle : "land");
        order.setMyKameShell(myKameShell);
        order.setTotalPrice(finalTotal);       // 💡 計算された最終合計金額をセット！
        order.setReceiptName(finalReceiptName);
        order.setDetails(detailsList);
        order.setAgeGroup(ageGroup);           // 💡 年齢層をセット！

        // 6. OrderDAOを使って、PostgreSQLに注文履歴を保存！
        OrderDAO orderDao = new OrderDAO();
        boolean isSaved = orderDao.insertOrder(order);
        
        if (!isSaved) {
            System.out.println("⚠️ 注文履歴のデータベース保存に失敗しましたカメ…");
        }

        // 7. 確定画面（kakuteigamen.jsp）へ渡すリクエストスコープにデータを詰め直す
        request.setAttribute("eatStyle", eatStyle);
        request.setAttribute("myKameShell", myKameShellStr);
        request.setAttribute("needReceipt", needReceipt);
        request.setAttribute("finalReceiptName", finalReceiptName);
        request.setAttribute("menuList", menuList);      // メニュー一覧
        request.setAttribute("staffName", staffName);    // 担当スタッフ名
        request.setAttribute("ageGroup", ageGroup);      // 年齢層

        // 確定画面「kakuteigamen.jsp」へフォワード！
        request.getRequestDispatcher("kakuteigamen.jsp").forward(request, response);
    }
}