/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ProgressDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.BMICalculator;

/**
 *
 * @author Guang Trump
 */
@WebServlet(name = "BMICalculatorServlet", urlPatterns = {"/bmi-calculator"})
public class BMICalculatorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("bmi-calculator.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Lấy dữ liệu từ form
            String heightStr = request.getParameter("height");
            String weightStr = request.getParameter("weight");
            String muscleMassStr = request.getParameter("muscleMass");
            String fatPercentStr = request.getParameter("fatPercent");
            String notes = request.getParameter("notes");
            
            // Validate dữ liệu
            if (heightStr == null || heightStr.isEmpty() || weightStr == null || weightStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ chiều cao và cân nặng!");
                request.getRequestDispatcher("bmi-calculator.jsp").forward(request, response);
                return;
            }
            
            double height = Double.parseDouble(heightStr) / 100; // Convert cm to meters
            double weight = Double.parseDouble(weightStr);
            double muscleMass = muscleMassStr != null && !muscleMassStr.isEmpty() ? Double.parseDouble(muscleMassStr) : 0;
            double fatPercent = fatPercentStr != null && !fatPercentStr.isEmpty() ? Double.parseDouble(fatPercentStr) : 0;
            
            // Tính BMI
            double bmi = BMICalculator.calculateBMI(height, weight);
            String bmiCategory = BMICalculator.getBMICategory(bmi);
            
            // Lưu vào database
            ProgressDAO progressDAO = new ProgressDAO();
            boolean saved = progressDAO.addProgress(userId, weight, muscleMass, fatPercent, bmi, bmiCategory, notes);
            
            if (saved) {
                // Lấy khuyến nghị
                String[] workoutRecommendations = BMICalculator.getWorkoutRecommendations(bmiCategory);
                String[] dietRecommendations = BMICalculator.getDietRecommendations(bmiCategory);
                
                // Set attributes để hiển thị kết quả
                request.setAttribute("bmi", String.format("%.2f", bmi));
                request.setAttribute("bmiCategory", BMICalculator.getBMICategoryDescription(bmiCategory));
                request.setAttribute("bmiCategoryEn", bmiCategory);
                request.setAttribute("workoutRecommendations", workoutRecommendations);
                request.setAttribute("dietRecommendations", dietRecommendations);
                request.setAttribute("success", "Đã lưu thông tin tiến độ thành công!");
                
                request.getRequestDispatcher("bmi-result.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu dữ liệu!");
                request.getRequestDispatcher("bmi-calculator.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Vui lòng nhập đúng định dạng số!");
            request.getRequestDispatcher("bmi-calculator.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("bmi-calculator.jsp").forward(request, response);
        }
    }
}
