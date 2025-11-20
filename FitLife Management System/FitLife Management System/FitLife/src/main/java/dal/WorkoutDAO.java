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
            String sql = "SELECT w.*, u.username FROM Workouts w JOIN Users u ON w.user_id = u.user_id ORDER BY w.date DESC";
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
}
