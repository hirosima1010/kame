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

// 💡 スタッフメイン画面のリンク先（/menuList）と完全に一致させる！
@WebServlet("/menuList")
public class MenuListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ① あなたが作った MenuDAO を使ってデータベースから最新メニューを取得
        MenuDAO dao = new MenuDAO();
        List<Menu> menuList = dao.findAllMenus(); // RegisterMenuServletと同じメソッドを使用[cite: 10]
        
        // ② 注文画面（order.jsp）が必要としている "menuList" という名前でデータをセット
        request.setAttribute("menuList", menuList);
        
        // ③ カメの仕掛けが詰まった注文入力画面（order.jsp）へフォワードして表示！
        // ※ もし order.jsp が「/staff/order.jsp」などフォルダ内にある場合はパスを変更してください
        request.getRequestDispatcher("/order.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}