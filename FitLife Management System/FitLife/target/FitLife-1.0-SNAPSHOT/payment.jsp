<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String type = request.getParameter("type"); // "workout", "course", or "coach"
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String priceParam = request.getParameter("price");
    
    double price = 0;
    if (priceParam != null && !priceParam.isEmpty()) {
        try {
            price = Double.parseDouble(priceParam);
        } catch (NumberFormatException e) {
            price = 0;
        }
    }
    
    // Set default if not provided - đảm bảo luôn có giá trị
    if (type == null || type.trim().isEmpty()) {
        type = "workout";
    }
    if (id == null || id.trim().isEmpty()) {
        id = "";
    }
    if (name == null || name.trim().isEmpty()) {
        name = "Khóa Học Fitness";
    }
    if (price == 0) {
        price = 1500000;
    }
    
    // Lấy thông tin user từ session để tự động điền
    String sessionLogin = (String) session.getAttribute("session_login");
    String userFullName = sessionLogin != null ? sessionLogin : "";
    
    // Xác định loại sản phẩm để hiển thị
    String productTypeName = "";
    String productIcon = "";
    if ("coach".equals(type)) {
        productTypeName = "Huấn luyện viên riêng";
        productIcon = "user-tie";
    } else if ("course".equals(type)) {
        productTypeName = "Khóa học tập luyện";
        productIcon = "graduation-cap";
    } else {
        productTypeName = "Bài tập workout";
        productIcon = "dumbbell";
    }
    
    // Debug: log để kiểm tra
    System.out.println("Payment JSP - type: " + type + ", id: " + id + ", name: " + name + ", price: " + price);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= "coach".equals(type) ? "Thanh Toán Huấn Luyện Viên" : ("course".equals(type) ? "Thanh Toán Khóa Học" : "Thanh Toán Workout") %> | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/payment.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="payment-section">
        <div class="payment-container">
            <div class="payment-header">
                <h1>
                    <i class="fas fa-<%= productIcon %>"></i>
                    <%= "coach".equals(type) ? "Thanh Toán Thuê Huấn Luyện Viên" : ("course".equals(type) ? "Thanh Toán Khóa Học" : "Thanh Toán Workout") %>
                </h1>
            </div>

            <div class="payment-content">
                <div class="payment-form">
                    <div class="form-section">
                        <h2><i class="fas fa-user"></i> Thông Tin Khách Hàng</h2>
                        <form id="paymentForm">
                            <div class="form-group">
                                <label for="fullName">
                                    <i class="fas fa-user"></i> Họ và Tên
                                </label>
                                <input type="text" id="fullName" name="fullName" placeholder="Nhập họ và tên" value="<%= userFullName != null ? userFullName : "" %>" required>
                            </div>

                            <div class="form-group">
                                <label for="email">
                                    <i class="fas fa-envelope"></i> Email
                                </label>
                                <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
                            </div>

                            <div class="form-group">
                                <label for="phone">
                                    <i class="fas fa-phone"></i> Số Điện Thoại
                                </label>
                                <input type="tel" id="phone" name="phone" pattern="[0-9]{10,11}" placeholder="Ví dụ: 0912345678" required>
                            </div>

                            <div class="form-group">
                                <label for="address">
                                    <i class="fas fa-map-marker-alt"></i> Địa Chỉ
                                </label>
                                <input type="text" id="address" name="address" placeholder="Nhập địa chỉ của bạn" required>
                            </div>

                            <div class="form-group">
                                <label for="paymentMethod">
                                    <i class="fas fa-credit-card"></i> Phương Thức Thanh Toán
                                </label>
                                <select id="paymentMethod" name="paymentMethod" required>
                                    <option value="">Chọn phương thức thanh toán</option>
                                    <option value="credit">Thẻ tín dụng / Thẻ ghi nợ</option>
                                    <option value="banking">Chuyển khoản ngân hàng</option>
                                    <option value="cod">Thanh toán khi nhận (COD)</option>
                                    <option value="e-wallet">Ví điện tử (MoMo, ZaloPay)</option>
                                </select>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="order-summary">
                    <div class="summary-header">
                        <h2><i class="fas fa-receipt"></i> Tóm Tắt Đơn Hàng</h2>
                    </div>
                    
                    <div class="summary-content">
                        <div class="summary-item">
                            <div class="item-info">
                                <i class="fas fa-<%= productIcon %>"></i>
                                <div class="item-details">
                                    <h3><%= name %></h3>
                                    <span class="item-type"><%= productTypeName %></span>
                                </div>
                            </div>
                            <div class="item-price">
                                <fmt:formatNumber value="<%= price %>" type="number" maxFractionDigits="0"/> VND
                            </div>
                        </div>

                        <div class="summary-divider"></div>

                        <div class="summary-total">
                            <div class="total-label">
                                <span>Tổng cộng:</span>
                            </div>
                            <div class="total-price">
                                <fmt:formatNumber value="<%= price %>" type="number" maxFractionDigits="0"/> VND
                            </div>
                        </div>
                    </div>

                    <div class="payment-actions">
                        <button type="button" class="btn-back" onclick="window.history.back()">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay Lại</span>
                        </button>
                        <button type="button" class="btn-pay" onclick="processPayment()">
                            <i class="fas fa-lock"></i>
                            <span>Thanh Toán</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon success">
                <i class="fas fa-check-circle"></i>
            </div>
            <h3>Mua Hàng Thành Công!</h3>
            <p>Bạn đã mua thành công <strong><%= name %></strong></p>
            <p>Số tiền: <strong><fmt:formatNumber value="<%= price %>" type="number" maxFractionDigits="0"/> VND</strong></p>
            <p class="modal-message">Đơn hàng đã được lưu vào lịch sử mua hàng. Bạn có thể xem lại trong User Dashboard.</p>
            <button class="modal-close" onclick="redirectToDashboard()">
                <i class="fas fa-home"></i>
                <span>Về Trang Chủ</span>
            </button>
        </div>
    </div>
<script>
    function processPayment() {
        // === LẤY DỮ LIỆU FORM ===
        const fullName = document.getElementById('fullName').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const address = document.getElementById('address').value.trim();
        const paymentMethod = document.getElementById('paymentMethod').value;

        if (!fullName || !email || !phone || !address || !paymentMethod) {
            alert("Vui lòng điền đầy đủ thông tin!");
            return;
        }

        // === LẤY DỮ LIỆU TỪ JSP ===
        let type = '<%= type != null ? type.trim() : "" %>';
        let id = '<%= id != null ? id.trim() : "" %>';
        let name = '<%= name != null ? name.replace("'", "\\'") : "" %>';
        let price = <%= price %>;

        if (!type || type === 'null') type = 'workout';
        if (!id || id === 'null') id = '1';
        if (!name || name === 'null') name = 'Khóa Học Fitness';
        if (!price || isNaN(price)) price = 1500000;

        // === TẠO FORM DATA ===
        const formData = new URLSearchParams();
        formData.append('orderType', type);
        formData.append('itemId', id);
        formData.append('itemName', name);
        formData.append('price', price);
        formData.append('fullName', fullName);
        formData.append('email', email);
        formData.append('phone', phone);
        formData.append('address', address);
        formData.append('paymentMethod', paymentMethod);

        const url = '<%= request.getContextPath() %>/payment';

        // === GỬI BẰNG POST ===
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData.toString()
        })
        .then(r => {
            if (!r.ok) {
                return r.text().then(text => {
                    try {
                        return JSON.parse(text);
                    } catch (e) {
                        throw new Error('Lỗi mạng: ' + r.status);
                    }
                });
            }
            return r.json();
        })
        .then(data => {
            if (data.success) {
                // Hiển thị modal thành công
                document.getElementById('successModal').classList.add('active');
                // Tự động chuyển về dashboard sau 3 giây
                setTimeout(() => {
                    window.location.href = '<%= request.getContextPath() %>/user-dashboard';
                }, 3000);
            } else {
                alert('Lỗi: ' + (data.message || 'Có lỗi xảy ra'));
            }
        })
        .catch(err => {
            console.error('Payment error:', err);
            alert('Lỗi hệ thống: ' + err.message);
        });
    }

    function redirectToDashboard() {
        window.location.href = '<%= request.getContextPath() %>/user-dashboard';
    }

    document.getElementById('successModal').addEventListener('click', function(e) {
        if (e.target === this) this.classList.remove('active');
    });
</script>
    </body>
</html>