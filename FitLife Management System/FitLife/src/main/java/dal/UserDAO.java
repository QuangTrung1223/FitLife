package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;
import util.DBContext;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO extends DBContext {

    // Dùng được cho cả plain text lẫn bcrypt
    public User checkLogin(String username, String password) {
        try {
            String sql = "SELECT * FROM Users WHERE username = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String stored = rs.getString("password");

                boolean valid = false;
                try {
                    if (stored.startsWith("$2a$") || stored.startsWith("$2b$")) {
                        valid = BCrypt.checkpw(password, stored);
                    } else {
                        valid = password.equals(stored);
                    }
                } catch (IllegalArgumentException e) {
                    System.out.println("[UserDAO] Password không phải bcrypt, kiểm tra thường.");
                    valid = password.equals(stored);
                }

                if (valid) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            stored,
                            rs.getString("email"),
                            rs.getString("role")
                    );
                }
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
            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("role")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(String username, String password, String email) {
        System.out.println("UserDAO: Thêm user với username=" + username + ", email=" + email);
        try {
            String sql = "INSERT INTO Users (username, password, email, role) VALUES (?, ?, ?, 'user')";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            int rows = ps.executeUpdate();
            System.out.println("UserDAO: Đã thêm " + rows + " user vào database.");
            return rows > 0;
        } catch (Exception e) {
            System.out.println("UserDAO: Lỗi khi thêm user.");
            e.printStackTrace();
        }
        return false;
    }

    public boolean isUsernameExists(String username) {
        try {
            String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Users ORDER BY user_id DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role") != null ? rs.getString("role") : "user");
                
                // Handle status - may not exist in database, default to "active"
                try {
                    String status = rs.getString("status");
                    u.setStatus(status != null ? status : "active");
                } catch (Exception e) {
                    u.setStatus("active");
                }
                
                // Handle nullable fields
                try {
                    u.setGender(rs.getString("gender"));
                } catch (Exception e) {
                    u.setGender(null);
                }
                
                try {
                    int age = rs.getInt("age");
                    u.setAge(rs.wasNull() ? 0 : age);
                } catch (Exception e) {
                    u.setAge(0);
                }
                
                try {
                    double height = rs.getDouble("height");
                    u.setHeight(rs.wasNull() ? 0.0 : height);
                } catch (Exception e) {
                    u.setHeight(0.0);
                }
                
                try {
                    double weight = rs.getDouble("weight");
                    u.setWeight(rs.wasNull() ? 0.0 : weight);
                } catch (Exception e) {
                    u.setWeight(0.0);
                }
                
                // Handle join_date - try created_at if join_date doesn't exist
                try {
                    java.sql.Date joinDate = rs.getDate("join_date");
                    if (joinDate == null) {
                        // Try created_at instead
                        java.sql.Timestamp created_at = rs.getTimestamp("created_at");
                        if (created_at != null) {
                            u.setJoinDate(new java.sql.Date(created_at.getTime()));
                        } else {
                            u.setJoinDate(new java.sql.Date(System.currentTimeMillis()));
                        }
                    } else {
                        u.setJoinDate(joinDate);
                    }
                } catch (Exception e) {
                    // If join_date column doesn't exist, try created_at
                    try {
                        java.sql.Timestamp created_at = rs.getTimestamp("created_at");
                        if (created_at != null) {
                            u.setJoinDate(new java.sql.Date(created_at.getTime()));
                        } else {
                            u.setJoinDate(new java.sql.Date(System.currentTimeMillis()));
                        }
                    } catch (Exception e2) {
                        u.setJoinDate(new java.sql.Date(System.currentTimeMillis()));
                    }
                }
                
                list.add(u);
            }
            System.out.println("UserDAO: Lấy được " + list.size() + " user từ database.");
        } catch (Exception e) {
            System.err.println("UserDAO: Lỗi khi lấy danh sách users: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Thêm phương thức để lấy người dùng theo email
    public User getUserByEmail(String email) {
        try {
            String sql = "SELECT * FROM Users WHERE email = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("role")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
 public boolean updatePassword(String email, String hashedPassword) {
        try {
            String sql = "UPDATE Users SET password = ? WHERE email = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            System.out.println("Đã cập nhật mật khẩu cho email: " + email + ", rows affected: " + rows);
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi cập nhật mật khẩu: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Thêm phương thức để lấy user theo username
    public User getUserByUsername(String username) {
        try {
            String sql = "SELECT * FROM Users WHERE username = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setGender(rs.getString("gender"));
                u.setAge(rs.getInt("age"));
                u.setHeight(rs.getDouble("height"));
                u.setWeight(rs.getDouble("weight"));
                u.setJoinDate(rs.getDate("join_date"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm phương thức để lấy user theo ID
    public User getUserById(int userId) {
        try {
            String sql = "SELECT * FROM Users WHERE user_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setGender(rs.getString("gender"));
                u.setAge(rs.getInt("age"));
                u.setHeight(rs.getDouble("height"));
                u.setWeight(rs.getDouble("weight"));
                u.setJoinDate(rs.getDate("join_date"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm phương thức để thêm user mới
    public boolean addUser(User user) {
        try {
            // Kiểm tra xem cột status có tồn tại không, nếu không thì không insert status
            // Database có cột created_at, không có join_date, nên không insert join_date
            String sql = "INSERT INTO Users (username, password, email, role, status, gender, age, height, weight) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole() != null ? user.getRole() : "user");
            
            // Handle status - nếu null thì dùng "active"
            String status = user.getStatus();
            if (status == null || status.trim().isEmpty()) {
                status = "active";
            }
            ps.setString(5, status);
            
            // Handle nullable fields
            String gender = user.getGender();
            if (gender == null || gender.trim().isEmpty()) {
                ps.setNull(6, java.sql.Types.VARCHAR);
            } else {
                ps.setString(6, gender);
            }
            
            int age = user.getAge();
            if (age > 0) {
                ps.setInt(7, age);
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            
            double height = user.getHeight();
            if (height > 0) {
                ps.setDouble(8, height);
            } else {
                ps.setNull(8, java.sql.Types.DOUBLE);
            }
            
            double weight = user.getWeight();
            if (weight > 0) {
                ps.setDouble(9, weight);
            } else {
                ps.setNull(9, java.sql.Types.DOUBLE);
            }
            
            int rows = ps.executeUpdate();
            System.out.println("UserDAO: Đã thêm user mới, rows affected: " + rows);
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi thêm user: " + e.getMessage());
            System.err.println("SQL State: " + (e instanceof java.sql.SQLException ? ((java.sql.SQLException) e).getSQLState() : "N/A"));
            System.err.println("Error Code: " + (e instanceof java.sql.SQLException ? ((java.sql.SQLException) e).getErrorCode() : "N/A"));
            e.printStackTrace();
            return false;
        }
    }
    
    // Thêm phương thức để cập nhật user
    public boolean updateUser(User user) {
        try {
            String sql = "UPDATE Users SET username = ?, password = ?, email = ?, role = ?, status = ?, gender = ?, age = ?, height = ?, weight = ? WHERE user_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus());
            ps.setString(6, user.getGender());
            ps.setInt(7, user.getAge());
            ps.setDouble(8, user.getHeight());
            ps.setDouble(9, user.getWeight());
            ps.setInt(10, user.getId());
            
            int rows = ps.executeUpdate();
            System.out.println("UserDAO: Đã cập nhật user ID " + user.getId() + ", rows affected: " + rows);
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi cập nhật user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Thêm phương thức để xóa user
    public boolean deleteUser(int userId) {
        try {
            String sql = "DELETE FROM Users WHERE user_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            
            int rows = ps.executeUpdate();
            System.out.println("UserDAO: Đã xóa user ID " + userId + ", rows affected: " + rows);
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi xóa user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
