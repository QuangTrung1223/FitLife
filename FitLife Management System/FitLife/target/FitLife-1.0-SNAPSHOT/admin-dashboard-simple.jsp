<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Simple</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background-color: #f5f5f5; 
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        .header { 
            background: #ff6b35; 
            color: white; 
            padding: 20px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
        }
        .stats { 
            display: flex; 
            flex-wrap: wrap; 
            gap: 15px; 
            margin-bottom: 30px; 
        }
        .stat-card { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 8px; 
            border-left: 4px solid #ff6b35; 
            flex: 1; 
            min-width: 200px; 
        }
        .stat-number { 
            font-size: 2em; 
            font-weight: bold; 
            color: #ff6b35; 
        }
        .stat-label { 
            color: #666; 
            margin-top: 5px; 
        }
        .section { 
            margin-bottom: 30px; 
        }
        .section h3 { 
            color: #333; 
            border-bottom: 2px solid #ff6b35; 
            padding-bottom: 10px; 
        }
        .user-list { 
            max-height: 300px; 
            overflow-y: auto; 
        }
        .user-item { 
            padding: 10px; 
            border-bottom: 1px solid #eee; 
            display: flex; 
            justify-content: space-between; 
        }
        .user-item:hover { 
            background: #f8f9fa; 
        }
        .online-indicator { 
            color: #28a745; 
            font-weight: bold; 
        }
        .actions { 
            margin-top: 20px; 
        }
        .btn { 
            background: #ff6b35; 
            color: white; 
            padding: 10px 20px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            margin-right: 10px; 
            text-decoration: none; 
            display: inline-block; 
        }
        .btn:hover { 
            background: #e55a2b; 
        }
        .error { 
            background: #ffebee; 
            color: #c62828; 
            padding: 15px; 
            border-radius: 5px; 
            margin-bottom: 20px; 
        }
        .success { 
            background: #e8f5e8; 
            color: #2e7d32; 
            padding: 15px; 
            border-radius: 5px; 
            margin-bottom: 20px; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-shield"></i> Admin Dashboard</h1>
            <p>Welcome, ${sessionScope.session_login} (${sessionScope.user_role})</p>
        </div>

        <c:if test="${not empty success}">
            <div class="success">
                <strong>Success:</strong> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>

        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number online-indicator">${onlineUsersCount}</div>
                <div class="stat-label">Online Now</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalWorkouts}</div>
                <div class="stat-label">Workouts</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalDiets}</div>
                <div class="stat-label">Diets</div>
            </div>
        </div>

        <div class="section">
            <h3>Online Users</h3>
            <c:choose>
                <c:when test="${not empty onlineUsers}">
                    <div class="user-list">
                        <c:forEach var="user" items="${onlineUsers}">
                            <div class="user-item">
                                <span>${user}</span>
                                <span class="online-indicator">● Online</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>No users currently online</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="section">
            <h3>All Users (First 10)</h3>
            <c:choose>
                <c:when test="${not empty allUsers}">
                    <div class="user-list">
                        <c:forEach var="user" items="${allUsers}" begin="0" end="9">
                            <div class="user-item">
                                <span>${user.username} (${user.role})</span>
                                <span>ID: ${user.userId}</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>No users found in database</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn">Refresh Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin-dashboard-debug" class="btn">Debug Mode</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn">Logout</a>
        </div>
    </div>
</body>
</html>
