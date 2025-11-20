package controller;

import listener.SessionListener;
import java.io.IOException;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session hiện tại
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Lấy username trước khi xóa session để remove khỏi online list
            String username = (String) session.getAttribute("session_login");
            
            // Xóa user khỏi danh sách online
            if (username != null) {
                ServletContext context = getServletContext();
                SessionListener.removeOnlineUser(context, username);
            }
            
            // Xóa tất cả attributes trong session
            session.removeAttribute("session_login");
            session.removeAttribute("user_id");
            session.removeAttribute("user_role");
            // Invalidate session
            session.invalidate();
        }
        
        // Xóa cookies
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("COOKIE_USERNAME") || cookie.getName().equals("COOKIE_PASSWORD")) {
                    cookie.setMaxAge(0);
                    cookie.setValue("");
                    response.addCookie(cookie);
                }
            }
        }
        
        // Redirect về trang login
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}







