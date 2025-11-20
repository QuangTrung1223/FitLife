package controller;

import dal.DietDAO;
import dal.ProgressDAO;
import dal.UserDAO;
import dal.WorkoutDAO;
import listener.SessionListener;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Diet;
import model.Progress;
import model.User;
import model.Workout;

@WebServlet(name = "AdminDashboardSimpleServlet", urlPatterns = {"/admin-dashboard-simple"})
public class AdminDashboardSimpleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            String sessionLogin = (String) session.getAttribute("session_login");
            String userRole = (String) session.getAttribute("user_role");

            System.out.println("=== [AdminDashboardSimpleServlet] Debug Info ===");
            System.out.println("Session Login: " + sessionLogin);
            System.out.println("User Role: " + userRole);

            // Redirect to login if not logged in or not admin
            if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
                System.out.println("[AdminDashboardSimpleServlet] Redirecting to login - not admin");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            System.out.println("[AdminDashboardSimpleServlet] Admin access granted, fetching data...");

            // Fetch data from database
            UserDAO userDAO = new UserDAO();
            DietDAO dietDAO = new DietDAO();
            WorkoutDAO workoutDAO = new WorkoutDAO();
            ProgressDAO progressDAO = new ProgressDAO();

            List<User> allUsers = userDAO.getAllUsers();
            List<Diet> allDiets = dietDAO.getAllDiets();
            List<Workout> allWorkouts = workoutDAO.getAllWorkouts();
            List<Progress> allProgress = progressDAO.getAllProgress();

            // Get online users information
            ServletContext context = getServletContext();
            int onlineUsersCount = SessionListener.getOnlineUsersCount(context);
            Set<String> onlineUsers = SessionListener.getOnlineUsers(context);

            // Set data to JSP
            request.setAttribute("allUsers", allUsers);
            request.setAttribute("allDiets", allDiets);
            request.setAttribute("allWorkouts", allWorkouts);
            request.setAttribute("allProgress", allProgress);
            request.setAttribute("totalUsers", allUsers.size());
            request.setAttribute("totalWorkouts", allWorkouts.size());
            request.setAttribute("totalDiets", allDiets.size());
            request.setAttribute("totalProgress", allProgress.size());
            request.setAttribute("onlineUsersCount", onlineUsersCount);
            request.setAttribute("onlineUsers", onlineUsers);
            
            // Flash messages from session
            String success = (String) session.getAttribute("success");
            String error = (String) session.getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }

            System.out.println("[AdminDashboardSimpleServlet] Forwarding to simple JSP...");
            request.getRequestDispatcher("/admin-dashboard-simple.jsp").forward(request, response);
            System.out.println("[AdminDashboardSimpleServlet] Forward completed successfully");
            
        } catch (Exception e) {
            System.err.println("=== [AdminDashboardSimpleServlet] ERROR ===");
            e.printStackTrace();
            
            response.setContentType("text/html");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Admin Dashboard Simple Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            response.getWriter().println("<pre>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/login.jsp'>Back to Login</a>");
            response.getWriter().println("</body></html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
