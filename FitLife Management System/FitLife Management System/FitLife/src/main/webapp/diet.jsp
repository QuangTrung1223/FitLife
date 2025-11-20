<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Diet Plans | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <!-- Modern Hero Section -->
    <section class="modern-diet-hero">
        <div class="hero-background">
            <div class="hero-overlay"></div>
        </div>
        <div class="hero-content-modern">
            <div class="hero-text">
                <h1><i class="fas fa-apple-alt"></i> Nourish Your Body</h1>
                <p>Discover healthy diet plans and nutrition tips designed to fuel your fitness journey and support your wellness goals</p>
                <div class="hero-stats">
                    <div class="stat">
                        <span class="stat-number">100+</span>
                        <span class="stat-label">Healthy Recipes</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">24/7</span>
                        <span class="stat-label">Nutrition Support</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">100%</span>
                        <span class="stat-label">Natural</span>
                    </div>
                </div>
                <div class="hero-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.session_login}">
                            <a href="user-dashboard#diet" class="hero-btn primary">
                                <i class="fas fa-utensils"></i>
                                <span>My Diet Plans</span>
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

    <!-- Diet Categories Section -->
    <section class="diet-section-modern">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-leaf"></i> Healthy Meal Plans</h2>
                <p>Explore our nutritious meal categories designed to support your fitness goals</p>
            </div>

            <div class="diet-grid-modern">
                <!-- Breakfast -->
                <div class="meal-card-modern">
                    <div class="meal-image">
                        <img src="https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=300&h=200&fit=crop" 
                             alt="Healthy Breakfast">
                        <div class="meal-overlay">
                            <i class="fas fa-sun"></i>
                        </div>
                    </div>
                    <div class="meal-content">
                        <h3><i class="fas fa-coffee"></i> Breakfast</h3>
                        <p>Start your day with nutritious breakfast options that fuel your morning energy</p>
                        
                        <div class="meal-items">
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-egg"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Protein Omelet</h4>
                                    <p>320 cal • High protein</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-bread-slice"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Oatmeal Bowl</h4>
                                    <p>280 cal • Fiber rich</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-seedling"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Smoothie Bowl</h4>
                                    <p>250 cal • Antioxidants</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lunch -->
                <div class="meal-card-modern">
                    <div class="meal-image">
                        <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop" 
                             alt="Healthy Lunch">
                        <div class="meal-overlay">
                            <i class="fas fa-sun"></i>
                        </div>
                    </div>
                    <div class="meal-content">
                        <h3><i class="fas fa-sun"></i> Lunch</h3>
                        <p>Balanced midday meals to keep you energized throughout the afternoon</p>
                        
                        <div class="meal-items">
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-drumstick-bite"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Grilled Chicken Salad</h4>
                                    <p>450 cal • Lean protein</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-fish"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Salmon Quinoa Bowl</h4>
                                    <p>520 cal • Omega-3</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-seedling"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Vegetable Wrap</h4>
                                    <p>380 cal • Plant-based</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Dinner -->
                <div class="meal-card-modern">
                    <div class="meal-image">
                        <img src="https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=300&h=200&fit=crop" 
                             alt="Healthy Dinner">
                        <div class="meal-overlay">
                            <i class="fas fa-moon"></i>
                        </div>
                    </div>
                    <div class="meal-content">
                        <h3><i class="fas fa-moon"></i> Dinner</h3>
                        <p>Light and nutritious evening meals to support recovery and rest</p>
                        
                        <div class="meal-items">
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-drumstick-bite"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Baked Fish & Vegetables</h4>
                                    <p>420 cal • Low carb</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-seedling"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Veggie Stir Fry</h4>
                                    <p>350 cal • Vitamin rich</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-utensils"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Turkey Lettuce Wraps</h4>
                                    <p>380 cal • Gluten-free</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Snacks -->
                <div class="meal-card-modern">
                    <div class="meal-image">
                        <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop" 
                             alt="Healthy Snacks">
                        <div class="meal-overlay">
                            <i class="fas fa-heart"></i>
                        </div>
                    </div>
                    <div class="meal-content">
                        <h3><i class="fas fa-heart"></i> Healthy Snacks</h3>
                        <p>Nutritious snacks to keep you satisfied between meals</p>
                        
                        <div class="meal-items">
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-apple-alt"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Apple & Almonds</h4>
                                    <p>180 cal • Fiber & protein</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-seedling"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Greek Yogurt Bowl</h4>
                                    <p>150 cal • Probiotics</p>
                                </div>
                            </div>
                            <div class="meal-item">
                                <div class="meal-icon">
                                    <i class="fas fa-carrot"></i>
                                </div>
                                <div class="meal-info">
                                    <h4>Veggie Sticks & Hummus</h4>
                                    <p>120 cal • Vitamins</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Nutrition Tips Section -->
    <section class="nutrition-tips-section">
        <div class="container">
            <div class="section-header-modern">
                <h2><i class="fas fa-lightbulb"></i> Nutrition Tips</h2>
                <p>Expert advice to help you make the best food choices for your health</p>
            </div>

            <div class="tips-grid-modern">
                <div class="tip-card-modern">
                    <div class="tip-icon">
                        <i class="fas fa-tint"></i>
                    </div>
                    <h3>Stay Hydrated</h3>
                    <p>Drink at least 8 glasses of water daily to maintain optimal body function and support your metabolism.</p>
                </div>
                <div class="tip-card-modern">
                    <div class="tip-icon">
                        <i class="fas fa-balance-scale"></i>
                    </div>
                    <h3>Balanced Macros</h3>
                    <p>Include proteins, carbohydrates, and healthy fats in every meal for sustained energy and nutrition.</p>
                </div>
                <div class="tip-card-modern">
                    <div class="tip-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Regular Meals</h3>
                    <p>Eat smaller, frequent meals throughout the day to maintain stable blood sugar and energy levels.</p>
                </div>
                <div class="tip-card-modern">
                    <div class="tip-icon">
                        <i class="fas fa-seedling"></i>
                    </div>
                    <h3>Whole Foods</h3>
                    <p>Choose unprocessed, whole foods rich in nutrients, vitamins, and minerals for better health.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta-section-modern">
        <div class="container">
            <div class="cta-content">
                <h2>Ready to Eat Better?</h2>
                <p>Join FitLife today and get personalized meal plans tailored to your dietary preferences and fitness goals</p>
                <div class="cta-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.session_login}">
                            <a href="user-dashboard#diet" class="cta-btn primary">
                                <i class="fas fa-utensils"></i>
                                <span>View My Diet Plans</span>
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