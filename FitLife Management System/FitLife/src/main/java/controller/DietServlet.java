package controller;

import dal.DietDAO;
import model.Diet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DietServlet", urlPatterns = {"/diet"})
public class DietServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("user_role");
        String sessionLogin = (String) session.getAttribute("session_login");
        Integer userId = (Integer) session.getAttribute("user_id");
        
        DietDAO dao = new DietDAO();
        String action = request.getParameter("action");
        
        // Check if admin is accessing
        boolean isAdmin = "admin".equalsIgnoreCase(userRole) && sessionLogin != null;
        
        // Handle CRUD operations for admin
        if (isAdmin && action != null) {
            if ("add".equals(action)) {
                Diet diet = new Diet();
                diet.setMealName(request.getParameter("mealName"));
                diet.setDescription(request.getParameter("description"));
                diet.setMealType(request.getParameter("mealType"));
                diet.setCalories(Integer.parseInt(request.getParameter("calories")));
                diet.setBmiCategory(request.getParameter("bmiCategory"));
                diet.setDate(java.time.LocalDate.now());
                
                boolean success = dao.addDiet(diet);
                if (success) {
                    session.setAttribute("success", "Diet added successfully!");
                } else {
                    session.setAttribute("error", "Failed to add diet!");
                }
                response.sendRedirect("diet.jsp");
                return;
            } else if ("update".equals(action)) {
                Diet diet = new Diet();
                diet.setDietId(Integer.parseInt(request.getParameter("id")));
                diet.setMealName(request.getParameter("mealName"));
                diet.setDescription(request.getParameter("description"));
                diet.setMealType(request.getParameter("mealType"));
                diet.setCalories(Integer.parseInt(request.getParameter("calories")));
                diet.setBmiCategory(request.getParameter("bmiCategory"));
                diet.setDate(java.time.LocalDate.now());
                
                boolean success = dao.updateDiet(diet);
                if (success) {
                    session.setAttribute("success", "Diet updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update diet!");
                }
                response.sendRedirect("diet.jsp");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.deleteDiet(id);
                if (success) {
                    session.setAttribute("success", "Diet deleted successfully!");
                } else {
                    session.setAttribute("error", "Failed to delete diet!");
                }
                response.sendRedirect("diet.jsp");
                return;
            }
        }
        
        // For regular users
        if (!isAdmin && userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Load diets
        List<Diet> diets;
        if (isAdmin) {
            // Admin sees all diets
            diets = dao.getAllDiets();
        } else {
            // User sees only their diets
            diets = dao.getDietsByUserId(userId);
        }
        
        request.setAttribute("diets", diets);
        request.setAttribute("isAdmin", isAdmin);
        
        // Forward to appropriate JSP
        if (isAdmin) {
            request.getRequestDispatcher("diet.jsp").forward(request, response);
        } else {
            request.setAttribute("userDiets", diets);
            request.getRequestDispatcher("userdashboard.jsp#diet").forward(request, response);
        }
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