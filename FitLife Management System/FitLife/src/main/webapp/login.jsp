<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="auth-section">
        <div class="auth-box">
            <h2>Chào mừng bạn trở lại</h2>
            <p class="auth-subtitle">Đăng nhập để tiếp tục hành trình thể thao của bạn</p>
            
            <form action="login" method="post">
                <label for="username">Tên đăng nhập hoặc Email</label>
                <input id="username" name="username" type="text" placeholder="Nhập tên đăng nhập hoặc email" required>

                <label for="password">Mật khẩu</label>
                <input id="password" name="password" type="password" placeholder="Nhập mật khẩu" required>

                <button type="submit" class="btn full-btn">Đăng nhập</button>

                <p class="auth-footer">
                    Chưa có tài khoản? 
                    <a href="register.jsp" class="link-orange">Đăng ký</a>
                </p>
                <!-- Thêm liên kết Quên mật khẩu -->
                <p class="auth-footer">
                    Quên mật khẩu? 
                    <a href="resetpassword.jsp" class="link-orange">Khôi phục mật khẩu</a>
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