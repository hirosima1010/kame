// 司令塔。ブラウザからの要求を受け取り、DAOやModelを呼び出して、次の画面を決める。
package servlet;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AppUser;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    // とりあえずエラー回避のお守り」として毎回書く
    private static final long serialVersionUID = 1L;
    
    // doPost は「送信されたデータを受け取って処理する受け皿」です。
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 文字化け対策（もしJSPからの日本語入力がある場合のために念のため追加）
        request.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 1. 職人の「実物（インスタンス）」を作る（小文字の userDao に代入）
        UserDAO userDao = new UserDAO();
        
        // 2. 作った実物（userDao）を使ってメソッドを呼び出す！
        AppUser loginUser = userDao.findUser(username, password);
        
        if (loginUser != null) {
            // ログイン成功
            HttpSession session = request.getSession();
            
            // 「箱」をまるごとセッションに保存する
            session.setAttribute("loginuser", loginUser);
            
            if ("admin".equals(loginUser.getRole())) {
                // 管理者なら管理者用ページへ
                response.sendRedirect("admin/admin_main.jsp");
            } else {
                // それ以外ならスタッフ用ページへ
                response.sendRedirect("staff_main.jsp");
            }
            
        } else {
            // ログイン失敗
            request.setAttribute("error", "IDまたはパスワードが違います");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}