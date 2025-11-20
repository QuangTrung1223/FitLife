<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Progress Tracking | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <!-- Modern Hero Section -->
    <section class="modern-progress-hero">
        <div class="hero-background">
            <div class="hero-overlay"></div>
        </div>
        <div class="hero-content-modern">
            <div class="hero-text">
                <h1><i class="fas fa-chart-line"></i> Track Your Progress</h1>
                <p>Monitor your fitness journey with detailed progress tracking, BMI calculations, and personalized insights</p>
                <div class="hero-stats">
                    <div class="stat">
                        <span class="stat-number">Real-time</span>
                        <span class="stat-label">Tracking</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">Smart</span>
                        <span class="stat-label">Analytics</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">100%</span>
                        <span class="stat-label">Motivation</span>
                    </div>
                </div>
                <div class="hero-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.session_login}">
                            <a href="user-dashboard#progress" class="hero-btn primary">
                                <i class="fas fa-chart-line"></i>
                                <span>My Progress</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="register.jsp" class="hero-btn primary">
                                <i class="fas fa-user-plus"></i>
                                <span>Join Now</span>
                            </a>
                            <a href="login.jsp" class="hero-btn secondary">
                                <i class="fas fa-sign-in-alt"></i>
                                <span>Login</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>

    <!-- Progress Features Section -->
    <section class="progress-features-section">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-trophy"></i> Track Your Success</h2>
                <p>Comprehensive progress monitoring tools to help you achieve your fitness goals</p>
            </div>

            <div class="features-grid-modern">
                <!-- BMI Tracking -->
                <div class="feature-card-modern">
                    <div class="feature-image">
                        <img src="https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=200&fit=crop" 
                             alt="BMI Tracking">
                        <div class="feature-overlay">
                            <i class="fas fa-calculator"></i>
                        </div>
                    </div>
                    <div class="feature-content">
                        <h3><i class="fas fa-chart-pie"></i> BMI Tracking</h3>
                        <p>Monitor your Body Mass Index with our advanced calculator and get personalized health insights</p>
                        
                        <div class="feature-benefits">
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Automatic BMI calculation</span>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Health category classification</span>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Progress trend analysis</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Weight Management -->
                <div class="feature-card-modern">
                    <div class="feature-image">
                        <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop" 
                             alt="Weight Management">
                        <div class="feature-overlay">
                            <i class="fas fa-weight"></i>
                        </div>
                    </div>
                    <div class="feature-content">
                        <h3><i class="fas fa-weight"></i> Weight Management</h3>
                        <p>Track your weight changes over time and monitor your fitness transformation journey</p>
                        
                        <div class="feature-benefits">
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Daily weight logging</span>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Visual progress charts</span>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Goal setting and tracking</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Body Composition -->
                <div class="feature-card-modern">
                    <div class="feature-image">
                        <img src="https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300&h=200&fit=crop" 
                             alt="Body Composition">
                        <div class="feature-overlay">
                            <i class="fas fa-dumbbell"></i>
                        </div>
                    </div>
                    <div class="feature-content">
                        <h3><i class="fas fa-user-md"></i> Body Composition</h3>
                        <p>Monitor muscle mass, body fat percentage, and overall body composition changes</p>
                        
                        <div class="feature-benefits">
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Muscle mass tracking</span>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Body fat monitoring</span>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-check-circle"></i>
                                <span>Composition analysis</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Sample Progress Data Section -->
    <section class="sample-progress-section">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-chart-bar"></i> Sample Progress Data</h2>
                <p>See how our progress tracking works with sample data from our users</p>
            </div>

            <div class="progress-showcase">
                <div class="progress-chart-modern">
                    <h3><i class="fas fa-chart-line"></i> BMI Progress Timeline</h3>
                    <div class="chart-container">
                        <div class="chart-timeline">
                            <div class="timeline-point">
                                <div class="point-date">Week 1</div>
                                <div class="point-value">25.2</div>
                                <div class="point-category overweight">Overweight</div>
                            </div>
                            <div class="timeline-point">
                                <div class="point-date">Week 4</div>
                                <div class="point-value">24.8</div>
                                <div class="point-category overweight">Overweight</div>
                            </div>
                            <div class="timeline-point">
                                <div class="point-date">Week 8</div>
                                <div class="point-value">24.3</div>
                                <div class="point-category normal">Normal</div>
                            </div>
                            <div class="timeline-point">
                                <div class="point-date">Week 12</div>
                                <div class="point-value">23.9</div>
                                <div class="point-category normal">Normal</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="progress-stats-modern">
                    <h3><i class="fas fa-trophy"></i> Achievement Highlights</h3>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-weight"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">-12 lbs</span>
                                <span class="stat-label">Weight Lost</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-dumbbell"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">+5 lbs</span>
                                <span class="stat-label">Muscle Gained</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">-3.2%</span>
                                <span class="stat-label">Body Fat</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-fire"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">45</span>
                                <span class="stat-label">Workouts</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Success Stories Section -->
    <section class="success-stories-section">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-star"></i> Success Stories</h2>
                <p>Real transformations from our community members</p>
            </div>

            <div class="stories-grid-modern">
                <div class="story-card-modern">
                    <div class="story-image">
                        <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop" 
                             alt="Success Story">
                    </div>
                    <div class="story-content">
                        <h4>Sarah Johnson</h4>
                        <p class="story-timeframe">3 months</p>
                        <div class="story-progress">
                            <p><strong>Weight Loss:</strong> -18 lbs</p>
                            <p><strong>BMI Change:</strong> 27.5 → 23.8</p>
                            <p><strong>Achievement:</strong> Reached healthy BMI range</p>
                        </div>
                        <div class="success-badge">Success Story</div>
                    </div>
                </div>

                <div class="story-card-modern">
                    <div class="story-image">
                        <img src="guangtrump.jpg" 
                             alt="Success Story">
                    </div>
                    <div class="story-content">
                        <h4>Guang Trump</h4>
                        <p class="story-timeframe">6 months</p>
                        <div class="story-progress">
                            <p><strong>Muscle Gain:</strong> +12 lbs</p>
                            <p><strong>Body Fat:</strong> -8%</p>
                            <p><strong>Achievement:</strong> Body recomposition</p>
                        </div>
                        <div class="success-badge">Success Story</div>
                    </div>
                </div>

                <div class="story-card-modern">
                    <div class="story-image">
                        <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop" 
                             alt="Success Story">
                    </div>
                    <div class="story-content">
                        <h4>David Rodriguez</h4>
                        <p class="story-timeframe">4 months</p>
                        <div class="story-progress">
                            <p><strong>Weight Loss:</strong> -25 lbs</p>
                            <p><strong>BMI Change:</strong> 30.2 → 24.1</p>
                            <p><strong>Achievement:</strong> Overweight to normal</p>
                        </div>
                        <div class="success-badge">Success Story</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta-section-modern">
        <div class="container">
            <div class="cta-content">
                <h2>Ready to Start Your Transformation?</h2>
                <p>Join FitLife today and begin tracking your fitness journey with our comprehensive progress monitoring tools</p>
                <div class="cta-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.session_login}">
                            <a href="user-dashboard#progress" class="cta-btn primary">
                                <i class="fas fa-chart-line"></i>
                                <span>View My Progress</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="register.jsp" class="cta-btn primary">
                                <i class="fas fa-rocket"></i>
                                <span>Start Free Trial</span>
                            </a>
                            <a href="login.jsp" class="cta-btn secondary">
                                <i class="fas fa-sign-in-alt"></i>
                                <span>Login to Continue</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>
</body>
</html>