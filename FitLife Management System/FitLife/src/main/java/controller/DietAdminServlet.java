package controller;

import dal.DietDAO;
import model.Diet;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "DietAdminServlet", urlPatterns = {"/admin-diet"})
public class DietAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        String userRole = (String) session.getAttribute("user_role");
        
        if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        DietDAO dao = new DietDAO();

        switch (action) {
            case "add":
                request.getRequestDispatcher("/admin-add-diet.jsp").forward(request, response);
                break;

            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Diet diet = dao.getDietById(id);
                request.setAttribute("diet", diet);
                request.getRequestDispatcher("/admin-edit-diet.jsp").forward(request, response);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                HttpSession sessionDelete = request.getSession();
                if (dao.deleteDiet(deleteId)) {
                    sessionDelete.setAttribute("success", "Xóa món ăn thành công!");
                } else {
                    sessionDelete.setAttribute("error", "Xóa món ăn thất bại!");
                }
                response.sendRedirect("admin-diet?action=list");
                break;

            default:
                List<Diet> diets = dao.getAllDiets();
                request.setAttribute("diets", diets);
                request.getRequestDispatcher("/admin-diet.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        String userRole = (String) session.getAttribute("user_role");
        
        if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        DietDAO dao = new DietDAO();

        if ("add".equals(action)) {
            try {
                String mealName = request.getParameter("mealName");
                String description = request.getParameter("description");
                String mealType = request.getParameter("mealType");
                String caloriesStr = request.getParameter("calories");
                String bmiCategory = request.getParameter("bmiCategory");
                
                // Validate required fields
                if (mealName == null || mealName.trim().isEmpty()) {
                    session.setAttribute("error", "Tên món ăn không được để trống!");
                    response.sendRedirect("admin-diet?action=list");
                    return;
                }
                
                if (description == null || description.trim().isEmpty()) {
                    session.setAttribute("error", "Mô tả không được để trống!");
                    response.sendRedirect("admin-diet?action=list");
                    return;
                }
                
                if (mealType == null || mealType.trim().isEmpty()) {
                    session.setAttribute("error", "Loại bữa ăn không được để trống!");
                    response.sendRedirect("admin-diet?action=list");
                    return;
                }
                
                int calories = 0;
                
                try {
                    if (caloriesStr != null && !caloriesStr.trim().isEmpty()) {
                        calories = Integer.parseInt(caloriesStr);
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Calories không hợp lệ!");
                    response.sendRedirect("admin-diet?action=list");
                    return;
                }
                
                Diet diet = new Diet();
                diet.setMealName(mealName);
                diet.setDescription(description);
                diet.setMealType(mealType);
                diet.setCalories(calories);
                diet.setBmiCategory(bmiCategory != null ? bmiCategory : "");
                diet.setDate(LocalDate.now());
                
                boolean result = dao.addDiet(diet);
                System.out.println("[DietAdminServlet] Add diet result: " + result);
                if (result) {
                    session.setAttribute("success", "Thêm món ăn thành công!");
                    System.out.println("[DietAdminServlet] Diet added successfully");
                } else {
                    session.setAttribute("error", "Thêm món ăn thất bại! Vui lòng kiểm tra lại thông tin.");
                    System.err.println("[DietAdminServlet] Failed to add diet - dao.addDiet() returned false");
                }
            } catch (Exception e) {
                System.err.println("[DietAdminServlet] Exception when adding diet: " + e.getMessage());
                e.printStackTrace();
                String errorMsg = "Lỗi khi thêm món ăn: " + (e.getMessage() != null ? e.getMessage() : "Unknown error");
                session.setAttribute("error", errorMsg);
            }
            response.sendRedirect("admin-diet?action=list");
        }

        if ("update".equals(action)) {
            try {
                Diet diet = new Diet();
                diet.setDietId(Integer.parseInt(request.getParameter("id")));
                diet.setMealName(request.getParameter("mealName"));
                diet.setDescription(request.getParameter("description"));
                diet.setMealType(request.getParameter("mealType"));
                diet.setCalories(Integer.parseInt(request.getParameter("calories")));
                diet.setBmiCategory(request.getParameter("bmiCategory"));
                diet.setDate(LocalDate.now());
                
                HttpSession sessionUpdate = request.getSession();
                if (dao.updateDiet(diet)) {
                    sessionUpdate.setAttribute("success", "Cập nhật món ăn thành công!");
                } else {
                    sessionUpdate.setAttribute("error", "Cập nhật món ăn thất bại!");
                }
            } catch (Exception e) {
                HttpSession sessionError = request.getSession();
                sessionError.setAttribute("error", "Lỗi khi cập nhật món ăn: " + e.getMessage());
            }
            response.sendRedirect("admin-diet?action=list");
        }
    }
}
