package controller;

import dal.OrderDAO;
import dal.OrderHistoryDAO;
import model.Order;
import model.OrderHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập để thanh toán.\"}");
            out.flush();
            return;
        }
        
        try {
            // Lấy thông tin từ request
            String orderType = request.getParameter("orderType"); // "workout", "course", "coach"
            String itemIdStr = request.getParameter("itemId");
            String itemName = request.getParameter("itemName");
            String priceStr = request.getParameter("price");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Validate dữ liệu
            if (orderType == null || itemName == null || priceStr == null || 
                fullName == null || email == null || phone == null || 
                address == null || paymentMethod == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Vui lòng điền đầy đủ thông tin.\"}");
                out.flush();
                return;
            }
            
            // Parse giá
            double price;
            try {
                price = Double.parseDouble(priceStr);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Giá không hợp lệ.\"}");
                out.flush();
                return;
            }
            
            // Parse itemId (có thể null)
            Integer itemId = null;
            if (itemIdStr != null && !itemIdStr.trim().isEmpty()) {
                try {
                    itemId = Integer.parseInt(itemIdStr);
                } catch (NumberFormatException e) {
                    // itemId có thể null, không bắt buộc
                }
            }
            
            // Validate email
            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Email không hợp lệ.\"}");
                out.flush();
                return;
            }
            
            // Validate phone
            if (!phone.matches("^[0-9]{10,11}$")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Số điện thoại không hợp lệ.\"}");
                out.flush();
                return;
            }
            
            // Tạo đơn hàng
            Order order = new Order();
            order.setUserId(userId);
            order.setOrderType(orderType);
            order.setItemId(itemId);
            order.setItemName(itemName);
            order.setPrice(price);
            order.setFullName(fullName);
            order.setEmail(email);
            order.setPhone(phone);
            order.setAddress(address);
            order.setPaymentMethod(paymentMethod);
            order.setStatus("completed");
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            
            // Tạo OrderHistory object để lưu vào lịch sử mua hàng
            OrderHistoryDAO orderHistoryDAO = new OrderHistoryDAO();
            OrderHistory orderHistory = new OrderHistory();
            orderHistory.setUserId(userId);
            
            // Map orderType to itemType cho OrderHistory
            // OrderHistory hỗ trợ: 'course', 'coach', 'workout'
            // orderType có thể là: 'workout', 'course', 'coach'
            String itemType = orderType; // Giữ nguyên vì đã match
            
            // Đảm bảo itemType hợp lệ
            if (!"workout".equals(itemType) && !"course".equals(itemType) && !"coach".equals(itemType)) {
                // Nếu không hợp lệ, mặc định là 'course'
                System.out.println("PaymentServlet: orderType không hợp lệ: " + orderType + ", chuyển sang 'course'");
                itemType = "course";
            }
            
            orderHistory.setItemType(itemType);
            orderHistory.setItemId(itemId != null ? itemId : 0);
            orderHistory.setItemName(itemName);
            orderHistory.setQuantity(1);
            orderHistory.setUnitPrice(price);
            orderHistory.setTotalAmount(price);
            Timestamp now = new Timestamp(System.currentTimeMillis());
            orderHistory.setOrderDate(now);
            orderHistory.setPaymentDate(now);
            orderHistory.setPaymentMethod(paymentMethod);
            orderHistory.setPaymentStatus("paid");
            orderHistory.setOrderStatus("active");
            orderHistory.setStartDate(new Date(System.currentTimeMillis()));
            orderHistory.setNotes("Đơn hàng được tạo từ thanh toán");
            
            // Debug: Log thông tin trước khi lưu
            System.out.println("PaymentServlet: Chuẩn bị lưu OrderHistory:");
            System.out.println("  - user_id: " + userId);
            System.out.println("  - itemType: " + itemType);
            System.out.println("  - itemId: " + (itemId != null ? itemId : 0));
            System.out.println("  - itemName: " + itemName);
            System.out.println("  - price: " + price);
            
            // Lưu vào OrderHistory (bắt buộc)
            boolean historySuccess = false;
            try {
                historySuccess = orderHistoryDAO.addOrder(orderHistory);
                
                // Nếu lưu thất bại và là 'workout', thử lại với 'course' (fallback)
                if (!historySuccess && "workout".equals(itemType)) {
                    System.out.println("PaymentServlet: Lưu 'workout' thất bại, thử lại với 'course' (fallback)...");
                    orderHistory.setItemType("course");
                    historySuccess = orderHistoryDAO.addOrder(orderHistory);
                    if (historySuccess) {
                        System.out.println("PaymentServlet: Đã lưu thành công với itemType = 'course' (fallback)");
                    }
                }
            } catch (Exception e) {
                System.err.println("PaymentServlet: Exception khi gọi orderHistoryDAO.addOrder:");
                System.err.println("PaymentServlet: " + e.getMessage());
                e.printStackTrace();
                
                // Nếu exception và là 'workout', thử lại với 'course'
                if ("workout".equals(itemType)) {
                    try {
                        System.out.println("PaymentServlet: Exception với 'workout', thử lại với 'course' (fallback)...");
                        orderHistory.setItemType("course");
                        historySuccess = orderHistoryDAO.addOrder(orderHistory);
                        if (historySuccess) {
                            System.out.println("PaymentServlet: Đã lưu thành công với itemType = 'course' (fallback sau exception)");
                        }
                    } catch (Exception e2) {
                        System.err.println("PaymentServlet: Vẫn lỗi khi thử fallback với 'course': " + e2.getMessage());
                    }
                }
            }
            
            // Lưu vào Orders (nếu bảng tồn tại)
            boolean orderSuccess = false;
            try {
                OrderDAO orderDAO = new OrderDAO();
                orderSuccess = orderDAO.addOrder(order);
            } catch (Exception e) {
                // Bảng Orders có thể chưa tồn tại, không sao, chỉ cần lưu vào OrderHistory
                System.out.println("PaymentServlet: Bảng Orders chưa tồn tại hoặc có lỗi, chỉ lưu vào OrderHistory: " + e.getMessage());
            }
            
            if (historySuccess) {
                System.out.println("PaymentServlet: Thanh toán thành công cho user_id: " + userId + ", loại: " + orderType + ", tên: " + itemName);
                String message = "Thanh toán thành công! Đơn hàng đã được lưu vào lịch sử mua hàng.";
                out.print("{\"success\": true, \"message\": \"" + message + "\"}");
            } else {
                System.err.println("PaymentServlet: Không thể lưu đơn hàng vào OrderHistory cho user_id: " + userId + ", loại: " + orderType);
                System.err.println("PaymentServlet: itemType: " + itemType + ", itemId: " + (itemId != null ? itemId : "null"));
                System.err.println("PaymentServlet: Có thể do:");
                System.err.println("  1. Bảng OrderHistory chưa hỗ trợ item_type = 'workout'");
                System.err.println("  2. Constraint CHECK chưa được cập nhật");
                System.err.println("  3. Vui lòng chạy script: FIX_DATABASE_COMPLETE.sql hoặc update_orderhistory_schema.sql");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi lưu đơn hàng. Vui lòng kiểm tra database và thử lại. Lỗi có thể do OrderHistory chưa hỗ trợ 'workout'.\"}");
            }
            
        } catch (Exception e) {
            System.err.println("PaymentServlet: Lỗi khi xử lý thanh toán: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra. Vui lòng thử lại.\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}







