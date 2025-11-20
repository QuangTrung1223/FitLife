package controller;

import dal.OrderHistoryDAO;
import model.OrderHistory;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy lịch sử mua hàng từ OrderHistory (chỉ các đơn đã thanh toán)
        OrderHistoryDAO orderDAO = new OrderHistoryDAO();
        List<OrderHistory> orderHistory = orderDAO.getOrdersByPaymentStatus(userId, "paid");
        
        // Tính tổng tiền đã chi
        double totalSpent = orderDAO.getTotalSpent(userId);
        
        request.setAttribute("orderHistory", orderHistory);
        request.setAttribute("totalSpent", totalSpent);
        
        request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to GET để hiển thị lịch sử mua hàng
        doGet(request, response);
    }
}







