package controller;

import dal.WorkoutDAO;
import model.Workout;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "WorkoutServlet", urlPatterns = {"/workout"})
public class WorkoutServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("user_role");
        String sessionLogin = (String) session.getAttribute("session_login");
        Integer userId = (Integer) session.getAttribute("user_id");
        
        WorkoutDAO dao = new WorkoutDAO();
        String action = request.getParameter("action");
        
        // Check if admin is accessing
        boolean isAdmin = "admin".equalsIgnoreCase(userRole) && sessionLogin != null;
        
        // Handle CRUD operations for admin
        if (isAdmin && action != null) {
            if ("add".equals(action)) {
                Workout workout = new Workout();
                workout.setWorkoutName(request.getParameter("workoutName"));
                workout.setDescription(request.getParameter("description"));
                workout.setWorkoutType(request.getParameter("workoutType"));
                workout.setDuration(Integer.parseInt(request.getParameter("duration")));
                workout.setCaloriesBurned(Integer.parseInt(request.getParameter("caloriesBurned")));
                workout.setBmiCategory(request.getParameter("bmiCategory"));
                workout.setDate(java.time.LocalDate.now());
                
                boolean success = dao.addWorkout(workout);
                if (success) {
                    session.setAttribute("success", "Workout added successfully!");
                } else {
                    session.setAttribute("error", "Failed to add workout!");
                }
                response.sendRedirect("workout.jsp");
                return;
            } else if ("update".equals(action)) {
                Workout workout = new Workout();
                workout.setWorkoutId(Integer.parseInt(request.getParameter("id")));
                workout.setWorkoutName(request.getParameter("workoutName"));
                workout.setDescription(request.getParameter("description"));
                workout.setWorkoutType(request.getParameter("workoutType"));
                workout.setDuration(Integer.parseInt(request.getParameter("duration")));
                workout.setCaloriesBurned(Integer.parseInt(request.getParameter("caloriesBurned")));
                workout.setBmiCategory(request.getParameter("bmiCategory"));
                workout.setDate(java.time.LocalDate.now());
                
                boolean success = dao.updateWorkout(workout);
                if (success) {
                    session.setAttribute("success", "Workout updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update workout!");
                }
                response.sendRedirect("workout.jsp");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.deleteWorkout(id);
                if (success) {
                    session.setAttribute("success", "Workout deleted successfully!");
                } else {
                    session.setAttribute("error", "Failed to delete workout!");
                }
                response.sendRedirect("workout.jsp");
                return;
            }
        }
        
        // For regular users
        if (!isAdmin && userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Load workouts
        List<Workout> workouts;
        if (isAdmin) {
            // Admin sees all workouts
            workouts = dao.getAllWorkouts();
        } else {
            // User sees only their workouts
            workouts = dao.getWorkoutsByUserId(userId);
        }
        
        request.setAttribute("workouts", workouts);
        request.setAttribute("isAdmin", isAdmin);
        
        // Forward to appropriate JSP
        if (isAdmin) {
            request.getRequestDispatcher("workout.jsp").forward(request, response);
        } else {
            request.setAttribute("userWorkouts", workouts);
            request.getRequestDispatcher("userdashboard.jsp#workouts").forward(request, response);
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