package servlet;

import java.io.IOException;
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

@WebServlet("/shiftAuth")
public class ShiftAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // ① 画面から「見たい対象のユーザーID」と「入力されたパスワード」を受け取る
        String targetUsername = request.getParameter("targetUsername");
        String inputPassword = request.getParameter("password");
        
        // ② すでにあるUserDAOを使って、そのユーザーの正しい情報をDBから持ってくる
        UserDAO userDao = new UserDAO();
        AppUser user = userDao.findByUsername(targetUsername); // ユーザー情報を1件取得
        
        // ③ パスワードの答え合わせ
        if (user != null && user.getPassword().equals(inputPassword)) {
            // ⭕ 認証成功！
            
            // 給料明細の計算に必要な「その人のシフト履歴」をShiftDAOで取得
            ShiftDAO shiftDao = new ShiftDAO();
            List<Shift> myShifts = shiftDao.findShiftsByUsername(targetUsername);
            
            // 本人のユーザー情報とシフト履歴をリクエストに詰める
            request.setAttribute("targetUser", user);
            request.setAttribute("myShifts", myShifts);
            
            // 個人詳細・給料明細画面（my_shift_detail.jsp）へ進む
            request.getRequestDispatcher("/my_shift_detail.jsp").forward(request, response);
            
        } else {
            // ❌ パスワード間違い、またはユーザーが存在しない
            // メッセージをつけて元のシフト画面（/shift）へ追い返す
            request.setAttribute("error", "パスワードが正しくありません。本人確認に失敗しました。");
            
            // 再び最新のシフト一覧を取得し直してシフト画面を表示
            ShiftDAO shiftDao = new ShiftDAO();
            List<Shift> shiftList = shiftDao.findAllShifts();
            request.setAttribute("shiftList", shiftList);
            
            request.getRequestDispatcher("/shift.jsp").forward(request, response);
        }
    }
}