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
import model.Diet;
import util.DBContext;

/**
 *
 * @author Guang Trump
 */
public class DietDAO extends DBContext {
    
    public List<Diet> getDietsByUserId(int userId) {
        List<Diet> diets = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Diets WHERE user_id = ? ORDER BY date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Diet diet = new Diet(
                    rs.getInt("diet_id"),
                    rs.getInt("user_id"),
                    rs.getString("meal_name"),
                    rs.getInt("calories"),
                    rs.getString("meal_type"),
                    rs.getString("description"),
                    rs.getDate("date").toLocalDate(),
                    rs.getString("bmi_category")
                );
                diets.add(diet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return diets;
    }
    
    public List<Diet> getAllDiets() {
        List<Diet> diets = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Diets ORDER BY diet_id DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Diet diet = new Diet(
                    rs.getInt("diet_id"),
                    rs.getInt("user_id"),
                    rs.getString("meal_name"),
                    rs.getInt("calories"),
                    rs.getString("meal_type"),
                    rs.getString("description"),
                    rs.getDate("date") != null ? rs.getDate("date").toLocalDate() : null,
                    rs.getString("bmi_category")
                );
                diets.add(diet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return diets;
    }
    
    public boolean addDiet(int userId, String mealName, int calories, String mealType, String description, String bmiCategory) {
        try {
            String sql = "INSERT INTO Diets (user_id, meal_name, calories, meal_type, description, date, bmi_category) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, mealName);
            ps.setInt(3, calories);
            ps.setString(4, mealType);
            ps.setString(5, description);
            ps.setDate(6, java.sql.Date.valueOf(LocalDate.now()));
            ps.setString(7, bmiCategory);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Phương thức để thêm diet mẫu (không cần user_id) - sử dụng user_id = 1 (admin) hoặc tìm user đầu tiên
    public boolean addDiet(Diet diet) {
        if (c == null) {
            System.err.println("DietDAO: Connection is null! Cannot add diet.");
            return false;
        }
        
        try {
            // Tìm user_id của admin hoặc user đầu tiên để làm user_id mặc định
            int defaultUserId = getDefaultUserId();
            System.out.println("DietDAO: Using default user_id: " + defaultUserId);
            
            String sql = "INSERT INTO Diets (user_id, meal_name, description, meal_type, calories, date, bmi_category) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, defaultUserId);
            ps.setString(2, diet.getMealName());
            ps.setString(3, diet.getDescription());
            ps.setString(4, diet.getMealType());
            ps.setInt(5, diet.getCalories());
            ps.setDate(6, diet.getDate() != null ? java.sql.Date.valueOf(diet.getDate()) : java.sql.Date.valueOf(LocalDate.now()));
            ps.setString(7, diet.getBmiCategory() != null ? diet.getBmiCategory() : "");
            
            System.out.println("DietDAO: Executing INSERT with: user_id=" + defaultUserId + ", name=" + diet.getMealName());
            int rowsAffected = ps.executeUpdate();
            System.out.println("DietDAO: Đã thêm diet, rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("DietDAO: Lỗi khi thêm diet: " + e.getMessage());
            System.err.println("DietDAO: SQL State: " + e.getSQLState());
            System.err.println("DietDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("DietDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy user_id mặc định (admin hoặc user đầu tiên)
    private int getDefaultUserId() {
        if (c == null) {
            System.err.println("DietDAO: Connection is null!");
            return 1; // Fallback
        }
        
        try {
            // Tìm admin user đầu tiên
            String sql = "SELECT TOP 1 user_id FROM Users WHERE role = 'admin' ORDER BY user_id";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                System.out.println("DietDAO: Found admin user_id: " + userId);
                return userId;
            }
            
            // Nếu không có admin, lấy user đầu tiên
            sql = "SELECT TOP 1 user_id FROM Users ORDER BY user_id";
            ps = c.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                System.out.println("DietDAO: Found first user_id: " + userId);
                return userId;
            }
            
            // Nếu không có user nào, throw exception
            System.err.println("DietDAO: No users found in database! Cannot add diet without user_id.");
            throw new SQLException("No users found in database. Please create at least one user first.");
        } catch (SQLException e) {
            System.err.println("DietDAO: Lỗi khi lấy default user_id: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Cannot get default user_id: " + e.getMessage(), e);
        }
    }
    public Diet getDietById(int id) {
    try {
        String sql = "SELECT * FROM Diets WHERE diet_id = ?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new Diet(
                rs.getInt("diet_id"),
                rs.getInt("user_id"),
                rs.getString("meal_name"),
                rs.getInt("calories"),
                rs.getString("meal_type"),
                rs.getString("description"),
                rs.getDate("date") != null ? rs.getDate("date").toLocalDate() : null,
                rs.getString("bmi_category")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

public boolean updateDiet(Diet diet) {
    try {
        String sql = "UPDATE Diets SET meal_name=?, calories=?, meal_type=?, description=?, bmi_category=?, date=? WHERE diet_id=?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setString(1, diet.getMealName());
        ps.setInt(2, diet.getCalories());
        ps.setString(3, diet.getMealType());
        ps.setString(4, diet.getDescription());
        ps.setString(5, diet.getBmiCategory());
        ps.setDate(6, java.sql.Date.valueOf(diet.getDate()));
        ps.setInt(7, diet.getDietId());
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public boolean deleteDiet(int id) {
    try {
        String sql = "DELETE FROM Diets WHERE diet_id=?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
}
