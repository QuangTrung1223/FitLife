package dal;

import static jakarta.persistence.criteria.Predicate.BooleanOperator.AND;
import model.OrderHistory;
import util.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderHistoryDAO extends DBContext {

    /**
     * Thêm đơn hàng vào lịch sử
     */
   /**
 * Thêm đơn hàng vào lịch sử
 */
/**
 * Thêm đơn hàng vào lịch sử
 */
/**
 * Thêm đơn hàng vào lịch sử
 */
public boolean addOrder(OrderHistory order) {
    String sql = "INSERT INTO OrderHistory (" +
                "user_id, item_type, item_id, item_name, " +
                "quantity, unit_price, total_amount, " +
                "payment_date, payment_method, payment_status, " +
                "order_status, start_date, notes" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
        int idx = 1;
        ps.setInt(idx++, order.getUserId());
        ps.setString(idx++, order.getItemType()); // course hoặc coach
        ps.setInt(idx++, order.getItemId());
        ps.setString(idx++, order.getItemName());
        ps.setInt(idx++, order.getQuantity());
        ps.setDouble(idx++, order.getUnitPrice());
        ps.setDouble(idx++, order.getTotalAmount());
        ps.setTimestamp(idx++, order.getPaymentDate());
        ps.setString(idx++, order.getPaymentMethod());
        ps.setString(idx++, order.getPaymentStatus());
        ps.setString(idx++, order.getOrderStatus());
        ps.setDate(idx++, order.getStartDate());
        ps.setString(idx++, order.getNotes());

        int rows = ps.executeUpdate();
        if (rows > 0) {
            // LẤY order_id tự tăng
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    order.setOrderId(rs.getInt(1));
                }
            }
            System.out.println("OrderHistoryDAO: Insert thành công, order_id = " + order.getOrderId());
            return true;
        }
    } catch (SQLException e) {
        System.err.println("OrderHistoryDAO: Lỗi SQL khi thêm đơn hàng:");
        System.err.println("OrderHistoryDAO: SQL State: " + e.getSQLState());
        System.err.println("OrderHistoryDAO: Error Code: " + e.getErrorCode());
        System.err.println("OrderHistoryDAO: Message: " + e.getMessage());
        System.err.println("OrderHistoryDAO: itemType: " + order.getItemType());
        System.err.println("OrderHistoryDAO: itemId: " + order.getItemId());
        e.printStackTrace();
    } catch (Exception e) {
        System.err.println("OrderHistoryDAO: Lỗi không mong đợi khi thêm đơn hàng:");
        System.err.println("OrderHistoryDAO: Message: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}

    /**
     * Lấy tất cả đơn hàng của user
     */
    public List<OrderHistory> getOrdersByUserId(int userId) {
        List<OrderHistory> orders = new ArrayList<>();
        try {
            String sql = "SELECT * FROM OrderHistory WHERE user_id = ? ORDER BY order_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi lấy đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Lấy đơn hàng theo order_id (String UUID)
     */
    public OrderHistory getOrderById(String orderId) { // SỬA: String thay vì int
        try {
            String sql = "SELECT * FROM OrderHistory WHERE order_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, orderId); // setString
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi lấy đơn hàng theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy đơn hàng theo payment_status
     */
    public List<OrderHistory> getOrdersByPaymentStatus(int userId, String paymentStatus) {
        List<OrderHistory> orders = new ArrayList<>();
        try {
            String sql = "SELECT * FROM OrderHistory WHERE user_id = ? AND payment_status = ? ORDER BY order_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, paymentStatus);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi lấy đơn hàng theo payment status: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Lấy đơn hàng theo order_status
     */
    public List<OrderHistory> getOrdersByOrderStatus(int userId, String orderStatus) {
        List<OrderHistory> orders = new ArrayList<>();
        try {
            String sql = "SELECT * FROM OrderHistory WHERE user_id = ? AND order_status = ? ORDER BY order_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, orderStatus);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi lấy đơn hàng theo order status: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Cập nhật payment status (dùng order_id String)
     */
    public boolean updatePaymentStatus(String orderId, String paymentStatus, String paymentMethod) { // SỬA: String
        try {
            String sql = "UPDATE OrderHistory SET payment_status = ?, payment_method = ?, payment_date = CURRENT_TIMESTAMP WHERE order_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, paymentStatus);
            ps.setString(2, paymentMethod);
            ps.setString(3, orderId); // setString
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi cập nhật payment status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật order status (dùng order_id String)
     */
    public boolean updateOrderStatus(String orderId, String orderStatus) { // SỬA: String
        try {
            String sql = "UPDATE OrderHistory SET order_status = ? WHERE order_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, orderStatus);
            ps.setString(2, orderId); // setString
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi cập nhật order status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tính tổng tiền đã mua của user
     */
/**
 * Tính tổng tiền đã mua của user
 */
public double getTotalSpent(int userId) {
    try {
        String sql = "SELECT SUM(total_amount) as total FROM OrderHistory WHERE user_id = ? AND payment_status = 'paid'";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getDouble("total");
        }
    } catch (SQLException e) {
        System.err.println("OrderHistoryDAO: Lỗi khi tính tổng tiền: " + e.getMessage());
        e.printStackTrace();
    }
    return 0.0;
}

    /**
     * Lấy số lượng đơn hàng của user
     */
    public int getOrderCount(int userId) {
        try {
            String sql = "SELECT COUNT(*) as count FROM OrderHistory WHERE user_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi đếm đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy đơn hàng theo item_type
     */
    public List<OrderHistory> getOrdersByItemType(int userId, String itemType) {
        List<OrderHistory> orders = new ArrayList<>();
        try {
            String sql = "SELECT * FROM OrderHistory WHERE user_id = ? AND item_type = ? ORDER BY order_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, itemType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("OrderHistoryDAO: Lỗi khi lấy đơn hàng theo item type: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Helper method để map ResultSet sang OrderHistory object
     */
    private OrderHistory mapResultSetToOrder(ResultSet rs) throws SQLException {
        OrderHistory order = new OrderHistory();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setItemType(rs.getString("item_type"));
        order.setItemId(rs.getInt("item_id"));
        order.setItemName(rs.getString("item_name"));
        order.setQuantity(rs.getInt("quantity"));
        order.setUnitPrice(rs.getDouble("unit_price"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setPaymentDate(rs.getTimestamp("payment_date"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setStartDate(rs.getDate("start_date"));
        order.setEndDate(rs.getDate("end_date"));
        order.setNotes(rs.getString("notes"));
        return order;
    }
}