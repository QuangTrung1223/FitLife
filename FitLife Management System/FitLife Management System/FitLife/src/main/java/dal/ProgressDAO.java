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
import model.Progress;
import util.DBContext;

/**
 *
 * @author Guang Trump
 */
public class ProgressDAO extends DBContext {
    
    public List<Progress> getProgressByUserId(int userId) {
        List<Progress> progressList = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Progress WHERE user_id = ? ORDER BY date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Progress progress = new Progress(
                    rs.getInt("progress_id"),
                    rs.getInt("user_id"),
                    rs.getDouble("weight"),
                    rs.getDouble("muscle_mass"),
                    rs.getDouble("fat_percent"),
                    rs.getDouble("bmi"),
                    rs.getString("bmi_category"),
                    rs.getDate("date").toLocalDate(),
                    rs.getString("notes")
                );
                progressList.add(progress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return progressList;
    }
    
    public List<Progress> getAllProgress() {
        List<Progress> progressList = new ArrayList<>();
        try {
            String sql = "SELECT p.*, u.username FROM Progress p JOIN Users u ON p.user_id = u.user_id ORDER BY p.date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Progress progress = new Progress(
                    rs.getInt("progress_id"),
                    rs.getInt("user_id"),
                    rs.getDouble("weight"),
                    rs.getDouble("muscle_mass"),
                    rs.getDouble("fat_percent"),
                    rs.getDouble("bmi"),
                    rs.getString("bmi_category"),
                    rs.getDate("date").toLocalDate(),
                    rs.getString("notes")
                );
                progressList.add(progress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return progressList;
    }
    
    public boolean addProgress(int userId, double weight, double muscleMass, double fatPercent, double bmi, String bmiCategory, String notes) {
        try {
            String sql = "INSERT INTO Progress (user_id, weight, muscle_mass, fat_percent, bmi, bmi_category, date, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setDouble(2, weight);
            ps.setDouble(3, muscleMass);
            ps.setDouble(4, fatPercent);
            ps.setDouble(5, bmi);
            ps.setString(6, bmiCategory);
            ps.setDate(7, java.sql.Date.valueOf(LocalDate.now()));
            ps.setString(8, notes);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Progress getLatestProgress(int userId) {
        try {
            String sql = "SELECT TOP 1 * FROM Progress WHERE user_id = ? ORDER BY date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Progress(
                    rs.getInt("progress_id"),
                    rs.getInt("user_id"),
                    rs.getDouble("weight"),
                    rs.getDouble("muscle_mass"),
                    rs.getDouble("fat_percent"),
                    rs.getDouble("bmi"),
                    rs.getString("bmi_category"),
                    rs.getDate("date").toLocalDate(),
                    rs.getString("notes")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
