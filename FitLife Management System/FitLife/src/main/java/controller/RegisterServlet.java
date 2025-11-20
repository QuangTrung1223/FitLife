/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import Service.UserService;
import dto.RegisterRequest;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Guang Trump
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        // Log thông tin đăng ký
        System.out.println("RegisterServlet: Đang xử lý đăng ký cho username=" + username + ", email=" + email);

        // Thêm kiểm tra lỗi
        if (username == null || username.isEmpty() || password == null || password.isEmpty() || email == null || email.isEmpty()) {
            System.out.println("RegisterServlet: Lỗi - Dữ liệu đầu vào không hợp lệ");
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra và xử lý lỗi đăng ký
        UserService accountService = new UserService();
        RegisterRequest requestRegister = new RegisterRequest(username, password, email);

        boolean isRegistered = false;
        try {
            isRegistered = accountService.register(requestRegister);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (isRegistered) {
            // Đăng ký thành công, chuyển hướng đến trang login.jsp
            response.sendRedirect("login.jsp");
        } else {
            // Đăng ký thất bại, quay lại trang register.jsp với thông báo lỗi
            request.setAttribute("error", "Đăng ký thất bại. Tên đăng nhập có thể đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
   

}
