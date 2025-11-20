package controller;

import dal.ProgressDAO;
import dal.UserDAO;
import model.Progress;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminProgressServlet", urlPatterns = {"/admin/progress-tracking"})
public class AdminProgressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        String userRole = (String) session.getAttribute("user_role");
        
        // Admin check
        if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        ProgressDAO progressDAO = new ProgressDAO();
        UserDAO userDAO = new UserDAO();
        
        try {
            // Lấy tất cả progress records
            List<Progress> allProgress = progressDAO.getAllProgress();
            
            // Lấy danh sách tất cả users để hiển thị thông tin
            List<User> allUsers = userDAO.getAllUsers();
            
            // Set progress records cho từng user
            for (User user : allUsers) {
                List<Progress> userProgress = progressDAO.getProgressByUserId(user.getUserId());
                user.setProgressRecords(userProgress);
            }
            
            // Tính toán thống kê
            int totalProgressRecords = allProgress.size();
            int totalUsers = allUsers.size();
            int usersWithProgress = (int) allUsers.stream()
                .filter(user -> user.getProgressRecords() != null && !user.getProgressRecords().isEmpty())
                .count();
            
            request.setAttribute("allProgress", allProgress);
            request.setAttribute("allUsersWithProgress", allUsers);
            request.setAttribute("totalProgressRecords", totalProgressRecords);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("usersWithProgress", usersWithProgress);
            
            request.getRequestDispatcher("/admin-progress-tracking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
