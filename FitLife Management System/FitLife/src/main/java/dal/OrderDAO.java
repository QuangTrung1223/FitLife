package dal;

import model.Order;
import util.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    // Thêm đơn hàng mới
    public boolean addOrder(Order order) {
        try {
            String sql = "INSERT INTO Orders (user_id, order_type, item_id, item_name, price, full_name, email, phone, address, payment_method, status, order_date) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getOrderType());
            
            if (order.getItemId() != null) {
                ps.setInt(3, order.getItemId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            ps.setString(4, order.getItemName());
            ps.setDouble(5, order.getPrice());
            ps.setString(6, order.getFullName());
            ps.setString(7, order.getEmail());
            ps.setString(8, order.getPhone());
            ps.setString(9, order.getAddress());
            ps.setString(10, order.getPaymentMethod());
            ps.setString(11, order.getStatus() != null ? order.getStatus() : "completed");
            ps.setTimestamp(12, order.getOrderDate() != null ? order.getOrderDate() : new Timestamp(System.currentTimeMillis()));
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("OrderDAO: Đã thêm đơn hàng, rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("OrderDAO: Lỗi khi thêm đơn hàng: " + e.getMessage());
            System.err.println("OrderDAO: SQL State: " + e.getSQLState());
            System.err.println("OrderDAO: Error Code: " + e.getErrorCode());
            if (e.getMessage() != null) {
                if (e.getMessage().contains("Invalid object name 'Orders'") || 
                    e.getMessage().contains("Cannot find the object") ||
                    e.getMessage().contains("Table 'Orders' doesn't exist")) {
                    System.err.println("OrderDAO: BẢNG ORDERS CHƯA ĐƯỢC TẠO TRONG DATABASE!");
                    System.err.println("OrderDAO: Vui lòng chạy script SQL: create_orders_table.sql");
                }
            }
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả đơn hàng của một user
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Orders WHERE user_id = ? ORDER BY order_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getString("order_type"),
                    rs.getObject("item_id") != null ? rs.getInt("item_id") : null,
                    rs.getString("item_name"),
                    rs.getDouble("price"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getString("payment_method"),
                    rs.getString("status"),
                    rs.getTimestamp("order_date")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO: Lỗi khi lấy đơn hàng theo user_id: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    // Lấy đơn hàng theo order_id
    public Order getOrderById(int orderId) {
        try {
            String sql = "SELECT * FROM Orders WHERE order_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getString("order_type"),
                    rs.getObject("item_id") != null ? rs.getInt("item_id") : null,
                    rs.getString("item_name"),
                    rs.getDouble("price"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getString("payment_method"),
                    rs.getString("status"),
                    rs.getTimestamp("order_date")
                );
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO: Lỗi khi lấy đơn hàng theo order_id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Lấy tất cả đơn hàng (cho admin)
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Orders ORDER BY order_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getString("order_type"),
                    rs.getObject("item_id") != null ? rs.getInt("item_id") : null,
                    rs.getString("item_name"),
                    rs.getDouble("price"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getString("payment_method"),
                    rs.getString("status"),
                    rs.getTimestamp("order_date")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO: Lỗi khi lấy tất cả đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
}

