<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="auth-section">
        <div class="auth-box">
            <h2>Create Your Account</h2>
            <p class="auth-subtitle">Join our fitness community today</p>
            
            <form action="register" method="post">
                <label for="username">Username</label>
                <input id="username" name="username" type="text" placeholder="Enter your username" required>

                <label for="email">Email</label>
                <input id="email" name="email" type="email" placeholder="Enter your email" required>

                <label for="password">Password</label>
                <input id="password" name="password" type="password" placeholder="Create a password" required>

                <button type="submit" class="btn full-btn">Sign Up</button>

                <p class="auth-footer">
                    Already have an account? 
                    <a href="login.jsp" class="link-orange">Login</a>
                </p>
            </form>

            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <p style="color:red; text-align:center;">${error}</p>
            </c:if>
        </div>
    </section>
</body>
</html>
