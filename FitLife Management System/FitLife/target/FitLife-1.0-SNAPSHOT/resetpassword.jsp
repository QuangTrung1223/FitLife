<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khôi phục mật khẩu | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/reset-password.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="reset-password-section">
        <div class="reset-container">
            <div class="reset-header">
                <h2><i class="fas fa-lock"></i> Khôi phục mật khẩu</h2>
                <div class="progress-steps">
                    <div class="step" id="step1" data-active="true">
                        <div class="step-number">1</div>
                        <div class="step-label">Email</div>
                    </div>
                    <div class="step-line"></div>
                    <div class="step" id="step2">
                        <div class="step-number">2</div>
                        <div class="step-label">OTP</div>
                    </div>
                    <div class="step-line"></div>
                    <div class="step" id="step3">
                        <div class="step-number">3</div>
                        <div class="step-label">Mật khẩu mới</div>
                    </div>
                </div>
            </div>

            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="message error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="message success-message">
                    <i class="fas fa-check-circle"></i>
                    <span>${message}</span>
                </div>
            </c:if>

            <!-- Step 1: Email Form -->
            <div class="form-step" id="emailStep" 
                 <c:if test="${not empty sessionScope.otpSent || not empty sessionScope.otpVerified}">style="display: none;"</c:if>>
                <div class="step-content">
                    <div class="step-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h3>Nhập email của bạn</h3>
                    <p class="step-description">Chúng tôi sẽ gửi mã OTP đến email của bạn để xác minh</p>
                    
                    <form action="resetpassword" method="post" id="emailForm" class="reset-form">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i> Email
                            </label>
                            <input id="email" name="email" type="email" 
                                   placeholder="Nhập email của bạn" 
                                   required
                                   autocomplete="email">
                        </div>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-paper-plane"></i>
                            <span>Gửi mã OTP</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Step 2: OTP Form -->
            <div class="form-step" id="otpStep" 
                 <c:if test="${empty sessionScope.otpSent || not empty sessionScope.otpVerified}">style="display: none;"</c:if>
                 <c:if test="${not empty sessionScope.otpSent && empty sessionScope.otpVerified}">style="display: block;"</c:if>>
                <div class="step-content">
                    <div class="step-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <h3>Nhập mã OTP</h3>
                    <p class="step-description">Vui lòng kiểm tra email và nhập mã OTP 6 chữ số đã được gửi đến <strong>${sessionScope.email}</strong></p>
                    
                    <form action="verifyotp" method="post" id="otpForm" class="reset-form">
                        <div class="form-group">
                            <label for="otp">
                                <i class="fas fa-shield-alt"></i> Mã OTP
                            </label>
                            <input id="otp" name="otp" type="text" 
                                   placeholder="Nhập mã OTP 6 chữ số" 
                                   maxlength="6"
                                   pattern="[0-9]{6}"
                                   required
                                   autocomplete="off">
                            <small class="form-hint">Mã OTP gồm 6 chữ số</small>
                        </div>
                        <input type="hidden" name="email" value="${sessionScope.email}">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-check"></i>
                            <span>Xác minh OTP</span>
                        </button>
                        <button type="button" class="btn-resend" onclick="resendOTP()">
                            <i class="fas fa-redo"></i>
                            <span>Gửi lại mã OTP</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Step 3: New Password Form -->
            <div class="form-step" id="passwordStep" 
                 <c:if test="${empty sessionScope.otpVerified}">style="display: none;"</c:if>
                 <c:if test="${not empty sessionScope.otpVerified}">style="display: block;"</c:if>>
                <div class="step-content">
                    <div class="step-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>Đặt mật khẩu mới</h3>
                    <p class="step-description">Vui lòng nhập mật khẩu mới cho tài khoản <strong>${sessionScope.email}</strong></p>
                    
                    <form action="verifyotp" method="post" id="newPasswordForm" class="reset-form">
                        <div class="form-group">
                            <label for="newPassword">
                                <i class="fas fa-lock"></i> Mật khẩu mới
                            </label>
                            <div class="password-input-wrapper">
                                <input id="newPassword" name="newPassword" type="password" 
                                       placeholder="Nhập mật khẩu mới" 
                                       required
                                       autocomplete="new-password">
                                <button type="button" class="toggle-password" onclick="togglePassword('newPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <small class="form-hint">Mật khẩu phải có ít nhất 6 ký tự</small>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">
                                <i class="fas fa-lock"></i> Xác nhận mật khẩu
                            </label>
                            <div class="password-input-wrapper">
                                <input id="confirmPassword" name="confirmPassword" type="password" 
                                       placeholder="Xác nhận mật khẩu" 
                                       required
                                       autocomplete="new-password">
                                <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <input type="hidden" name="email" value="${sessionScope.email}">
                        <input type="hidden" name="action" value="setNewPassword">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i>
                            <span>Cập nhật mật khẩu</span>
                        </button>
                    </form>
                </div>
            </div>

            <div class="reset-footer">
                <p>
                Quay lại? 
                    <a href="login.jsp" class="link-orange">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                    </a>
            </p>
            </div>
        </div>
    </section>

    <script>
        // Initialize steps based on session state
        document.addEventListener('DOMContentLoaded', function() {
            <c:choose>
                <c:when test="${not empty sessionScope.otpSent}">
                    const otpSent = true;
                </c:when>
                <c:otherwise>
                    const otpSent = false;
                </c:otherwise>
            </c:choose>
            
            <c:choose>
                <c:when test="${not empty sessionScope.otpVerified}">
                    const otpVerified = true;
                </c:when>
                <c:otherwise>
                    const otpVerified = false;
                </c:otherwise>
            </c:choose>
            
            updateSteps(otpSent, otpVerified);
        });

        function updateSteps(otpSent, otpVerified) {
            const step1 = document.getElementById('step1');
            const step2 = document.getElementById('step2');
            const step3 = document.getElementById('step3');
            
            const emailStep = document.getElementById('emailStep');
            const otpStep = document.getElementById('otpStep');
            const passwordStep = document.getElementById('passwordStep');
            
            // Reset all steps
            step1.classList.remove('active', 'completed');
            step2.classList.remove('active', 'completed');
            step3.classList.remove('active', 'completed');
            
            emailStep.style.display = 'none';
            otpStep.style.display = 'none';
            passwordStep.style.display = 'none';
            
            if (otpVerified) {
                // Show password step
                step1.classList.add('completed');
                step2.classList.add('completed');
                step3.classList.add('active');
                passwordStep.style.display = 'block';
            } else if (otpSent) {
                // Show OTP step
                step1.classList.add('completed');
                step2.classList.add('active');
                otpStep.style.display = 'block';
            } else {
                // Show email step
                step1.classList.add('active');
                emailStep.style.display = 'block';
            }
        }

        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        function resendOTP() {
            const emailForm = document.getElementById('emailForm');
            if (confirm('Bạn có muốn gửi lại mã OTP không?')) {
                emailForm.submit();
            }
        }

        // Validate password match
        document.getElementById('newPasswordForm')?.addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp! Vui lòng thử lại.');
                return false;
            }
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
        });

        // Auto focus OTP input
        const otpInput = document.getElementById('otp');
        if (otpInput && otpInput.offsetParent !== null) {
            otpInput.focus();
        }

        // Format OTP input to only accept numbers
        document.getElementById('otp')?.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>