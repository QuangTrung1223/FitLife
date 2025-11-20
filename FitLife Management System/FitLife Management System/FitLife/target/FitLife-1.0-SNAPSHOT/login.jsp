<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="auth-section">
        <div class="auth-box">
            <h2>Welcome Back</h2>
            <p class="auth-subtitle">Log in to continue your fitness journey</p>
            
            <form action="login" method="post">
                <label for="username">Username or Email</label>
                <input id="username" name="username" type="text" placeholder="Enter your username or email" required>

                <label for="password">Password</label>
                <input id="password" name="password" type="password" placeholder="Enter your password" required>

                <button type="submit" class="btn full-btn">Login</button>

                <p class="auth-footer">
                    Don’t have an account? 
                    <a href="register.jsp" class="link-orange">Sign Up</a>
                </p>
            </form>

            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <p style="color:red; text-align:center;">${error}</p>
            </c:if>

            <!-- Hiển thị thông báo sau khi đăng ký thành công -->
            <c:if test="${not empty sessionScope.registerMessage}">
                <p style="color:green; text-align:center;">${sessionScope.registerMessage}</p>
                <% session.removeAttribute("registerMessage"); %>
            </c:if>
        </div>
    </section>
</body>
</html>
