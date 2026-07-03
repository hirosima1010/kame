package servlet;

import java.io.IOException;
import java.util.List;

import dao.ShiftDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Shift;

@WebServlet("/shift")
public class ShiftServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // DAOを使ってデータベースから全員の最新シフト一覧を取得
        ShiftDAO dao = new ShiftDAO();
        List<Shift> shiftList = dao.findAllShifts();
        
        // リクエストスコープにデータをセットしてJSPへ転送
        request.setAttribute("shiftList", shiftList);
        request.getRequestDispatcher("/shift.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}