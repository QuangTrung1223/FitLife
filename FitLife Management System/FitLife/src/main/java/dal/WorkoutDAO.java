/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.Workout;
import util.DBContext;

/**
 *
 * @author Guang Trump
 */
public class WorkoutDAO extends DBContext {
    
    public List<Workout> getWorkoutsByUserId(int userId) {
        List<Workout> workouts = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Workouts WHERE user_id = ? ORDER BY date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Workout workout = new Workout(
                    rs.getInt("workout_id"),
                    rs.getInt("user_id"),
                    rs.getString("workout_name"),
                    rs.getInt("duration"),
                    rs.getInt("calories_burned"),
                    rs.getString("workout_type"),
                    rs.getString("description"),
                    rs.getDate("date").toLocalDate(),
                    rs.getString("bmi_category")
                );
                workouts.add(workout);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return workouts;
    }
    
    public List<Workout> getAllWorkouts() {
        List<Workout> workouts = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Workouts ORDER BY workout_id DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Workout workout = new Workout(
                    rs.getInt("workout_id"),
                    rs.getInt("user_id"),
                    rs.getString("workout_name"),
                    rs.getInt("duration"),
                    rs.getInt("calories_burned"),
                    rs.getString("workout_type"),
                    rs.getString("description"),
                    rs.getDate("date") != null ? rs.getDate("date").toLocalDate() : null,
                    rs.getString("bmi_category")
                );
                workouts.add(workout);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return workouts;
    }
    
    public boolean addWorkout(int userId, String workoutName, int duration, int caloriesBurned, String workoutType, String description, String bmiCategory) {
        try {
            String sql = "INSERT INTO Workouts (user_id, workout_name, duration, calories_burned, workout_type, description, date, bmi_category) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, workoutName);
            ps.setInt(3, duration);
            ps.setInt(4, caloriesBurned);
            ps.setString(5, workoutType);
            ps.setString(6, description);
            ps.setDate(7, java.sql.Date.valueOf(LocalDate.now()));
            ps.setString(8, bmiCategory);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Phương thức để thêm workout mẫu (không cần user_id) - sử dụng user_id = 1 (admin) hoặc tìm user đầu tiên
    public boolean addWorkout(Workout workout) {
        if (c == null) {
            System.err.println("WorkoutDAO: Connection is null! Cannot add workout.");
            return false;
        }
        
        try {
            // Tìm user_id của admin hoặc user đầu tiên để làm user_id mặc định
            int defaultUserId = getDefaultUserId();
            System.out.println("WorkoutDAO: Using default user_id: " + defaultUserId);
            
            String sql = "INSERT INTO Workouts (user_id, workout_name, description, workout_type, duration, calories_burned, date, bmi_category) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, defaultUserId);
            ps.setString(2, workout.getWorkoutName());
            ps.setString(3, workout.getDescription());
            ps.setString(4, workout.getWorkoutType());
            ps.setInt(5, workout.getDuration());
            ps.setInt(6, workout.getCaloriesBurned());
            ps.setDate(7, workout.getDate() != null ? java.sql.Date.valueOf(workout.getDate()) : java.sql.Date.valueOf(LocalDate.now()));
            ps.setString(8, workout.getBmiCategory() != null ? workout.getBmiCategory() : "");
            
            System.out.println("WorkoutDAO: Executing INSERT with: user_id=" + defaultUserId + ", name=" + workout.getWorkoutName());
            int rowsAffected = ps.executeUpdate();
            System.out.println("WorkoutDAO: Đã thêm workout, rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("WorkoutDAO: Lỗi khi thêm workout: " + e.getMessage());
            System.err.println("WorkoutDAO: SQL State: " + e.getSQLState());
            System.err.println("WorkoutDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("WorkoutDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy user_id mặc định (admin hoặc user đầu tiên)
    private int getDefaultUserId() {
        if (c == null) {
            System.err.println("WorkoutDAO: Connection is null!");
            return 1; // Fallback
        }
        
        try {
            // Tìm admin user đầu tiên
            String sql = "SELECT TOP 1 user_id FROM Users WHERE role = 'admin' ORDER BY user_id";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                System.out.println("WorkoutDAO: Found admin user_id: " + userId);
                return userId;
            }
            
            // Nếu không có admin, lấy user đầu tiên
            sql = "SELECT TOP 1 user_id FROM Users ORDER BY user_id";
            ps = c.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                System.out.println("WorkoutDAO: Found first user_id: " + userId);
                return userId;
            }
            
            // Nếu không có user nào, throw exception
            System.err.println("WorkoutDAO: No users found in database! Cannot add workout without user_id.");
            throw new SQLException("No users found in database. Please create at least one user first.");
        } catch (SQLException e) {
            System.err.println("WorkoutDAO: Lỗi khi lấy default user_id: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Cannot get default user_id: " + e.getMessage(), e);
        }
    }
    public Workout getWorkoutById(int id) {
    try {
        String sql = "SELECT * FROM Workouts WHERE workout_id = ?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new Workout(
                rs.getInt("workout_id"),
                rs.getInt("user_id"),
                rs.getString("workout_name"),
                rs.getInt("duration"),
                rs.getInt("calories_burned"),
                rs.getString("workout_type"),
                rs.getString("description"),
                rs.getDate("date").toLocalDate(),
                rs.getString("bmi_category")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

public boolean updateWorkout(Workout workout) {
    try {
        String sql = "UPDATE Workouts SET workout_name=?, duration=?, calories_burned=?, workout_type=?, description=?, bmi_category=?, date=? WHERE workout_id=?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setString(1, workout.getWorkoutName());
        ps.setInt(2, workout.getDuration());
        ps.setInt(3, workout.getCaloriesBurned());
        ps.setString(4, workout.getWorkoutType());
        ps.setString(5, workout.getDescription());
        ps.setString(6, workout.getBmiCategory());
        ps.setDate(7, java.sql.Date.valueOf(workout.getDate()));
        ps.setInt(8, workout.getWorkoutId());
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public boolean deleteWorkout(int id) {
    try {
        String sql = "DELETE FROM Workouts WHERE workout_id = ?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

}
