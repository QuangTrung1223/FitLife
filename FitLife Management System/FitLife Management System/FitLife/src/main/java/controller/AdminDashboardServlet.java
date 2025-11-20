/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.DietDAO;
import dal.ProgressDAO;
import dal.UserDAO;
import dal.WorkoutDAO;
import java.io.IOException;
import java.util.List;
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

/**
 *
 * @author Guang Trump
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("user_role");
        
        if (!"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy dữ liệu cho admin dashboard
        UserDAO userDAO = new UserDAO();
        DietDAO dietDAO = new DietDAO();
        WorkoutDAO workoutDAO = new WorkoutDAO();
        ProgressDAO progressDAO = new ProgressDAO();
        
        List<User> allUsers = userDAO.getAllUsers();
        List<Diet> allDiets = dietDAO.getAllDiets();
        List<Workout> allWorkouts = workoutDAO.getAllWorkouts();
        List<Progress> allProgress = progressDAO.getAllProgress();
        
        // Set attributes để hiển thị trong JSP
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("allDiets", allDiets);
        request.setAttribute("allWorkouts", allWorkouts);
        request.setAttribute("allProgress", allProgress);
        
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
