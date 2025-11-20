/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.WorkoutDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import model.Workout;

@WebServlet("/admin/workout")
public class AdminWorkoutServlet extends HttpServlet {

    private WorkoutDAO workoutDAO = new WorkoutDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 🔒 Kiểm tra quyền admin (nếu có session role)
        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Workout workout = workoutDAO.getWorkoutById(editId);
                if (workout == null) {
                    response.sendRedirect("workout");
                    return;
                }
                request.setAttribute("workout", workout);
                request.getRequestDispatcher("/admin/editWorkout.jsp").forward(request, response);
                break;

            case "add":
                request.getRequestDispatcher("/admin/addWorkout.jsp").forward(request, response);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                workoutDAO.deleteWorkout(deleteId);
                response.sendRedirect("workout");
                break;

            default:
                List<Workout> list = workoutDAO.getAllWorkouts();
                request.setAttribute("workouts", list);
                request.getRequestDispatcher("/admin/workoutList.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        String name = request.getParameter("workoutName");
        String type = request.getParameter("workoutType");
        String desc = request.getParameter("description");
        int duration = Integer.parseInt(request.getParameter("duration"));
        int calories = Integer.parseInt(request.getParameter("caloriesBurned"));
        String bmi = request.getParameter("bmiCategory");

        switch (action) {
            case "update":
                int id = Integer.parseInt(request.getParameter("workoutId"));
                Workout existing = workoutDAO.getWorkoutById(id);
                if (existing != null) {
                    Workout updated = new Workout(
                        id,
                        0,
                        name,
                        duration,
                        calories,
                        type,
                        desc,
                        existing.getDate(), // ⚙️ Giữ nguyên ngày cũ
                        bmi
                    );
                    workoutDAO.updateWorkout(updated);
                }
                response.sendRedirect("workout");
                break;

            case "create":
                Workout newWorkout = new Workout(
                    0,
                    0,
                    name,
                    duration,
                    calories,
                    type,
                    desc,
                    LocalDate.now(),
                    bmi
                );
                workoutDAO.addWorkout(newWorkout);
                response.sendRedirect("workout");
                break;
        }
    }
}
