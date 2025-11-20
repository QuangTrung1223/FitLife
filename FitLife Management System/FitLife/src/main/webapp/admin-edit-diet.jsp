<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Món Ăn | Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-workout-diet.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="admin-diet-container">
        <div class="admin-header">
            <h1><i class="fas fa-edit"></i> Sửa Món Ăn</h1>
            <a href="admin-diet" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay Lại
            </a>
        </div>

        <div class="form-container">
            <form action="admin-diet" method="post" class="admin-form">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${diet.dietId}">
                
                <div class="form-group">
                    <label for="mealName">
                        <i class="fas fa-utensils"></i> Tên Món Ăn *
                    </label>
                    <input type="text" id="mealName" name="mealName" value="${diet.mealName}" required>
                </div>

                <div class="form-group">
                    <label for="mealType">
                        <i class="fas fa-clock"></i> Loại Bữa Ăn *
                    </label>
                    <select id="mealType" name="mealType" required>
                        <option value="">Chọn loại bữa ăn</option>
                        <option value="Breakfast" ${diet.mealType == 'Breakfast' ? 'selected' : ''}>Breakfast</option>
                        <option value="Lunch" ${diet.mealType == 'Lunch' ? 'selected' : ''}>Lunch</option>
                        <option value="Dinner" ${diet.mealType == 'Dinner' ? 'selected' : ''}>Dinner</option>
                        <option value="Snack" ${diet.mealType == 'Snack' ? 'selected' : ''}>Snack</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="calories">
                        <i class="fas fa-fire"></i> Calories *
                    </label>
                    <input type="number" id="calories" name="calories" value="${diet.calories}" required min="0">
                </div>

                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-align-left"></i> Mô Tả *
                    </label>
                    <textarea id="description" name="description" rows="4" required><c:out value="${diet.description}" /></textarea>
                </div>

                <div class="form-group">
                    <label for="bmiCategory">
                        <i class="fas fa-chart-bar"></i> BMI Category
                    </label>
                    <select id="bmiCategory" name="bmiCategory">
                        <option value="">Chọn BMI Category (tùy chọn)</option>
                        <option value="Normal" ${diet.bmiCategory == 'Normal' ? 'selected' : ''}>Normal</option>
                        <option value="Underweight" ${diet.bmiCategory == 'Underweight' ? 'selected' : ''}>Underweight</option>
                        <option value="Overweight" ${diet.bmiCategory == 'Overweight' ? 'selected' : ''}>Overweight</option>
                        <option value="Obese" ${diet.bmiCategory == 'Obese' ? 'selected' : ''}>Obese</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="window.location.href='admin-diet'">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Cập Nhật Món Ăn
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>