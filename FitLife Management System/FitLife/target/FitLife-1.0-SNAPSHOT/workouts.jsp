<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Workouts | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <!-- Modern Hero Section -->
    <section class="modern-workouts-hero">
        <div class="hero-background">
            <div class="hero-overlay"></div>
        </div>
        <div class="hero-content-modern">
            <div class="hero-text">
                <h1><i class="fas fa-dumbbell"></i> Transform Your Body</h1>
                <p>Discover amazing workout routines designed to help you achieve your fitness goals and live a healthier life</p>
                <div class="hero-stats">
                    <div class="stat">
                        <span class="stat-number">50+</span>
                        <span class="stat-label">Workout Types</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">10K+</span>
                        <span class="stat-label">Happy Users</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">100%</span>
                        <span class="stat-label">Results</span>
                    </div>
                </div>
                <div class="hero-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.session_login}">
                            <a href="user-dashboard#workouts" class="hero-btn primary">
                                <i class="fas fa-play"></i>
                                <span>My Workouts</span>
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

    <!-- Workout Categories Section -->
    <section class="workouts-section-modern">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-fire"></i> Workout Categories</h2>
                <p>Choose from our variety of workout programs designed for all fitness levels</p>
            </div>

            <div class="workouts-grid-modern">
                <!-- Cardio Workouts -->
                <div class="workout-card-modern">
                    <div class="workout-image">
                        <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop" 
                             alt="Cardio Workouts">
                        <div class="workout-overlay">
                            <i class="fas fa-heartbeat"></i>
                        </div>
                    </div>
                    <div class="workout-content">
                        <h3><i class="fas fa-running"></i> Cardio Workouts</h3>
                        <p>Boost your heart rate and burn calories with our cardio exercises</p>
                        
                        <div class="workout-exercises">
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-running"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Running</h4>
                                    <p>30-45 min • 300-500 cal</p>
                                </div>
                            </div>
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-bicycle"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Cycling</h4>
                                    <p>45-60 min • 400-600 cal</p>
                                </div>
                            </div>
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-link"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Jump Rope</h4>
                                    <p>20-30 min • 250-400 cal</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Strength Training -->
                <div class="workout-card-modern">
                    <div class="workout-image">
                        <img src="https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300&h=200&fit=crop" 
                             alt="Strength Training">
                        <div class="workout-overlay">
                            <i class="fas fa-dumbbell"></i>
                        </div>
                    </div>
                    <div class="workout-content">
                        <h3><i class="fas fa-dumbbell"></i> Strength Training</h3>
                        <p>Build muscle mass and increase your strength with targeted exercises</p>
                        
                        <div class="workout-exercises">
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-hand-paper"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Push-ups</h4>
                                    <p>15-20 min • 150-250 cal</p>
                                </div>
                            </div>
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-weight-hanging"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Weight Lifting</h4>
                                    <p>45-60 min • 300-500 cal</p>
                                </div>
                            </div>
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-walking"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Squats</h4>
                                    <p>20-30 min • 200-350 cal</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Yoga & Flexibility -->
                <div class="workout-card-modern">
                    <div class="workout-image">
                        <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=200&fit=crop" 
                             alt="Yoga & Flexibility">
                        <div class="workout-overlay">
                            <i class="fas fa-om"></i>
                        </div>
                    </div>
                    <div class="workout-content">
                        <h3><i class="fas fa-leaf"></i> Yoga & Flexibility</h3>
                        <p>Improve flexibility, balance, and mental well-being through mindful movement</p>
                        
                        <div class="workout-exercises">
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-om"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Hatha Yoga</h4>
                                    <p>45-60 min • 150-250 cal</p>
                                </div>
                            </div>
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-expand-arrows-alt"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Stretching</h4>
                                    <p>15-30 min • 50-100 cal</p>
                                </div>
                            </div>
                            <div class="exercise-item">
                                <div class="exercise-icon">
                                    <i class="fas fa-balance-scale"></i>
                                </div>
                                <div class="exercise-info">
                                    <h4>Pilates</h4>
                                    <p>30-45 min • 150-250 cal</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Benefits Section -->
    <section class="benefits-section">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-star"></i> Why Choose Our Workouts?</h2>
                <p>Discover the benefits of following our structured workout programs</p>
            </div>

            <div class="benefits-grid">
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-bullseye"></i>
                    </div>
                    <h3>Goal-Oriented</h3>
                    <p>Every workout is designed to help you achieve specific fitness goals</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Time Efficient</h3>
                    <p>Get maximum results in minimum time with our optimized routines</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>Expert Designed</h3>
                    <p>Created by certified fitness professionals and trainers</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h3>Track Progress</h3>
                    <p>Monitor your improvements with our detailed progress tracking</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta-section-modern">
        <div class="container">
            <div class="cta-content">
                <h2>Ready to Transform Your Life?</h2>
                <p>Join thousands of people who have achieved their fitness goals with FitLife</p>
                <div class="cta-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.session_login}">
                            <a href="user-dashboard#workouts" class="cta-btn primary">
                                <i class="fas fa-play"></i>
                                <span>Start My Workouts</span>
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