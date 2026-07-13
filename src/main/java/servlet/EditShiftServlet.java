package servlet;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

import dao.ShiftDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Shift;

@WebServlet("/editShift")
public class EditShiftServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ① GETリクエスト：編集ボタンが押されたとき、該当するシフトの情報を取得して編集画面へ渡す
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 画面から送られてきたシフトのIDを取得
        String shiftIdStr = request.getParameter("shiftId");
        if (shiftIdStr == null || shiftIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/addShift");
            return;
        }
        
        int id = Integer.parseInt(shiftIdStr);
        
        // DAOから全シフトを取得し、該当するIDのシフトを探す
        ShiftDAO shiftDao = new ShiftDAO();
        Shift targetShift = null;
        for (Shift s : shiftDao.findAllShifts()) {
            if (s.getId() == id) { // 💡 s.getId() に統一
                targetShift = s;
                break;
            }
        }
        
        // 見つかったら編集画面（EditShift.jsp）へ、見つからなければ登録画面に戻す
        if (targetShift != null) {
            request.setAttribute("shift", targetShift);
            request.getRequestDispatcher("/admin/EditShift.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/addShift");
        }
    }

    // ② POSTリクエスト：編集画面で「変更を保存する」が押されたとき、DBをUPDATEする
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 画面のフォームから送られてきた値を受け取る
        int id = Integer.parseInt(request.getParameter("id"));
        String workDateStr = request.getParameter("workDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        int breakMinutes = Integer.parseInt(request.getParameter("breakMinutes"));
        
        // 送信用にShiftオブジェクトにデータを詰める
        Shift shift = new Shift();
        shift.setId(id); // 💡 setId に統一
        shift.setWorkDate(Date.valueOf(workDateStr));
        
        // HTMLの time型（hh:mm）を Javaの SQL Time型（hh:mm:ss）に安全変換
        if (startTimeStr.length() == 5) startTimeStr += ":00";
        if (endTimeStr.length() == 5) endTimeStr += ":00";
        shift.setStartTime(Time.valueOf(startTimeStr));
        shift.setEndTime(Time.valueOf(endTimeStr));
        shift.setBreakMinutes(breakMinutes);
        
        // DAOを使ってDBを更新
        ShiftDAO shiftDao = new ShiftDAO();
        boolean isSuccess = shiftDao.updateShift(shift);
        
        // メッセージをセッションに詰めて、登録画面（/addShift）にリダイレクト
        if (isSuccess) {
            request.getSession().setAttribute("message", "シフトを更新しました。");
        } else {
            request.getSession().setAttribute("error", "シフトの更新に失敗しました。");
        }
        
        response.sendRedirect(request.getContextPath() + "/addShift");
    }
}