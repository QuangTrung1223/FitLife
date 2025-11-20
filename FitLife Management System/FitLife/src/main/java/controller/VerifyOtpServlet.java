package controller;

import Service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import utils.PasswordHasher;

@WebServlet(name = "VerifyOtpServlet", urlPatterns = {"/verifyotp"})
public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otpInput = request.getParameter("otp");
        HttpSession session = request.getSession();
        String storedOtp = (String) session.getAttribute("otp");
        String email = request.getParameter("email");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            // Xác minh OTP
            if (otpInput != null && otpInput.equals(storedOtp)) {
                session.setAttribute("otpVerified", true);
                session.removeAttribute("otp");
                session.removeAttribute("otpSent");
                request.setAttribute("message", "Mã OTP đúng! Vui lòng đặt mật khẩu mới.");
                request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Mã OTP không đúng! Vui lòng thử lại.");
                request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
            }
        } else if (action.equals("setNewPassword")) {
            // Đặt mật khẩu mới
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword != null && confirmPassword != null && newPassword.equals(confirmPassword)) {
                UserService userService = new UserService();
                String hashedPassword = PasswordHasher.hashPassword(newPassword); // Mã hóa mật khẩu
                boolean updated = userService.updatePassword(email, hashedPassword);

                if (updated) {
                    // Xóa các thuộc tính session
                    session.removeAttribute("otpVerified");
                    session.removeAttribute("email");

                    // Chuyển hướng về trang đăng nhập
                    session.setAttribute("message", "Khôi phục mật khẩu thành công! Vui lòng đăng nhập lại.");
                    response.sendRedirect("login.jsp");
                } else {
                    request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại!");
                    request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Mật khẩu không khớp hoặc trống!");
                request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Verify OTP Servlet";
    }
}