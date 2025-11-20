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
import utils.BMICalculator;

/**
 *
 * @author Guang Trump
 */
@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/user-dashboard"})
public class UserDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        String username = (String) session.getAttribute("session_login");
        
        if (userId == null || username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy dữ liệu của user hiện tại
        DietDAO dietDAO = new DietDAO();
        WorkoutDAO workoutDAO = new WorkoutDAO();
        ProgressDAO progressDAO = new ProgressDAO();
        UserDAO userDAO = new UserDAO();
        
        List<Diet> userDiets = dietDAO.getDietsByUserId(userId);
        List<Workout> userWorkouts = workoutDAO.getWorkoutsByUserId(userId);
        List<Progress> userProgress = progressDAO.getProgressByUserId(userId);
        Progress latestProgress = progressDAO.getLatestProgress(userId);
        User currentUser = userDAO.getAccountByUsername(username);
        
        // Lấy khuyến nghị dựa trên BMI nếu có
        String[] workoutRecommendations = null;
        String[] dietRecommendations = null;
        if (latestProgress != null && latestProgress.getBmiCategory() != null) {
            workoutRecommendations = BMICalculator.getWorkoutRecommendations(latestProgress.getBmiCategory());
            dietRecommendations = BMICalculator.getDietRecommendations(latestProgress.getBmiCategory());
        }
        
        // Set attributes để hiển thị trong JSP
        request.setAttribute("userDiets", userDiets);
        request.setAttribute("userWorkouts", userWorkouts);
        request.setAttribute("userProgress", userProgress);
        request.setAttribute("latestProgress", latestProgress);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("workoutRecommendations", workoutRecommendations);
        request.setAttribute("dietRecommendations", dietRecommendations);
        
        request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
