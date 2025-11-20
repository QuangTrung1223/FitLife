package controller;

import dal.UserDAO;
import model.User;
import utils.PasswordHasher;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/add-user", "/admin/update-user", "/admin/delete-user"})
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding for Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        String userRole = (String) session.getAttribute("user_role");
        
        // Admin check
        if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String servletPath = request.getServletPath();
        System.out.println("[AdminUserServlet] POST request to: " + servletPath);
        UserDAO userDAO = new UserDAO();
        
        try {
            switch (servletPath) {
                case "/admin/add-user":
                    addUser(request, response, userDAO, session);
                    break;
                case "/admin/update-user":
                    updateUser(request, response, userDAO, session);
                    break;
                case "/admin/delete-user":
                    deleteUser(request, response, userDAO, session);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        }
    }
    
    private void addUser(HttpServletRequest request, HttpServletResponse response, UserDAO userDAO, HttpSession session) 
            throws ServletException, IOException {
        
        System.out.println("[AdminUserServlet] Adding new user...");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String gender = request.getParameter("gender");
        
        System.out.println("[AdminUserServlet] Username: " + username);
        System.out.println("[AdminUserServlet] Email: " + email);
        System.out.println("[AdminUserServlet] Role: " + role);
        
        // Validate required fields
        if (username == null || username.trim().isEmpty()) {
            session.setAttribute("error", "Username không được để trống!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("error", "Email không được để trống!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            session.setAttribute("error", "Password không được để trống!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        if (role == null || role.trim().isEmpty()) {
            role = "user"; // Default role
        }
        
        if (gender == null || gender.trim().isEmpty()) {
            gender = "Male"; // Default gender
        }
        
        // Handle nullable numeric fields
        int age = 0;
        double height = 0.0;
        double weight = 0.0;
        
        try {
            String ageStr = request.getParameter("age");
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                age = Integer.parseInt(ageStr);
            }
        } catch (NumberFormatException e) {
            age = 0;
        }
        
        try {
            String heightStr = request.getParameter("height");
            if (heightStr != null && !heightStr.trim().isEmpty()) {
                height = Double.parseDouble(heightStr);
            }
        } catch (NumberFormatException e) {
            height = 0.0;
        }
        
        try {
            String weightStr = request.getParameter("weight");
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                weight = Double.parseDouble(weightStr);
            }
        } catch (NumberFormatException e) {
            weight = 0.0;
        }
        
        // Validate unique username/email
        if (userDAO.getUserByUsername(username) != null) {
            session.setAttribute("error", "Username đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        if (userDAO.getUserByEmail(email) != null) {
            session.setAttribute("error", "Email đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        // Create new user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(PasswordHasher.hashPassword(password));
        newUser.setRole(role);
        newUser.setStatus("active");
        newUser.setGender(gender);
        newUser.setAge(age);
        newUser.setHeight(height);
        newUser.setWeight(weight);
        // Note: joinDate không được sử dụng vì database dùng created_at (tự động)
        
        boolean success = userDAO.addUser(newUser);
        
        System.out.println("[AdminUserServlet] Add user result: " + success);
        if (success) {
            session.setAttribute("success", "Thêm user thành công!");
            System.out.println("[AdminUserServlet] User added successfully");
        } else {
            session.setAttribute("error", "Thêm user thất bại!");
            System.out.println("[AdminUserServlet] Failed to add user");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response, UserDAO userDAO, HttpSession session) 
            throws ServletException, IOException {
        
        System.out.println("[AdminUserServlet] Updating user...");
        
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            System.out.println("[AdminUserServlet] Invalid user ID");
            session.setAttribute("error", "Invalid user ID!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String gender = request.getParameter("gender");
        
        System.out.println("[AdminUserServlet] User ID: " + id);
        System.out.println("[AdminUserServlet] Username: " + username);
        System.out.println("[AdminUserServlet] Email: " + email);
        System.out.println("[AdminUserServlet] Role: " + role);
        System.out.println("[AdminUserServlet] Status: " + status);
        System.out.println("[AdminUserServlet] Gender: " + gender);
        System.out.println("[AdminUserServlet] Will update password: " + (password != null && !password.trim().isEmpty()));
        
        // Validate and parse numeric fields with proper validation
        int age = 0;
        double height = 0.0;
        double weight = 0.0;
        
        // Validate and parse age
        try {
            String ageStr = request.getParameter("age");
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                age = Integer.parseInt(ageStr);
                if (age < 1 || age > 120) {
                    session.setAttribute("error", "Age must be between 1-120 years!");
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                    return;
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid age value!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        // Validate and parse height
        try {
            String heightStr = request.getParameter("height");
            if (heightStr != null && !heightStr.trim().isEmpty()) {
                height = Double.parseDouble(heightStr);
                if (height < 50 || height > 300) {
                    session.setAttribute("error", "Height must be between 50-300 cm!");
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                    return;
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid height value!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        // Validate and parse weight
        try {
            String weightStr = request.getParameter("weight");
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                weight = Double.parseDouble(weightStr);
                if (weight < 10 || weight > 500) {
                    session.setAttribute("error", "Weight must be between 10-500 kg!");
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                    return;
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid weight value!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        System.out.println("[AdminUserServlet] Age: " + age);
        System.out.println("[AdminUserServlet] Height: " + height + " cm");
        System.out.println("[AdminUserServlet] Weight: " + weight + " kg");

        User existingUser = userDAO.getUserById(id);
        if (existingUser == null) {
            session.setAttribute("error", "Không tìm thấy user!");
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }

        // Check if username or email is being changed and if it's unique
        if (!existingUser.getUsername().equals(username)) {
            if (userDAO.getUserByUsername(username) != null) {
                session.setAttribute("error", "Username đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                return;
            }
        }
        
        if (!existingUser.getEmail().equals(email)) {
            if (userDAO.getUserByEmail(email) != null) {
                session.setAttribute("error", "Email đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                return;
            }
        }
        
        existingUser.setUsername(username);
        existingUser.setEmail(email);
        if (password != null && !password.trim().isEmpty()) {
            existingUser.setPassword(PasswordHasher.hashPassword(password));
            System.out.println("[AdminUserServlet] Password updated");
        } else {
            System.out.println("[AdminUserServlet] Password not updated (left blank)");
        }
        existingUser.setRole(role);
        existingUser.setStatus(status);
        existingUser.setGender(gender);
        existingUser.setAge(age);
        existingUser.setHeight(height);
        existingUser.setWeight(weight);

        boolean success = userDAO.updateUser(existingUser);
        
        System.out.println("[AdminUserServlet] Update user result: " + success);
        if (success) {
            session.setAttribute("success", "Cập nhật user thành công!");
            System.out.println("[AdminUserServlet] User updated successfully");
        } else {
            session.setAttribute("error", "Cập nhật user thất bại!");
            System.out.println("[AdminUserServlet] Failed to update user");
        }
        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, UserDAO userDAO, HttpSession session) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (userDAO.deleteUser(id)) {
            session.setAttribute("success", "Xóa user thành công!");
        } else {
            session.setAttribute("error", "Xóa user thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle GET requests (especially for delete via link)
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        String userRole = (String) session.getAttribute("user_role");
        
        // Admin check
        if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String servletPath = request.getServletPath();
        UserDAO userDAO = new UserDAO();
        
        try {
            switch (servletPath) {
                case "/admin/delete-user":
                    deleteUser(request, response, userDAO, session);
                    break;
                default:
                    // For other GET requests, redirect to dashboard
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        }
    }
}
