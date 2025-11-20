package controller;

import dal.WorkoutDAO;
import model.Workout;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "WorkoutAdminServlet", urlPatterns = {"/admin-workout"})
public class WorkoutAdminServlet extends HttpServlet {

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

        WorkoutDAO dao = new WorkoutDAO();

        switch (action) {
            case "add":
                request.getRequestDispatcher("/admin-add-workout.jsp").forward(request, response);
                break;

            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Workout workout = dao.getWorkoutById(id);
                request.setAttribute("workout", workout);
                request.getRequestDispatcher("/admin-edit-workout.jsp").forward(request, response);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                HttpSession sessionDelete = request.getSession();
                if (dao.deleteWorkout(deleteId)) {
                    sessionDelete.setAttribute("success", "Xóa bài tập thành công!");
                } else {
                    sessionDelete.setAttribute("error", "Xóa bài tập thất bại!");
                }
                response.sendRedirect("admin-workout?action=list");
                break;

            default:
                List<Workout> workouts = dao.getAllWorkouts();
                request.setAttribute("workouts", workouts);
                request.getRequestDispatcher("/admin-workout.jsp").forward(request, response);
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
        WorkoutDAO dao = new WorkoutDAO();

        if ("add".equals(action)) {
            try {
                String workoutName = request.getParameter("workoutName");
                String description = request.getParameter("description");
                String workoutType = request.getParameter("workoutType");
                String durationStr = request.getParameter("duration");
                String caloriesStr = request.getParameter("caloriesBurned");
                String bmiCategory = request.getParameter("bmiCategory");
                
                // Validate required fields
                if (workoutName == null || workoutName.trim().isEmpty()) {
                    session.setAttribute("error", "Tên bài tập không được để trống!");
                    response.sendRedirect("admin-workout?action=list");
                    return;
                }
                
                if (description == null || description.trim().isEmpty()) {
                    session.setAttribute("error", "Mô tả không được để trống!");
                    response.sendRedirect("admin-workout?action=list");
                    return;
                }
                
                if (workoutType == null || workoutType.trim().isEmpty()) {
                    session.setAttribute("error", "Loại bài tập không được để trống!");
                    response.sendRedirect("admin-workout?action=list");
                    return;
                }
                
                int duration = 0;
                int caloriesBurned = 0;
                
                try {
                    if (durationStr != null && !durationStr.trim().isEmpty()) {
                        duration = Integer.parseInt(durationStr);
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Thời gian không hợp lệ!");
                    response.sendRedirect("admin-workout?action=list");
                    return;
                }
                
                try {
                    if (caloriesStr != null && !caloriesStr.trim().isEmpty()) {
                        caloriesBurned = Integer.parseInt(caloriesStr);
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Calories không hợp lệ!");
                    response.sendRedirect("admin-workout?action=list");
                    return;
                }
                
                Workout workout = new Workout();
                workout.setWorkoutName(workoutName);
                workout.setDescription(description);
                workout.setWorkoutType(workoutType);
                workout.setDuration(duration);
                workout.setCaloriesBurned(caloriesBurned);
                workout.setBmiCategory(bmiCategory != null ? bmiCategory : "");
                workout.setDate(LocalDate.now());
                
                boolean result = dao.addWorkout(workout);
                System.out.println("[WorkoutAdminServlet] Add workout result: " + result);
                if (result) {
                    session.setAttribute("success", "Thêm bài tập thành công!");
                    System.out.println("[WorkoutAdminServlet] Workout added successfully");
                } else {
                    session.setAttribute("error", "Thêm bài tập thất bại! Vui lòng kiểm tra lại thông tin.");
                    System.err.println("[WorkoutAdminServlet] Failed to add workout - dao.addWorkout() returned false");
                }
            } catch (Exception e) {
                System.err.println("[WorkoutAdminServlet] Exception when adding workout: " + e.getMessage());
                e.printStackTrace();
                String errorMsg = "Lỗi khi thêm bài tập: " + (e.getMessage() != null ? e.getMessage() : "Unknown error");
                session.setAttribute("error", errorMsg);
            }
            response.sendRedirect("admin-workout?action=list");
        }

        if ("update".equals(action)) {
            try {
                Workout workout = new Workout();
                workout.setWorkoutId(Integer.parseInt(request.getParameter("id")));
                workout.setWorkoutName(request.getParameter("workoutName"));
                workout.setDescription(request.getParameter("description"));
                workout.setWorkoutType(request.getParameter("workoutType"));
                workout.setDuration(Integer.parseInt(request.getParameter("duration")));
                workout.setCaloriesBurned(Integer.parseInt(request.getParameter("caloriesBurned")));
                workout.setBmiCategory(request.getParameter("bmiCategory"));
                workout.setDate(LocalDate.now());
                
                HttpSession sessionUpdate = request.getSession();
                if (dao.updateWorkout(workout)) {
                    sessionUpdate.setAttribute("success", "Cập nhật bài tập thành công!");
                } else {
                    sessionUpdate.setAttribute("error", "Cập nhật bài tập thất bại!");
                }
            } catch (Exception e) {
                HttpSession sessionError = request.getSession();
                sessionError.setAttribute("error", "Lỗi khi cập nhật bài tập: " + e.getMessage());
            }
            response.sendRedirect("admin-workout?action=list");
        }
    }
}
