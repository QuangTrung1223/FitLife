package controller;

import dal.CoachDAO;
import model.Coach;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CoachServlet", urlPatterns = {"/coach"})
public class CoachServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        String sessionLogin = (String) session.getAttribute("session_login");
        
        // Check if user is logged in
        if (userId == null || sessionLogin == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        CoachDAO coachDAO = new CoachDAO();
        List<Coach> coaches;
        
        try {
            // Try to get coaches from database first
            coaches = coachDAO.getAllCoaches();
            
            // If no coaches in database, use sample coaches
            if (coaches == null || coaches.isEmpty()) {
                coaches = coachDAO.getSampleCoaches();
            }
        } catch (Exception e) {
            // If error, use sample coaches
            coaches = coachDAO.getSampleCoaches();
        }
        
        request.setAttribute("coaches", coaches);
        request.getRequestDispatcher("coach.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
