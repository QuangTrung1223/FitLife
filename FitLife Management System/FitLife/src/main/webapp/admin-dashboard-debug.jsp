<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Debug</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-info { background: #f0f0f0; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .error { background: #ffebee; color: #c62828; }
        .success { background: #e8f5e8; color: #2e7d32; }
    </style>
</head>
<body>
    <h1>Admin Dashboard - Debug Mode</h1>
    
    <div class="debug-info">
        <h3>Session Information:</h3>
        <p><strong>Session Login:</strong> ${sessionScope.session_login}</p>
        <p><strong>User Role:</strong> ${sessionScope.user_role}</p>
        <p><strong>User ID:</strong> ${sessionScope.user_id}</p>
    </div>
    
    <div class="debug-info">
        <h3>Data Statistics:</h3>
        <p><strong>Total Users:</strong> ${totalUsers}</p>
        <p><strong>Total Workouts:</strong> ${totalWorkouts}</p>
        <p><strong>Total Diets:</strong> ${totalDiets}</p>
        <p><strong>Total Progress:</strong> ${totalProgress}</p>
        <p><strong>Online Users Count:</strong> ${onlineUsersCount}</p>
    </div>
    
    <div class="debug-info">
        <h3>Online Users:</h3>
        <c:choose>
            <c:when test="${not empty onlineUsers}">
                <ul>
                    <c:forEach var="user" items="${onlineUsers}">
                        <li>${user}</li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>No users online</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <div class="debug-info">
        <h3>All Users:</h3>
        <c:choose>
            <c:when test="${not empty allUsers}">
                <p>Found ${allUsers.size()} users in database</p>
                <ul>
                    <c:forEach var="user" items="${allUsers}" begin="0" end="4">
                        <li>ID: ${user.userId}, Username: ${user.username}, Role: ${user.role}</li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>No users found in database</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <c:if test="${not empty success}">
        <div class="debug-info success">
            <strong>Success:</strong> ${success}
        </div>
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="debug-info error">
            <strong>Error:</strong> ${error}
        </div>
    </c:if>
    
    <div class="debug-info">
        <h3>Actions:</h3>
        <a href="${pageContext.request.contextPath}/admin-dashboard">Refresh Dashboard</a> |
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</body>
</html>
