/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;
import util.DBContext;

/**
 *
 * @author Guang Trump
 */
public class UserDAO extends DBContext {
    public User checkLogin(String username, String password) {
        try {
            String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("user_id"), rs.getString("username"), rs.getString("password"), rs.getString("email"), rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
   public User getAccountByUsername(String username) {
    try {
        String sql = "SELECT * FROM Users WHERE username = ?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            return new User(rs.getInt("user_id"), rs.getString("username"), rs.getString("password"), rs.getString("email"), rs.getString("role"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

   public boolean register(String username, String password, String email) {
        System.out.println("UserDAO: Thêm user với username=" + username + ", email=" + email);
        try {
            String sql = "INSERT INTO Users (username, password, email) VALUES(?, ?, ?)";
            System.out.println("UserDAO: Câu lệnh SQL thêm user: " + sql);
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            int rowsAffected = ps.executeUpdate();
            System.out.println("UserDAO: Số dòng bị ảnh hưởng: " + rowsAffected);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("UserDAO: Lỗi khi thêm user");
            e.printStackTrace();
        }
        return false;
    
    }

    public boolean isUsernameExists(String username) {
        System.out.println("UserDAO: Kiểm tra sự tồn tại của username: " + username);
        try {
            String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
            System.out.println("UserDAO: Câu lệnh SQL kiểm tra username: " + sql);
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean exists = rs.getInt(1) > 0;
                System.out.println("UserDAO: Kết quả kiểm tra username tồn tại: " + exists);
                return exists;
            }
        } catch (Exception e) {
            System.out.println("UserDAO: Lỗi khi kiểm tra username");
            e.printStackTrace();
        }
        return false;
    }
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Users ORDER BY created_at DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getString("role")
                );
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }
}
