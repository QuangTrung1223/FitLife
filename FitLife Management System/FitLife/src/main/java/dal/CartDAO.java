package dal;

import model.Cart;
import util.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {
    
    /**
     * Thêm item vào giỏ hàng
     */
    public boolean addToCart(int userId, String itemType, int itemId, int quantity, double price) {
        try {
            // Kiểm tra xem item đã có trong giỏ hàng chưa (status = 'pending')
            String checkSql = "SELECT cart_id, quantity FROM Cart WHERE user_id = ? AND item_type = ? AND item_id = ? AND status = 'pending'";
            PreparedStatement checkPs = c.prepareStatement(checkSql);
            checkPs.setInt(1, userId);
            checkPs.setString(2, itemType);
            checkPs.setInt(3, itemId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Cập nhật quantity nếu item đã tồn tại
                int existingCartId = rs.getInt("cart_id");
                int existingQuantity = rs.getInt("quantity");
                int newQuantity = existingQuantity + quantity;
                double newTotalAmount = newQuantity * price;
                
                String updateSql = "UPDATE Cart SET quantity = ?, total_amount = ? WHERE cart_id = ?";
                PreparedStatement updatePs = c.prepareStatement(updateSql);
                updatePs.setInt(1, newQuantity);
                updatePs.setDouble(2, newTotalAmount);
                updatePs.setInt(3, existingCartId);
                return updatePs.executeUpdate() > 0;
            } else {
                // Thêm mới item vào giỏ hàng
                double totalAmount = quantity * price;
                String insertSql = "INSERT INTO Cart (user_id, item_type, item_id, quantity, price, total_amount, status, added_date) VALUES (?, ?, ?, ?, ?, ?, 'pending', GETDATE())";
                PreparedStatement insertPs = c.prepareStatement(insertSql);
                insertPs.setInt(1, userId);
                insertPs.setString(2, itemType);
                insertPs.setInt(3, itemId);
                insertPs.setInt(4, quantity);
                insertPs.setDouble(5, price);
                insertPs.setDouble(6, totalAmount);
                return insertPs.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi thêm vào giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy tất cả items trong giỏ hàng của user (status = 'pending')
     */
    public List<Cart> getCartByUserId(int userId) {
        List<Cart> cartItems = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Cart WHERE user_id = ? AND status = 'pending' ORDER BY added_date DESC";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setItemType(rs.getString("item_type"));
                cart.setItemId(rs.getInt("item_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setPrice(rs.getDouble("price"));
                cart.setTotalAmount(rs.getDouble("total_amount"));
                cart.setStatus(rs.getString("status"));
                cart.setAddedDate(rs.getTimestamp("added_date"));
                cartItems.add(cart);
            }
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi lấy giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return cartItems;
    }
    
    /**
     * Cập nhật quantity của item trong giỏ hàng
     */
    public boolean updateCartQuantity(int cartId, int quantity) {
        try {
            // Lấy price hiện tại
            String getPriceSql = "SELECT price FROM Cart WHERE cart_id = ?";
            PreparedStatement getPricePs = c.prepareStatement(getPriceSql);
            getPricePs.setInt(1, cartId);
            ResultSet rs = getPricePs.executeQuery();
            
            if (rs.next()) {
                double price = rs.getDouble("price");
                double totalAmount = quantity * price;
                
                String updateSql = "UPDATE Cart SET quantity = ?, total_amount = ? WHERE cart_id = ?";
                PreparedStatement updatePs = c.prepareStatement(updateSql);
                updatePs.setInt(1, quantity);
                updatePs.setDouble(2, totalAmount);
                updatePs.setInt(3, cartId);
                return updatePs.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi cập nhật quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa item khỏi giỏ hàng
     */
    public boolean removeFromCart(int cartId) {
        try {
            String sql = "DELETE FROM Cart WHERE cart_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi xóa khỏi giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa tất cả items trong giỏ hàng của user
     */
    public boolean clearCart(int userId) {
        try {
            String sql = "DELETE FROM Cart WHERE user_id = ? AND status = 'pending'";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi xóa giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tính tổng tiền trong giỏ hàng
     */
    public double getCartTotal(int userId) {
        try {
            String sql = "SELECT SUM(total_amount) as total FROM Cart WHERE user_id = ? AND status = 'pending'";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi tính tổng tiền: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
    
    /**
     * Lấy cart item theo cart_id
     */
    public Cart getCartById(int cartId) {
        try {
            String sql = "SELECT * FROM Cart WHERE cart_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setItemType(rs.getString("item_type"));
                cart.setItemId(rs.getInt("item_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setPrice(rs.getDouble("price"));
                cart.setTotalAmount(rs.getDouble("total_amount"));
                cart.setStatus(rs.getString("status"));
                cart.setAddedDate(rs.getTimestamp("added_date"));
                return cart;
            }
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi lấy cart item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật status của cart item (khi thanh toán thành công)
     */
    public boolean updateCartStatus(int cartId, String status) {
        try {
            String sql = "UPDATE Cart SET status = ? WHERE cart_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("CartDAO: Lỗi khi cập nhật status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // THÊM VÀO CUỐI CLASS
public boolean addPurchasedItem(Cart cart) {
    String sql = "INSERT INTO Cart (user_id, item_type, item_id, quantity, price, total_amount, added_date, status) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, 'purchased')";
    try (var conn = getConnection();
         var ps = conn.prepareStatement(sql)) {
        ps.setInt(1, cart.getUserId());
        ps.setString(2, cart.getItemType());
        ps.setInt(3, cart.getItemId());
        ps.setInt(4, cart.getQuantity());
        ps.setDouble(5, cart.getPrice());
        ps.setDouble(6, cart.getTotalAmount());
        ps.setTimestamp(7, cart.getAddedDate());
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}

