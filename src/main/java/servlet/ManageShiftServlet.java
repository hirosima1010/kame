package servlet;

import java.io.IOException;

import dao.ShiftDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/manageShifts")
public class ManageShiftServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // もしGETでここに来たら、合体登録画面（/addShift）に強制移動
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/addShift");
    }

    // 🗑️ 削除ボタンが押されたときの処理
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String shiftIdStr = request.getParameter("shiftId");
        
        if (shiftIdStr != null && !shiftIdStr.isEmpty()) {
            int id = Integer.parseInt(shiftIdStr);
            
            ShiftDAO shiftDao = new ShiftDAO();
            boolean isSuccess = shiftDao.deleteShift(id); // id指定で削除
            
            // 画面を跨ぐのでセッションにメッセージを一時保存
            if (isSuccess) {
                request.getSession().setAttribute("message", "シフトを削除しました。");
            } else {
                request.getSession().setAttribute("error", "シフトの削除に失敗しました。");
            }
        }
        
        // 🔥 削除が終わったら、合体画面（/addShift）へリダイレクトして一覧を更新！
        response.sendRedirect(request.getContextPath() + "/addShift");
    }
}