package controller;

import Service.EmailService;
import Service.UserService;
import dto.Response;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/resetpassword"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        UserService userService = new UserService();
        Response<User> userResponse = userService.getUserByEmail(email);

        if (userResponse.isSucces()) {
            // Gửi email OTP
            EmailService emailService = new EmailService();
            String otp = emailService.sendOtpEmail(email); // Dòng này có thể là dòng 34 gây lỗi

            if (otp != null) {
                // Lưu OTP và email vào session
                HttpSession session = request.getSession();
                session.setAttribute("otp", otp);
                session.setAttribute("email", email);
                session.setAttribute("otpSent", true);
                request.setAttribute("message", "Mã OTP đã được gửi đến email của bạn!");
                request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể gửi mã OTP. Vui lòng thử lại!");
                request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Email không đúng!");
            request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Reset Password Servlet";
    }
}