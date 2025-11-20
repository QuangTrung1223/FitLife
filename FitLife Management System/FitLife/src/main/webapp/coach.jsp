<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thuê Huấn Luyện Viên | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/coach.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="coach-hero">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <h1><i class="fas fa-user-tie"></i> Thuê Huấn Luyện Viên Riêng</h1>
            <p>Chọn huấn luyện viên phù hợp với mục tiêu và ngân sách của bạn</p>
        </div>
    </section>

    <section class="coaches-section">
        <div class="container">
            <div class="section-header">
                <h2><i class="fas fa-users"></i> Danh Sách Huấn Luyện Viên</h2>
                <p>Tất cả huấn luyện viên đều được chứng nhận và có kinh nghiệm</p>
            </div>

            <div class="coaches-grid">
                <c:choose>
                    <c:when test="${not empty coaches}">
                        <c:forEach var="coach" items="${coaches}">
                            <div class="coach-card">
                                <div class="coach-image-wrapper">
                                    <img src="${coach.imageUrl}" alt="${coach.coachName}" class="coach-image">
                                    <div class="coach-badge">
                                        <i class="fas fa-star"></i>
                                        <fmt:formatNumber value="${coach.rating}" pattern="#.#" minFractionDigits="1" maxFractionDigits="1"/>
                                    </div>
                                </div>
                                <div class="coach-content">
                                    <h3 class="coach-name">${coach.coachName}</h3>
                                    <div class="coach-specialization">
                                        <i class="fas fa-fire"></i>
                                        <span>${coach.specialization}</span>
                                    </div>
                                    <div class="coach-experience">
                                        <i class="fas fa-clock"></i>
                                        <span>${coach.experience}</span>
                                    </div>
                                    <div class="coach-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span>${coach.location}</span>
                                    </div>
                                    <p class="coach-description">${coach.description}</p>
                                    <div class="coach-certifications">
                                        <i class="fas fa-certificate"></i>
                                        <span>${coach.certifications}</span>
                                    </div>
                                    <div class="coach-footer">
                                        <div class="coach-price">
                                            <fmt:formatNumber value="${coach.price}" type="number" maxFractionDigits="0"/> VND
                                        </div>
                                        <button class="btn-hire" onclick="hireCoach(${coach.coachId}, '<c:out value="${coach.coachName}" />', ${coach.price})">
                                            <i class="fas fa-hand-holding-usd"></i>
                                            <span>Thuê Ngay</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-user-tie"></i>
                            <h3>Không có huấn luyện viên nào</h3>
                            <p>Vui lòng quay lại sau!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <script>
        function hireCoach(coachId, coachName, price) {
            // Format price for display
            const formattedPrice = new Intl.NumberFormat('vi-VN').format(price);
            
            if (confirm('Bạn có chắc chắn muốn thuê huấn luyện viên ' + coachName + ' với giá ' + formattedPrice + ' VND không?')) {
                // Redirect to payment page with coach info
                window.location.href = 'payment.jsp?type=coach&id=' + coachId + '&name=' + encodeURIComponent(coachName) + '&price=' + price;
            }
        }
    </script>
</body>
</html>
