<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Bài Tập | Admin Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-workout-diet.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="admin-workout-container">
        <div class="admin-header">
            <h1><i class="fas fa-dumbbell"></i> Quản Lý Bài Tập - Admin</h1>
            <div class="admin-actions">
                <a href="admin-workout?action=add" class="btn-add">
                    <i class="fas fa-plus"></i> Thêm Bài Tập Mới
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

        <!-- Workout Table -->
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-table"></i> Danh Sách Bài Tập</h2>
                <div class="table-filters">
                    <select class="filter-select" id="type-filter">
                        <option value="all">Tất Cả Loại</option>
                        <option value="Strength">Strength</option>
                        <option value="Cardio">Cardio</option>
                        <option value="Core">Core</option>
                        <option value="Functional">Functional</option>
                        <option value="Plyometric">Plyometric</option>
                    </select>
                </div>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Hình Ảnh</th>
                        <th>Tên Bài Tập</th>
                        <th>Loại</th>
                        <th>Thời Gian (phút)</th>
                        <th>Calories</th>
                        <th>Mô Tả</th>
                        <th>BMI Category</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty workouts}">
                            <c:forEach var="workout" items="${workouts}">
                                <tr class="table-row" data-type="${workout.workoutType}">
                                    <td class="id-cell">${workout.workoutId}</td>
                                    <td class="image-cell">
                                        <img src="https://img.freepik.com/free-photo/young-powerful-sportsman-training-push-ups-dark-wall_176420-537.jpg" 
                                             alt="${workout.workoutName}" class="workout-thumbnail">
                                    </td>
                                    <td class="name-cell">
                                        <strong>${workout.workoutName}</strong>
                                    </td>
                                    <td>
                                        <span class="badge ${workout.workoutType != null ? workout.workoutType.toLowerCase() : ''}">${workout.workoutType}</span>
                                    </td>
                                    <td>${workout.duration}</td>
                                    <td>${workout.caloriesBurned}</td>
                                    <td class="description-cell">${workout.description}</td>
                                    <td>
                                        <c:if test="${not empty workout.bmiCategory}">
                                            <span class="badge">${workout.bmiCategory}</span>
                                        </c:if>
                                        <c:if test="${empty workout.bmiCategory}">
                                            <span class="badge">N/A</span>
                                        </c:if>
                                    </td>
                                    <td class="action-cell">
                                        <a href="admin-workout?action=edit&id=${workout.workoutId}" class="btn-edit">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                        <a href="admin-workout?action=delete&id=${workout.workoutId}" 
                                           class="btn-delete"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa bài tập này?')">
                                            <i class="fas fa-trash"></i> Xóa
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="empty-state">
                                    <i class="fas fa-dumbbell"></i>
                                    <h3>Không có bài tập nào</h3>
                                    <p>Hãy thêm bài tập đầu tiên!</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Filter by type
        document.getElementById('type-filter')?.addEventListener('change', function(e) {
            const selectedType = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.table-row');
            
            rows.forEach(row => {
                const rowType = row.getAttribute('data-type');
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