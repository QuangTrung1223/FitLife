package controller;

import dal.ProgressDAO;
import model.Progress;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProgressServlet", urlPatterns = {"/progress"})
public class ProgressServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Assume userId stored in session
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        ProgressDAO dao = new ProgressDAO();
        
        if ("add".equals(action)) {
            double weight = Double.parseDouble(request.getParameter("weight"));
            double muscleMass = Double.parseDouble(request.getParameter("muscleMass"));
            double fatPercent = Double.parseDouble(request.getParameter("fatPercent"));
            double bmi = Double.parseDouble(request.getParameter("bmi"));
            String bmiCategory = request.getParameter("bmiCategory");
            String notes = request.getParameter("notes");
            
            boolean success = dao.addProgress(userId, weight, muscleMass, fatPercent, bmi, bmiCategory, notes);
            if (success) {
                request.setAttribute("message", "Progress added successfully");
            } else {
                request.setAttribute("error", "Failed to add progress");
            }
        }
        
        List<Progress> progressList = dao.getProgressByUserId(userId);
        Progress latest = dao.getLatestProgress(userId);
        
        request.setAttribute("userProgress", progressList);
        request.setAttribute("latestProgress", latest);
        request.getRequestDispatcher("userdashboard.jsp#progress").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}