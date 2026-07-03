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

@WebServlet("/registerMenu")
public class RegisterMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 1. 画面を普通に開いたとき (GET)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        MenuDAO dao = new MenuDAO();
        
        // 最新のメニュー一覧を取得してリクエストにセット
        List<Menu> menuList = dao.findAllMenus();
        request.setAttribute("menuList", menuList);
        
        // メニュー登録画面（AddMenu.jsp）を表示
        request.getRequestDispatcher("/admin/AddMenu.jsp").forward(request, response);
    }

    // 2. 登録ボタン（submit）が押されたとき (POST)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 日本語の文字化け対策
        request.setCharacterEncoding("UTF-8");
        
        // ① 画面（JSP）の入力項目からパラメータを取得
        String menuName = request.getParameter("menuName");
        String kanaName = request.getParameter("kanaName");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String allergyInfo = request.getParameter("allergyInfo");
        
        // チェックボックス（戻り値は "true" または null になる）
        boolean isRecommend = "true".equals(request.getParameter("isRecommend"));
        boolean isLimited = "true".equals(request.getParameter("isLimited"));
        
        // ② 安全対策：価格の数値を安全に変換
        int price = 0;
        try {
            if (priceStr != null && !priceStr.isEmpty()) {
                price = Integer.parseInt(priceStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        
        // ③ Modelオブジェクトにデータを詰め込む
        Menu menu = new Menu();
        menu.setMenuName(menuName);
        menu.setKanaName(kanaName);
        menu.setPrice(price);
        menu.setCategory(category);
        menu.setDescription(description);
        menu.setAllergyInfo(allergyInfo);
        menu.setRecommend(isRecommend);
        menu.setLimited(isLimited);
        
        // ④ DAOを使ってPostgreSQLに登録を実行
        MenuDAO dao = new MenuDAO();
        boolean isSuccess = dao.registerMenu(menu);
        
        // ⑤ 画面に出す結果メッセージをセット
        if (isSuccess) {
            request.setAttribute("message", "メニュー「" + menuName + "」を正常に登録しました！");
        } else {
            request.setAttribute("error", "メニューの登録に失敗しました。データベースのエラーを確認してください。");
        }
        
        // ⑥ 最新のメニュー一覧を取得し直してリクエストにセット
        List<Menu> menuList = dao.findAllMenus();
        request.setAttribute("menuList", menuList);
        
        // ⑦ 画面を再表示
        request.getRequestDispatcher("/admin/AddMenu.jsp").forward(request, response);
    }
}