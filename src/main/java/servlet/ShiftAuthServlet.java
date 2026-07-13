package servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import dao.ShiftDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AppUser;
import model.Shift;

@WebServlet("/shiftAuth")
public class ShiftAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 画面から「見たい対象のユーザーID（1や2、adminなど）」と「入力されたパスワード」を受け取る
        String targetUsername = request.getParameter("targetUsername");
        String inputPassword = request.getParameter("password");
        
        // セッションから現在本当にログインしている人の情報を取得する
        HttpSession session = request.getSession();
        // 💡 修正：LoginServletの記述に合わせて「"loginuser"（すべて小文字）」で取り出す！
        AppUser loginUser = (AppUser) session.getAttribute("loginuser"); 

        // 🔒 セキュリティチェック：ログイン者が別人（カメイが田中を見ようとした）場合
        // ※ただし、ログイン者が管理者（admin）の場合はスタッフの明細を見られるように role のチェックも考慮
        if (loginUser == null || 
           (!loginUser.getUsername().equals(targetUsername) && !"admin".equals(loginUser.getRole()))) {
            
            request.setAttribute("error", "他人の詳細情報を閲覧することはできません。");
            
            // シフト画面に戻すために「今日以降のシフト」を再取得してセット
            ShiftDAO shiftDao = new ShiftDAO();
            List<Shift> allShifts = shiftDao.findAllShifts();
            List<Shift> futureShifts = new ArrayList<>();
            LocalDate today = LocalDate.now();
            
            if (allShifts != null) {
                for (Shift s : allShifts) {
                    if (s.getWorkDate() != null) {
                        LocalDate workDate = s.getWorkDate().toLocalDate();
                        if (!workDate.isBefore(today)) {
                            futureShifts.add(s);
                        }
                    }
                }
            }
            request.setAttribute("myShiftList", futureShifts);
            request.getRequestDispatcher("/ViewStaffShifts.jsp").forward(request, response);
            return; // 処理をここで終了
        }
        
        // ② パスワード認証処理（自分の詳細、または管理者が見る場合）
        UserDAO userDao = new UserDAO();
        AppUser user = userDao.findByUsername(targetUsername);
        
        if (user != null && user.getPassword().equals(inputPassword)) {
            // ⭕ 認証成功！
            ShiftDAO shiftDao = new ShiftDAO();
            List<Shift> myShifts = shiftDao.findShiftsByUsername(targetUsername);
            
            request.setAttribute("targetUser", user);
            request.setAttribute("myShifts", myShifts);
            request.getRequestDispatcher("/my_shift_detail.jsp").forward(request, response);
            
        } else {
            // ❌ パスワード間違い
            request.setAttribute("error", "パスワードが正しくありません。本人確認に失敗しました。");
            
            // 同様に「今日以降のシフト」だけを正しく作り直して戻す
            ShiftDAO shiftDao = new ShiftDAO();
            List<Shift> allShifts = shiftDao.findAllShifts();
            List<Shift> futureShifts = new ArrayList<>();
            LocalDate today = LocalDate.now();
            
            if (allShifts != null) {
                for (Shift s : allShifts) {
                    if (s.getWorkDate() != null) {
                        LocalDate workDate = s.getWorkDate().toLocalDate();
                        if (!workDate.isBefore(today)) {
                            futureShifts.add(s);
                        }
                    }
                }
            }
            request.setAttribute("myShiftList", futureShifts);
            request.getRequestDispatcher("/ViewStaffShifts.jsp").forward(request, response);
        }
    }
}