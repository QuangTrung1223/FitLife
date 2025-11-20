<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BMI Result | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="result-container">
        <div class="result-header">
            <h1>Kết quả BMI</h1>
            
            <!-- Hiển thị thông báo thành công -->
            <c:if test="${not empty success}">
                <div class="success-message">
                    <p>${success}</p>
                </div>
            </c:if>
        </div>

        <!-- BMI Result Card -->
        <div class="bmi-result-card">
            <h2>Chỉ số BMI của bạn</h2>
            <div class="bmi-score">
                <span class="bmi-number">${bmi}</span>
                <span class="bmi-category-badge ${bmiCategoryEn}">${bmiCategory}</span>
            </div>
            <p class="bmi-description">
                <c:choose>
                    <c:when test="${bmiCategoryEn == 'underweight'}">
                        Bạn đang ở mức thiếu cân. Hãy tăng cường dinh dưỡng và tập luyện để tăng cân một cách lành mạnh.
                    </c:when>
                    <c:when test="${bmiCategoryEn == 'normal'}">
                        Chúc mừng! Bạn có chỉ số BMI bình thường. Hãy duy trì chế độ ăn uống và tập luyện hiện tại.
                    </c:when>
                    <c:when test="${bmiCategoryEn == 'overweight'}">
                        Bạn đang ở mức thừa cân. Hãy điều chỉnh chế độ ăn uống và tăng cường tập luyện để giảm cân.
                    </c:when>
                    <c:when test="${bmiCategoryEn == 'obese'}">
                        Bạn đang ở mức béo phì. Hãy tham khảo ý kiến bác sĩ và chuyên gia dinh dưỡng để có kế hoạch giảm cân an toàn.
                    </c:when>
                </c:choose>
            </p>
        </div>

        <!-- Recommendations -->
        <div class="recommendations-container">
            <!-- Workout Recommendations -->
            <div class="recommendation-section">
                <h3>Khuyến nghị bài tập</h3>
                <div class="recommendation-list">
                    <c:forEach var="rec" items="${workoutRecommendations}">
                        <div class="recommendation-item">
                            <span class="recommendation-icon">💪</span>
                            <p>${rec}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Diet Recommendations -->
            <div class="recommendation-section">
                <h3>Khuyến nghị chế độ ăn</h3>
                <div class="recommendation-list">
                    <c:forEach var="rec" items="${dietRecommendations}">
                        <div class="recommendation-item">
                            <span class="recommendation-icon">🥗</span>
                            <p>${rec}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="user-dashboard" class="btn">Xem Dashboard</a>
            <a href="bmi-calculator" class="btn btn-secondary">Tính lại BMI</a>
        </div>

        <!-- BMI Chart -->
        <div class="bmi-chart">
            <h3>Biểu đồ phân loại BMI</h3>
            <div class="chart-container">
                <div class="chart-bar">
                    <div class="chart-segment underweight" style="width: 18.5%">
                        <span>Thiếu cân</span>
                        <small>< 18.5</small>
                    </div>
                    <div class="chart-segment normal" style="width: 6.4%">
                        <span>Bình thường</span>
                        <small>18.5-24.9</small>
                    </div>
                    <div class="chart-segment overweight" style="width: 5%">
                        <span>Thừa cân</span>
                        <small>25-29.9</small>
                    </div>
                    <div class="chart-segment obese" style="width: 70.1%">
                        <span>Béo phì</span>
                        <small>≥ 30</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
