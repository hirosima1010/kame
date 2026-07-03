package servlet;

import java.io.IOException;

import dao.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Menu;

@WebServlet("/editMenu")
public class EditMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            
            MenuDAO dao = new MenuDAO();
            Menu menu = dao.findMenuById(id);
            request.setAttribute("menu", menu);
        }
        
        request.getRequestDispatcher("/admin/EditMenu.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        int id = Integer.parseInt(request.getParameter("id"));
        String menuName = request.getParameter("menuName");
        String kanaName = request.getParameter("kanaName");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String allergyInfo = request.getParameter("allergyInfo");
        boolean isRecommend = "true".equals(request.getParameter("isRecommend"));
        boolean isLimited = "true".equals(request.getParameter("isLimited"));
        boolean isAvailable = "true".equals(request.getParameter("isAvailable")); // 👈 追加
        
        int price = 0;
        try { if (priceStr != null) price = Integer.parseInt(priceStr); } catch (NumberFormatException e) {}
        
        Menu menu = new Menu();
        menu.setId(id);
        menu.setMenuName(menuName);
        menu.setKanaName(kanaName);
        menu.setPrice(price);
        menu.setCategory(category);
        menu.setDescription(description);
        menu.setAllergyInfo(allergyInfo);
        menu.setRecommend(isRecommend);
        menu.setLimited(isLimited);
        menu.setAvailable(isAvailable); // 👈 追加
        
        MenuDAO dao = new MenuDAO();
        boolean isSuccess = dao.updateMenu(menu);
        
        if (isSuccess) {
            session.setAttribute("message", "メニュー「" + menuName + "」を正常に更新しました！");
        } else {
            session.setAttribute("error", "メニューの更新に失敗しました。");
        }
        
        response.sendRedirect(request.getContextPath() + "/registerMenu");
    }
}