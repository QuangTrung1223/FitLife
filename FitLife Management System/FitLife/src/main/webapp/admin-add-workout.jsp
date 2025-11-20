<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Bài Tập | Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-workout-diet.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="admin-workout-container">
        <div class="admin-header">
            <h1><i class="fas fa-plus-circle"></i> Thêm Bài Tập Mới</h1>
            <a href="admin-workout" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay Lại
            </a>
        </div>

        <div class="form-container">
            <form action="admin-workout" method="post" class="admin-form">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="workoutName">
                        <i class="fas fa-dumbbell"></i> Tên Bài Tập *
                    </label>
                    <input type="text" id="workoutName" name="workoutName" required placeholder="Nhập tên bài tập">
                </div>

                <div class="form-group">
                    <label for="workoutType">
                        <i class="fas fa-tag"></i> Loại Bài Tập *
                    </label>
                    <select id="workoutType" name="workoutType" required>
                        <option value="">Chọn loại bài tập</option>
                        <option value="Strength">Strength</option>
                        <option value="Cardio">Cardio</option>
                        <option value="Core">Core</option>
                        <option value="Functional">Functional</option>
                        <option value="Plyometric">Plyometric</option>
                    </select>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="duration">
                            <i class="fas fa-clock"></i> Thời Gian (phút) *
                        </label>
                        <input type="number" id="duration" name="duration" required min="1" placeholder="Ví dụ: 30">
                    </div>

                    <div class="form-group">
                        <label for="caloriesBurned">
                            <i class="fas fa-fire"></i> Calories *
                        </label>
                        <input type="number" id="caloriesBurned" name="caloriesBurned" required min="0" placeholder="Ví dụ: 250">
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-align-left"></i> Mô Tả *
                    </label>
                    <textarea id="description" name="description" rows="4" required placeholder="Nhập mô tả bài tập"></textarea>
                </div>

                <div class="form-group">
                    <label for="bmiCategory">
                        <i class="fas fa-chart-bar"></i> BMI Category
                    </label>
                    <select id="bmiCategory" name="bmiCategory">
                        <option value="">Chọn BMI Category (tùy chọn)</option>
                        <option value="Normal">Normal</option>
                        <option value="Underweight">Underweight</option>
                        <option value="Overweight">Overweight</option>
                        <option value="Obese">Obese</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="window.location.href='admin-workout'">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Lưu Bài Tập
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>