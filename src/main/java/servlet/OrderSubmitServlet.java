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

        // 3. order.jsp から送られてきたパラメーターを取得
        String eatStyle = request.getParameter("eatStyle");
        String myKameShellStr = request.getParameter("myKameShell");
        boolean myKameShell = "true".equals(myKameShellStr);
        String needReceipt = request.getParameter("needReceipt");
        String finalReceiptName = request.getParameter("finalReceiptName");
        String ageGroup = request.getParameter("ageGroup");
        if (ageGroup == null || ageGroup.trim().isEmpty()) {
            ageGroup = "unknown";
        }

        // 4. 最新のメニューリストをDBから取得
        MenuDAO menuDao = new MenuDAO();
        List<Menu> menuList = menuDao.findAllMenus();
        
        List<OrderDetail> detailsList = new ArrayList<>();
        List<String[]> orderedDisplayList = new ArrayList<>(); // JSP表示用
        int subTotal = 0;

        // 💡 修正ポイント：メニューID (m.getId()) を使って画面から直接数量を確実・安全に回収カメ！
        if (menuList != null) {
            for (Menu m : menuList) {
                // JSP側で設定した「quantity_メニューID」の名前で正確に取得
                String qtyParam = request.getParameter("quantity_" + m.getId());
                
                if (qtyParam != null && !qtyParam.trim().isEmpty() && !qtyParam.equals("0")) {
                    try {
                        int qty = Integer.parseInt(qtyParam.trim());
                        
                        if (qty > 0) {
                            OrderDetail detail = new OrderDetail();
                            detail.setMenuName(m.getMenuName());
                            detail.setPrice(m.getPrice());
                            detail.setQuantity(qty);
                            detailsList.add(detail);
                            
                            int totalItemPrice = m.getPrice() * qty;
                            subTotal += totalItemPrice;
                            
                            orderedDisplayList.add(new String[]{
                                m.getMenuName(), 
                                String.valueOf(m.getPrice()), 
                                String.valueOf(qty), 
                                String.valueOf(totalItemPrice)
                            });
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("⚠️ 不正な数量を無視したカメ: " + qtyParam);
                    }
                }
            }
        }

        // 💡 隠しコマンド（禁断の裏メニュー：ID 999）の数量回収も個別でしっかり救済カメ！
        String secretQtyParam = request.getParameter("quantity_999");
        if (secretQtyParam != null && !secretQtyParam.trim().isEmpty() && !secretQtyParam.equals("0")) {
            try {
                int qty = Integer.parseInt(secretQtyParam.trim());
                if (qty > 0) {
                    OrderDetail detail = new OrderDetail();
                    detail.setMenuName("幻の竜宮城特製パフェ（玉手箱付き）");
                    detail.setPrice(99999);
                    detail.setQuantity(qty);
                    detailsList.add(detail);
                    
                    int totalItemPrice = 99999 * qty;
                    subTotal += totalItemPrice;
                    
                    orderedDisplayList.add(new String[]{
                        "幻の竜宮城特製パフェ（玉手箱付き）", 
                        "99999", 
                        String.valueOf(qty), 
                        String.valueOf(totalItemPrice)
                    });
                }
            } catch (NumberFormatException e) {
                // スルー
            }
        }

        // ⚠️ 鉄壁ガード（これで「正しい注文」があれば確実にここを突破できるカメ！）
        if (detailsList.isEmpty()) {
            System.out.println("⚠️ 注文明細が空のため、処理を安全に中断して注文画面へ戻したカメ。");
            response.sendRedirect("order");
            return;
        }

        // 割引と最終合計金額の計算
        int discount = (myKameShell && subTotal > 0) ? 200 : 0;
        int finalTotal = Math.max(0, subTotal - discount);

        // 5. データベース保存用の「Orderオブジェクト」を組み立てる
        Order order = new Order();
        order.setStaffName(staffName);
        order.setEatStyle(eatStyle != null ? eatStyle : "land");
        order.setMyKameShell(myKameShell);
        order.setTotalPrice(finalTotal);
        order.setReceiptName(finalReceiptName);
        order.setDetails(detailsList);
        order.setAgeGroup(ageGroup);

        // 6. OrderDAOを使って、PostgreSQLに注文履歴を保存
        OrderDAO orderDao = new OrderDAO();
        boolean isSaved = orderDao.insertOrder(order);
        
        if (!isSaved) {
            System.out.println("⚠️ 注文履歴のデータベース保存に失敗しましたカメ…");
        }

        // 7. 確定データをセッションに詰め込んでリダイレクト
        session.setAttribute("complete_eatStyle", eatStyle);
        session.setAttribute("complete_myKameShell", myKameShellStr);
        session.setAttribute("complete_needReceipt", needReceipt);
        session.setAttribute("complete_finalReceiptName", finalReceiptName);
        session.setAttribute("complete_staffName", staffName);
        session.setAttribute("complete_orderedList", orderedDisplayList);
        session.setAttribute("complete_subTotal", String.valueOf(subTotal));     
        session.setAttribute("complete_discount", String.valueOf(discount));     
        session.setAttribute("complete_finalTotal", String.valueOf(finalTotal)); 

        // リダイレクトで確定画面へ
        response.sendRedirect("kakuteigamen.jsp");
    }
}