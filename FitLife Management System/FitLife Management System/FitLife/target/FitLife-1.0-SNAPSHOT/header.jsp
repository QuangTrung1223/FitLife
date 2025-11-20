<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header>
    <nav class="navbar">
        <div class="logo">FitLife</div>
        <ul class="nav-links">
            <c:choose>
                <c:when test="${not empty sessionScope.session_login}">
                    <!-- User đã đăng nhập -->
                    <c:choose>
                        <c:when test="${sessionScope.user_role == 'admin'}">
                            <!-- Admin navigation -->
                            <li><a href="admin-dashboard">Admin Dashboard</a></li>
                            <li><a href="admin-dashboard#users">Users</a></li>
                            <li><a href="admin-dashboard#progress">Progress</a></li>
                        </c:when>
                        <c:otherwise>
                            <!-- User navigation -->
                            <li><a href="user-dashboard">Dashboard</a></li>
                            <li><a href="bmi-calculator">BMI Calculator</a></li>
                            <li><a href="user-dashboard#workouts">My Workouts</a></li>
                            <li><a href="user-dashboard#diet">My Diet</a></li>
                            <li><a href="user-dashboard#progress">My Progress</a></li>
                        </c:otherwise>
                    </c:choose>
                    <li><a href="logout" class="logout-btn">Logout</a></li>
                </c:when>
                <c:otherwise>
                    <!-- Chưa đăng nhập -->
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="workouts.jsp">Workouts</a></li>
                    <li><a href="diet.jsp">Diet</a></li>
                    <li><a href="progress.jsp">Progress</a></li>
                    <li><a href="login.jsp">Login</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</header>
