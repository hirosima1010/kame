package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	// とりあえずエラー回避のお守り」として毎回書く
	private static final long serialVersionUID = 1L;
	
	// doPost は「送信されたデータを受け取って処理する受け皿」です。
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		// if (dao.checkUser(username, password)) {
		if ("admin".equals(username) && "password".equals(password)) {
			
			// ログイン成功
			HttpSession session = request.getSession();
			session.setAttribute("user", username);
			
			// メイン画面に飛ばす
			response.sendRedirect("main.jsp");
		} else {
			// ログイン失敗
			request.setAttribute("error", "IDまたはパスワードが違います");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}
	
}
