package servlet;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

import dao.ShiftDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppUser;
import model.Shift;

@WebServlet("/addShift")
public class AddShiftServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GETリクエスト：登録画面を表示（スタッフ一覧をプルダウンに出すためにデータを取得）
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ① スタッフ一覧を取得（既存の処理）
        UserDAO userDao = new UserDAO();
        List<AppUser> userList = userDao.findAllUsers();
        request.setAttribute("userList", userList);
        
        // ② 💡 タイポを修正して安全にシフト一覧を取得
        ShiftDAO shiftDao = new ShiftDAO();
        List<Shift> shiftList = shiftDao.findAllShifts();
        
        // 💡 JSP側で「shiftList」と「myShiftList」のどちらで受け取っていても
        // 100%画面が正常に出るように両方の名前でセットしておく安全対策！
        request.setAttribute("shiftList", shiftList);
        request.setAttribute("myShiftList", shiftList);
        
        // adminの中のAddShift.jspへフォワード
        request.getRequestDispatcher("/admin/AddShift.jsp").forward(request, response);
    }

    // POSTリクエスト：画面からデータを受け取ってDBに保存
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. 画面から送られてきたパラメータを取得
        String username = request.getParameter("username");
        String workDateStr = request.getParameter("workDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String breakMinutesStr = request.getParameter("breakMinutes");
        
        // 2. 型変換（String から Date, Time, int へ）
        Date workDate = Date.valueOf(workDateStr); // yyyy-mm-dd を変換
        
        // HTMLの time型（hh:mm）を、Javaの SQL Time型（hh:mm:ss）に合わせる安全処理
        if (startTimeStr.length() == 5) startTimeStr += ":00";
        if (endTimeStr.length() == 5) endTimeStr += ":00";
        Time startTime = Time.valueOf(startTimeStr);
        Time endTime = Time.valueOf(endTimeStr);
        
        int breakMinutes = 0;
        try {
            breakMinutes = Integer.parseInt(breakMinutesStr);
        } catch (NumberFormatException e) {
            // 空欄や文字なら0分にする
        }
        
        // 3. Shiftオブジェクトを作成して値を詰める
        Shift shift = new Shift();
        shift.setUsername(username);
        shift.setWorkDate(workDate);
        shift.setStartTime(startTime);
        shift.setEndTime(endTime);
        shift.setBreakMinutes(breakMinutes);
        
        // 4. DAOを使ってデータベースに保存
        ShiftDAO shiftDao = new ShiftDAO();
        boolean isSuccess = shiftDao.insertShift(shift);
        
        if (isSuccess) {
            request.setAttribute("message", "シフトを正常に登録しました！");
        } else {
            request.setAttribute("error", "シフトの登録に失敗しました。");
        }
        
        // 5. 登録が終わったら、もう一度スタッフ一覧を読み直して画面を再表示する
        doGet(request, response);
    }
}