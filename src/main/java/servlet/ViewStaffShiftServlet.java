package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.ShiftDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Shift;

@WebServlet("/viewStaffShifts")
public class ViewStaffShiftServlet extends HttpServlet { 
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException { 
        
        // 1. 本来のDAOから全シフトを取得
        ShiftDAO shiftDao = new ShiftDAO();
        List<Shift> allShifts = shiftDao.findAllShifts(); 
        
        // 2. 過去のデータを弾くためのリスト
        List<Shift> futureShifts = new ArrayList<>();
        
        // 💡 一番安全な「今日の午前0時0分0秒」のタイムスタンプを作成
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        long todayMillis = cal.getTimeInMillis(); // 今日の始まりのミリ秒
        
        if (allShifts != null) { 
            for (Shift s : allShifts) { 
                if (s.getWorkDate() != null) { 
                    // 💡 s.getWorkDate() が util.Date でも sql.Date でも絶対に動く比較方法！
                    long shiftMillis = s.getWorkDate().getTime();
                    
                    // シフトの時間が今日の0時0分以降（＝今日を含む未来）ならリストに入れる
                    if (shiftMillis >= todayMillis) { 
                        futureShifts.add(s);
                    } 
                } 
            } 
        } 
        
        // 3. JSPへデータを渡す（requestのスペルを確実に統一！）
        request.setAttribute("shiftList", futureShifts);
        request.setAttribute("myShiftList", futureShifts);
        
        // 4. JSPへフォワード
        request.getRequestDispatcher("/ViewStaffShifts.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}