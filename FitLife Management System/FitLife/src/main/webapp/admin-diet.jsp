<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Món Ăn | Admin Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-workout-diet.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="admin-diet-container">
        <div class="admin-header">
            <h1><i class="fas fa-utensils"></i> Quản Lý Món Ăn - Admin</h1>
            <div class="admin-actions">
                <a href="admin-diet?action=add" class="btn-add">
                    <i class="fas fa-plus"></i> Thêm Món Ăn Mới
                </a>
                <a href="admin-dashboard" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Về Dashboard
                </a>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="success-message">
                <i class="fas fa-check-circle"></i> ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <!-- Diet Table -->
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-table"></i> Danh Sách Món Ăn</h2>
                <div class="table-filters">
                    <select class="filter-select" id="meal-type-filter">
                        <option value="all">Tất Cả Loại</option>
                        <option value="Breakfast">Breakfast</option>
                        <option value="Lunch">Lunch</option>
                        <option value="Dinner">Dinner</option>
                        <option value="Snack">Snack</option>
                    </select>
                </div>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Hình Ảnh</th>
                        <th>Tên Món Ăn</th>
                        <th>Loại Bữa</th>
                        <th>Calories</th>
                        <th>Mô Tả</th>
                        <th>BMI Category</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty diets}">
                            <c:forEach var="diet" items="${diets}">
                                <tr class="table-row" data-meal-type="${diet.mealType}">
                                    <td class="id-cell">${diet.dietId}</td>
                                    <td class="image-cell">
                                        <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&fm=jpg" 
                                             alt="${diet.mealName}" class="diet-thumbnail">
                                    </td>
                                    <td class="name-cell">
                                        <strong>${diet.mealName}</strong>
                                    </td>
                                    <td>
                                        <span class="badge ${diet.mealType != null ? diet.mealType.toLowerCase() : ''}">${diet.mealType}</span>
                                    </td>
                                    <td>${diet.calories}</td>
                                    <td class="description-cell">${diet.description}</td>
                                    <td>
                                        <c:if test="${not empty diet.bmiCategory}">
                                            <span class="badge">${diet.bmiCategory}</span>
                                        </c:if>
                                        <c:if test="${empty diet.bmiCategory}">
                                            <span class="badge">N/A</span>
                                        </c:if>
                                    </td>
                                    <td class="action-cell">
                                        <a href="admin-diet?action=edit&id=${diet.dietId}" class="btn-edit">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                        <a href="admin-diet?action=delete&id=${diet.dietId}" 
                                           class="btn-delete"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa món ăn này?')">
                                            <i class="fas fa-trash"></i> Xóa
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="empty-state">
                                    <i class="fas fa-utensils"></i>
                                    <h3>Không có món ăn nào</h3>
                                    <p>Hãy thêm món ăn đầu tiên!</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Filter by meal type
        document.getElementById('meal-type-filter')?.addEventListener('change', function(e) {
            const selectedType = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.table-row');
            
            rows.forEach(row => {
                const rowType = row.getAttribute('data-meal-type');
                if (selectedType === 'all' || (rowType && rowType.toLowerCase() === selectedType)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>