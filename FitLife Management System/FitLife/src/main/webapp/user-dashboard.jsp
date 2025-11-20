<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Dashboard | FitLife</title>
        <link rel="stylesheet" href="css/style.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    </head>
    <body class="user-body">
        <%@ include file="header.jsp" %>

        <div class="user-dashboard-container">
            <!-- Top Header Bar -->
            <div class="user-top-bar">
                <div class="user-welcome-section">
                    <h1 class="user-title">
                        <i class="fas fa-user-circle"></i>
                        <span>Welcome back, ${sessionScope.session_login}!</span>
                    </h1>
                    <p class="user-subtitle">Track your fitness journey and achieve your goals</p>
                </div>
                <div class="user-actions-section">
                    <a href="bmi-calculator" class="user-action-btn primary">
                        <i class="fas fa-calculator"></i>
                        <span>Calculate BMI</span>
                    </a>
                    <a href="#" class="user-action-btn secondary" onclick="addProgress()">
                        <i class="fas fa-plus"></i>
                        <span>Add Progress</span>
                    </a>
                    <div class="user-time">
                        <i class="fas fa-clock"></i>
                        <span id="currentTime"></span>
                    </div>
                </div>
            </div>

            <!-- Main Content Grid -->
            <div class="user-main-grid">
                <!-- Left Sidebar -->
                <div class="user-sidebar">
                    <div class="sidebar-section">
                        <h3 class="sidebar-title">Quick Stats</h3>
                        <div class="quick-stats">
                            <div class="quick-stat-item">
                                <div class="stat-icon workouts">
                                    <i class="fas fa-dumbbell"></i>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-number">${userWorkouts.size()}</span>
                                    <span class="stat-label">Workouts</span>
                                </div>
                            </div>
                            <div class="quick-stat-item">
                                <div class="stat-icon diets">
                                    <i class="fas fa-apple-alt"></i>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-number">${userDiets.size()}</span>
                                    <span class="stat-label">Meals</span>
                                </div>
                            </div>
                            <div class="quick-stat-item">
                                <div class="stat-icon progress">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-number">${userProgress.size()}</span>
                                    <span class="stat-label">Records</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="sidebar-section">
                        <h3 class="sidebar-title">BMI Status</h3>
                        <div class="bmi-sidebar-card">
                            <c:choose>
                                <c:when test="${not empty latestProgress}">
                                    <div class="bmi-display">
                                        <span class="bmi-value-large"><fmt:formatNumber value="${latestProgress.bmi}" type="number" maxFractionDigits="1" minFractionDigits="1"/></span>
                                        <span class="bmi-category-badge ${latestProgress.bmiCategory}">${latestProgress.bmiCategory}</span>
                                    </div>
                                    <p class="bmi-date">Last updated: ${latestProgress.date}</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="bmi-empty">
                                        <i class="fas fa-chart-line"></i>
                                        <p>No BMI data yet</p>
                                        <a href="bmi-calculator" class="calculate-btn-small">Calculate BMI</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="sidebar-section">
                        <h3 class="sidebar-title">Navigation</h3>
                        <nav class="user-nav">
                            <button class="nav-item active" onclick="showUserTab('overview', event.target)">
                                <i class="fas fa-tachometer-alt"></i>
                                <span>Overview</span>
                            </button>
                            <button class="nav-item" onclick="showUserTab('workouts', event.target)">
                                <i class="fas fa-dumbbell"></i>
                                <span>Workouts</span>
                            </button>
                            <button class="nav-item" onclick="showUserTab('diet', event.target)">
                                <i class="fas fa-apple-alt"></i>
                                <span>Diet</span>
                            </button>
                            <button class="nav-item" onclick="showUserTab('progress', event.target)">
                                <i class="fas fa-chart-line"></i>
                                <span>My Progress</span>
                            </button>
                            <button class="nav-item" onclick="showUserTab('recommendations', event.target)">
                                <i class="fas fa-lightbulb"></i>
                                <span>Recommendations</span>
                            </button>
                            <a href="coach" class="nav-item">
                                <i class="fas fa-user-tie"></i>
                                <span>Coach</span>
                            </a>
                            <button class="nav-item" onclick="showUserTab('cart', event.target)">
                                <i class="fas fa-history"></i>
                                <span>Lịch Sử Mua Hàng</span>
                                <c:if test="${not empty orderHistory && orderHistory.size() > 0}">
                                    <span class="cart-badge">${orderHistory.size()}</span>
                                </c:if>
                            </button>
                            <button class="nav-item" onclick="openChatbot()">
                                <i class="fas fa-robot"></i>
                                <span>AI Assistant</span>
                            </button>
                        </nav>
                    </div>
                </div>

                <!-- Main Content Area -->
                <div class="user-content-area">
                    <!-- Content Header -->
                    <div class="content-header">
                        <h2 id="userContentTitle">Overview</h2>
                        <div class="content-actions">
                            <div class="search-container">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Search..." id="userSearch">
                            </div>
                            <button class="action-btn primary" onclick="addNew()">
                                <i class="fas fa-plus"></i>
                                <span>Add New</span>
                            </button>
                        </div>
                    </div>

                    <!-- Tab Content -->
                    <div class="user-tab-content">
                        <!-- Overview Tab -->
                        <div id="overview" class="user-tab-panel active">
                            <div class="overview-grid">
                                <div class="overview-card">
                                    <div class="card-header">
                                        <h3><i class="fas fa-chart-line"></i> BMI Overview</h3>
                                    </div>
                                    <div class="card-content">
                                        <c:choose>
                                            <c:when test="${not empty latestProgress}">
                                                <div class="bmi-display-main">
                                                    <span class="bmi-value-large"><fmt:formatNumber value="${latestProgress.bmi}" type="number" maxFractionDigits="1" minFractionDigits="1"/></span>
                                                    <span class="bmi-category-badge ${latestProgress.bmiCategory}">${latestProgress.bmiCategory}</span>
                                                </div>
                                                <p class="bmi-date">Last updated: ${latestProgress.date}</p>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bmi-empty-state">
                                                    <i class="fas fa-chart-line"></i>
                                                    <p>No BMI data yet</p>
                                                    <a href="bmi-calculator" class="calculate-btn">Calculate BMI</a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="overview-card">
                                    <div class="card-header">
                                        <h3><i class="fas fa-fire"></i> Recent Activity</h3>
                                    </div>
                                    <div class="card-content">
                                        <div class="activity-summary">
                                            <div class="activity-item">
                                                <i class="fas fa-dumbbell"></i>
                                                <span>${userWorkouts.size()} Workouts</span>
                                            </div>
                                            <div class="activity-item">
                                                <i class="fas fa-apple-alt"></i>
                                                <span>${userDiets.size()} Meals</span>
                                            </div>
                                            <div class="activity-item">
                                                <i class="fas fa-chart-line"></i>
                                                <span>${userProgress.size()} Progress Records</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Workouts Tab -->
                        <!-- Workouts Tab -->
                        <div id="workouts" class="user-tab-panel">
                            <div class="workout-grid">

                                <!-- Workout Card -->
                                <div class="workout-card">
                                    <img src="https://img.freepik.com/free-photo/young-powerful-sportsman-training-push-ups-dark-wall_176420-537.jpg" alt="Push-ups">
                                    <div class="workout-info">
                                        <h3>Push-ups</h3>
                                        <p>Classic upper body exercise for chest, shoulders, and triceps.</p>
                                        <span class="details">20–30 min · 250 cal</span>
                                        <span class="price">150.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(1, 'Push-ups', 150000)">Buy Now</button>
                                    </div>

                                </div>

                                <div class="workout-card">
                                    <img src="https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=1200" alt="Deadlift">
                                    <div class="workout-info">
                                        <h3>Deadlift</h3>
                                        <p>Powerful lift targeting the hamstrings and lower back.</p>
                                        <span class="details">40–60 min · 400 cal</span>
                                        <span class="price">200.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(2, 'Deadlift', 200000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1370779476/photo/shot-of-a-sporty-young-woman-exercising-with-a-barbell-in-a-gym.jpg?s=612x612&w=0&k=20&c=h0-7W838WAKjybISdAsqemZ2mrtek66T5W9t22PfLYw=" alt="Squats">
                                    <div class="workout-info">
                                        <h3>Squats</h3>
                                        <p>Strengthen your legs and glutes with this essential move.</p>
                                        <span class="details">30–45 min · 300 cal</span>
                                        <span class="price">180.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(3, 'Squats', 180000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://t4.ftcdn.net/jpg/00/95/32/41/360_F_95324105_nanCVHMiu7r8B0qSur3k1siBWxacfmII.jpg" alt="Bench Press">
                                    <div class="workout-info">
                                        <h3>Bench Press</h3>
                                        <p>Build strong chest, shoulders, and triceps.</p>
                                        <span class="details">30–45 min · 350 cal</span>
                                        <span class="price">220.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(4, 'Bench Press', 220000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHVsbCUyMHVwfGVufDB8fDB8fHww&fm=jpg&q=60&w=3000" alt="Pull-ups">
                                    <div class="workout-info">
                                        <h3>Pull-ups</h3>
                                        <p>Improve your back and arm strength with this bodyweight exercise.</p>
                                        <span class="details">20–30 min · 200 cal</span>
                                        <span class="price">160.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(5, 'Pull-ups', 160000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/628092382/photo/its-great-for-the-abs.jpg?s=612x612&w=0&k=20&c=YOWaZRjuyh-OG6rv8k0quDNxRwqrxdMm8xgqe37Jmak=" alt="Plank">
                                    <div class="workout-info">
                                        <h3>Plank</h3>
                                        <p>Strengthen your core and stability muscles.</p>
                                        <span class="details">10–20 min · 100 cal</span>
                                        <span class="price">120.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(6, 'Plank', 120000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1177167264/photo/quick-feet-quick-feet.jpg?s=612x612&w=0&k=20&c=a5LSV2m7rXGlwlaBJTewWUYP4pz_v1kKPp1mWT4xwzs=" alt="Jump Rope">
                                    <div class="workout-info">
                                        <h3>Jump Rope</h3>
                                        <p>High-intensity cardio workout improving endurance and coordination.</p>
                                        <span class="details">20–30 min · 300 cal</span>
                                        <span class="price">100.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(7, 'Jump Rope', 100000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1400845852/photo/one-active-mixed-race-man-from-the-back-stretching-arms-and-triceps-by-pulling-elbow-with.jpg?s=612x612&w=0&k=20&c=lErUOPno73j4RaHm82JUdRJ331IzyzrpVCSBBTcDEAM=" alt="Bicep Curls">
                                    <div class="workout-info">
                                        <h3>Bicep Curls</h3>
                                        <p>Target your biceps for definition and strength.</p>
                                        <span class="details">20–30 min · 180 cal</span>
                                        <span class="price">170.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(8, 'Bicep Curls', 170000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://t4.ftcdn.net/jpg/07/83/29/29/360_F_783292909_0fhoXLONr7v4IUr4jP7dF5Yygp9TMwcA.jpg" alt="Leg Press">
                                    <div class="workout-info">
                                        <h3>Leg Press</h3>
                                        <p>Powerful machine exercise focusing on legs and glutes.</p>
                                        <span class="details">30–45 min · 350 cal</span>
                                        <span class="price">190.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(9, 'Leg Press', 190000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1252207646/photo/man-kick-boxer-training-alone-in-gym.jpg?s=612x612&w=0&k=20&c=Odxuklcmny-JxdxpAcvgV8R63yM5vSmZf7Ra0kokcHA=" alt="Sit-ups">
                                    <div class="workout-info">
                                        <h3>Sit-ups</h3>
                                        <p>Strengthen your abs and improve core definition.</p>
                                        <span class="details">15–25 min · 150 cal</span>
                                        <span class="price">130.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(10, 'Sit-ups', 130000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://t4.ftcdn.net/jpg/03/82/37/89/360_F_382378953_Dcp6TQjMlVym6dg24IdsXDZGkrYpORIS.jpg" alt="Bench Dips">
                                    <div class="workout-info">
                                        <h3>Bench Dips</h3>
                                        <p>Great exercise for triceps and shoulder endurance.</p>
                                        <span class="details">15–25 min · 160 cal</span>
                                        <span class="price">150.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(1, 'Push-ups', 150000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://images.pexels.com/photos/421160/pexels-photo-421160.jpeg?cs=srgb&dl=pexels-kinkate-421160.jpg&fm=jpg" alt="Treadmill Run">
                                    <div class="workout-info">
                                        <h3>Treadmill Run</h3>
                                        <p>Boost your stamina and cardiovascular fitness.</p>
                                        <span class="details">30–45 min · 400 cal</span>
                                        <span class="price">180.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(11, 'Treadmill Run', 180000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1857910044/photo/slim-woman-practicing-yoga-in-seated-spinal-twist-pose.jpg?s=612x612&w=0&k=20&c=3OXf6Z-FYOMupHSLGQRXPfAphH_8xXo1hkyFFXppr_4=" alt="Russian Twists">
                                    <div class="workout-info">
                                        <h3>Russian Twists</h3>
                                        <p>Engage your obliques and improve core rotation.</p>
                                        <span class="details">10–20 min · 120 cal</span>
                                        <span class="price">120.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(18, 'Russian Twists', 120000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=1200" alt="Kettlebell Swings">
                                    <div class="workout-info">
                                        <h3>Kettlebell Swings</h3>
                                        <p>Explosive movement for hips and conditioning.</p>
                                        <span class="details">25–35 min · 250 cal</span>
                                        <span class="price">200.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(12, 'Kettlebell Swings', 200000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://www.shutterstock.com/shutterstock/videos/3484828449/thumb/1.jpg?ip=x480" alt="Box Jumps">
                                    <div class="workout-info">
                                        <h3>Box Jumps</h3>
                                        <p>Boost agility and explosive power.</p>
                                        <span class="details">20–30 min · 220 cal</span>
                                        <span class="price">160.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(13, 'Box Jumps', 160000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1310511832/photo/asian-woman-stretching-her-back-in-a-training-gym.jpg?s=612x612&w=0&k=20&c=jP-Zx3_etH4jonLzKzGR4Ii9rQGFD1e9vRDWQrI59NY=" alt="Shoulder Press">
                                    <div class="workout-info">
                                        <h3>Shoulder Press</h3>
                                        <p>Strengthen deltoids and upper body stability.</p>
                                        <span class="details">25–40 min · 270 cal</span>
                                        <span class="price">200.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(14, 'Shoulder Press', 200000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://t3.ftcdn.net/jpg/10/74/32/40/360_F_1074324078_EulScpHBNl4Gc48Mov4NCqJWjQOEVJSe.jpg" alt="Lunges">
                                    <div class="workout-info">
                                        <h3>Lunges</h3>
                                        <p>Target legs and glutes while improving balance.</p>
                                        <span class="details">20–30 min · 180 cal</span>
                                        <span class="price">150.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(1, 'Push-ups', 150000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://media.istockphoto.com/id/1857910044/photo/slim-woman-practicing-yoga-in-seated-spinal-twist-pose.jpg?s=612x612&w=0&k=20&c=3OXf6Z-FYOMupHSLGQRXPfAphH_8xXo1hkyFFXppr_4="" alt="Burpees">
                                    <div class="workout-info">
                                        <h3>Burpees</h3>
                                        <p>Full-body cardio and strength exercise.</p>
                                        <span class="details">15–25 min · 250 cal</span>
                                        <span class="price">170.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(16, 'Burpees', 170000)">Buy Now</button>
                                    </div>
                                </div>

                                <div class="workout-card">
                                    <img src="https://t3.ftcdn.net/jpg/03/16/08/66/360_F_316086673_NfxzsibpOdTYFDQZ9SUsaxQbheBZSHbf.jpg" alt="Mountain Climbers">
                                    <div class="workout-info">
                                        <h3>Mountain Climbers</h3>
                                        <p>Dynamic core and cardio move for endurance.</p>
                                        <span class="details">15–25 min · 200 cal</span>
                                        <span class="price">140.000 VND</span>
                                        <button class="buy-btn" onclick="buyWorkout(17, 'Mountain Climbers', 140000)">Buy Now</button>
                                    </div>
                                </div>

                            </div>
                        </div>


                        <!-- Diet Tab -->
                        <!-- Diet Tab -->
                        <div id="diet" class="user-tab-panel">
                            <h2 class="section-title"><i class="fas fa-apple-alt"></i> My Diet</h2>

                            <div class="diet-grid">

                                <!-- 1 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&fm=jpg" alt="Oatmeal Breakfast">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-bread-slice"></i> Oatmeal with Banana</h3>
                                        <p>Healthy start to your day with oats, banana, and honey drizzle.</p>
                                        <span class="meta">Breakfast · 320 cal</span>
                                    </div>
                                </div>

                                <!-- 2 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Eggs Toast">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-egg"></i> Scrambled Eggs & Toast</h3>
                                        <p>Protein-packed classic breakfast to energize your morning.</p>
                                        <span class="meta">Breakfast · 350 cal</span>
                                    </div>
                                </div>

                                <!-- 3 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/461214/pexels-photo-461214.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Chicken Salad">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-leaf"></i> Grilled Chicken Salad</h3>
                                        <p>Lean protein and greens for a perfect balanced lunch.</p>
                                        <span class="meta">Lunch · 420 cal</span>
                                    </div>
                                </div>

                                <!-- 4 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=500&fm=jpg" alt="Salmon Dish">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-fish"></i> Baked Salmon with Veggies</h3>
                                        <p>Rich in omega-3 and nutrients for a strong and healthy body.</p>
                                        <span class="meta">Lunch · 480 cal</span>
                                    </div>
                                </div>

                                <!-- 5 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Smoothie">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-blender"></i> Mixed Berry Smoothie</h3>
                                        <p>Refreshing drink filled with antioxidants and vitamins.</p>
                                        <span class="meta">Snack · 200 cal</span>
                                    </div>
                                </div>

                                <!-- 6 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Chicken Rice">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-drumstick-bite"></i> Chicken & Rice Bowl</h3>
                                        <p>Classic high-protein meal for gym lovers and athletes.</p>
                                        <span class="meta">Lunch · 550 cal</span>
                                    </div>
                                </div>

                                <!-- 7 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500&fm=jpg" alt="Sushi Platter">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-fish"></i> Sushi Platter</h3>
                                        <p>Delicate balance of rice, fish, and seaweed for a light meal.</p>
                                        <span class="meta">Dinner · 420 cal</span>
                                    </div>
                                </div>

                                <!-- 8 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Fruit Bowl">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-apple-alt"></i> Fresh Fruit Bowl</h3>
                                        <p>Vibrant mix of seasonal fruits — sweet, juicy, and energizing.</p>
                                        <span class="meta">Snack · 180 cal</span>
                                    </div>
                                </div>

                                <!-- 9 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500&fm=jpg" alt="Pasta">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-bowl-food"></i> Whole Grain Pasta</h3>
                                        <p>Balanced carbs and protein for steady energy release.</p>
                                        <span class="meta">Dinner · 520 cal</span>
                                    </div>
                                </div>

                                <!-- 10 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/725991/pexels-photo-725991.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Tunal Meal">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-cow"></i> Grilled Steak</h3>
                                        <p>Juicy beef steak with roasted vegetables and herbs.</p>
                                        <span class="meta">Dinner · 650 cal</span>
                                    </div>
                                </div>

                                <!-- 11 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80" alt="Vegetable Soup">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-carrot"></i> Vegetable Soup</h3>
                                        <p>Light, warm soup packed with vegetables and vitamins.</p>
                                        <span class="meta">Lunch · 210 cal</span>
                                    </div>
                                </div>

                                <!-- 12 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=800&q=80" alt="Chicken Rice Bowl">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-drumstick-bite"></i> Chicken Rice Bowl</h3>
                                        <p>Grilled chicken with steamed rice and greens.</p>
                                        <span class="meta">Lunch · 520 cal</span>
                                    </div>
                                </div>

                                <!-- 13 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Avocado Toast">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-bread-slice"></i> Avocado Toast</h3>
                                        <p>Whole-grain bread topped with mashed avocado and eggs.</p>
                                        <span class="meta">Breakfast · 330 cal</span>
                                    </div>
                                </div>

                                <!-- 14 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Tofu Stir Fry">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-seedling"></i> Tofu Stir Fry</h3>
                                        <p>Tofu sautéed with bell peppers, carrots, and soy sauce.</p>
                                        <span class="meta">Dinner · 400 cal</span>
                                    </div>
                                </div>

                                <!-- 15 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/2619967/pexels-photo-2619967.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Grilled Steak">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-cow"></i> Grilled Steak</h3>
                                        <p>Lean steak served with baked potatoes and broccoli.</p>
                                        <span class="meta">Dinner · 650 cal</span>
                                    </div>
                                </div>

                                <!-- 16 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/2313686/pexels-photo-2313686.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=" alt="Berry Yogurt Bowl">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-ice-cream"></i> Berry Yogurt Bowl</h3>
                                        <p>Greek yogurt topped with fresh berries and granola.</p>
                                        <span class="meta">Snack · 260 cal</span>
                                    </div>
                                </div>

                                <!-- 17 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/539451/pexels-photo-539451.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Shrimp Pasta">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-fish"></i> Shrimp Pasta</h3>
                                        <p>Whole-wheat pasta tossed with shrimp and olive oil.</p>
                                        <span class="meta">Dinner · 530 cal</span>
                                    </div>
                                </div>

                                <!-- 18 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=500&fm=jpg" alt="Protein Smoothie">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-blender"></i> Protein Smoothie</h3>
                                        <p>Banana, whey protein, oats, and almond milk shake.</p>
                                        <span class="meta">Snack · 280 cal</span>
                                    </div>
                                </div>

                                <!-- 19 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80" alt="Caesar Salad">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-leaf"></i> Caesar Salad</h3>
                                        <p>Romaine lettuce, croutons, parmesan, and Caesar dressing.</p>
                                        <span class="meta">Lunch · 340 cal</span>
                                    </div>
                                </div>

                                <!-- 20 -->
                                <div class="diet-card">
                                    <div class="diet-img">
                                        <img src="https://images.pexels.com/photos/803963/pexels-photo-803963.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1&fm=jpg" alt="Sushi Roll">
                                        <span class="price-tag"></span>
                                    </div>
                                    <div class="diet-info">
                                        <h3><i class="fas fa-fish-fins"></i> Sushi Roll</h3>
                                        <p>Fresh salmon and avocado roll served with soy sauce.</p>
                                        <span class="meta">Dinner · 390 cal</span>
                                    </div>
                                </div>



                            </div>
                        </div>



                        <!-- Progress Tab -->
                        <div id="progress" class="user-tab-panel">
                            <div class="data-table-container">
                                <div class="table-header">
                                    <div class="table-title">
                                        <i class="fas fa-chart-line"></i>
                                        <span>My Progress</span>
                                    </div>
                                    <div class="table-filters">
                                        <select class="filter-select">
                                            <option value="all">All Records</option>
                                            <option value="recent">Recent</option>
                                            <option value="this-month">This Month</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="modern-table">
                                    <div class="table-header-row">
                                        <div class="col weight-col">Weight</div>
                                        <div class="col muscle-col">Muscle</div>
                                        <div class="col fat-col">Fat %</div>
                                        <div class="col bmi-col">BMI</div>
                                        <div class="col category-col">Category</div>
                                        <div class="col date-col">Date</div>
                                    </div>

                                    <div class="table-body">
                                        <c:choose>
                                            <c:when test="${not empty userProgress}">
                                                <c:forEach var="progress" items="${userProgress}">
                                                    <div class="table-row">
                                                        <div class="col weight-col">
                                                            <span class="metric-value">${progress.weight} kg</span>
                                                        </div>
                                                        <div class="col muscle-col">
                                                            <span class="metric-value">${progress.muscleMass} kg</span>
                                                        </div>
                                                        <div class="col fat-col">
                                                            <span class="metric-value">${progress.fatPercent}%</span>
                                                        </div>
                                                        <div class="col bmi-col">
                                                            <span class="bmi-value"><fmt:formatNumber value="${progress.bmi}" type="number" maxFractionDigits="1" minFractionDigits="1"/></span>
                                                        </div>
                                                        <div class="col category-col">
                                                            <span class="bmi-badge ${progress.bmiCategory}">${progress.bmiCategory}</span>
                                                        </div>
                                                        <div class="col date-col">
                                                            <span class="date-text">${progress.date}</span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <i class="fas fa-chart-line"></i>
                                                    <h3>No progress records yet</h3>
                                                    <p>Start tracking your progress by adding your first measurement!</p>
                                                    <button class="action-btn primary">Add Progress</button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recommendations Tab -->
                        <div id="recommendations" class="user-tab-panel">
                            <div class="recommendations-container">
                                <div class="recommendations-header">
                                    <h3><i class="fas fa-lightbulb"></i> Personalized Recommendations</h3>
                                    <p>Based on your BMI category and fitness goals</p>
                                </div>

                                <div class="recommendations-grid">
                                    <c:choose>
                                        <c:when test="${not empty workoutRecommendations}">
                                            <div class="recommendation-section">
                                                <h4><i class="fas fa-dumbbell"></i> Workout Recommendations</h4>
                                                <div class="recommendation-list">
                                                    <c:forEach var="recommendation" items="${workoutRecommendations}">
                                                        <div class="recommendation-item">
                                                            <i class="fas fa-check-circle"></i>
                                                            <span>${recommendation}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:when>
                                    </c:choose>

                                    <c:choose>
                                        <c:when test="${not empty dietRecommendations}">
                                            <div class="recommendation-section">
                                                <h4><i class="fas fa-apple-alt"></i> Diet Recommendations</h4>
                                                <div class="recommendation-list">
                                                    <c:forEach var="recommendation" items="${dietRecommendations}">
                                                        <div class="recommendation-item">
                                                            <i class="fas fa-check-circle"></i>
                                                            <span>${recommendation}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:when>
                                    </c:choose>

                                    <c:if test="${empty workoutRecommendations && empty dietRecommendations}">
                                        <div class="empty-state">
                                            <i class="fas fa-lightbulb"></i>
                                            <h3>Calculate BMI for Recommendations</h3>
                                            <p>Get personalized workout and diet recommendations based on your BMI!</p>
                                            <a href="bmi-calculator" class="action-btn primary">Calculate BMI</a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Order History Tab -->
                        <div id="cart" class="user-tab-panel">
                            <div class="cart-container">
                                <div class="cart-header">
                                    <h3><i class="fas fa-history"></i> Lịch Sử Mua Hàng</h3>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty orderHistory && orderHistory.size() > 0}">
                                        <div class="order-history-list">
                                            <c:forEach var="order" items="${orderHistory}">
                                                <div class="order-item">
                                                    <div class="order-item-info">
                                                        <h4>${order.itemName}</h4>
                                                    </div>
                                                    <div class="order-item-price">
                                                        <strong class="price-highlight"><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> VND</strong>
                                                    </div>
                                                    <div class="order-item-date">
                                                        <i class="fas fa-calendar"></i>
                                                        <span><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="order-summary">
                                            <div class="summary-total">
                                                <h3>
                                                    <i class="fas fa-wallet"></i>
                                                    Tổng số tiền đã chi: 
                                                    <span class="total-amount"><fmt:formatNumber value="${totalSpent}" type="number" maxFractionDigits="0"/> VND</span>
                                                </h3>
                                                <p class="summary-note">Tổng cộng ${orderHistory.size()} đơn hàng đã thanh toán</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-history"></i>
                                            <h3>Chưa có lịch sử mua hàng</h3>
                                            <p>Bạn chưa mua workout hoặc thuê coach nào. Hãy bắt đầu mua sắm!</p>
                                            <a href="user-dashboard#workouts" class="action-btn primary">Xem Workouts</a>
                                            <a href="coach" class="action-btn secondary">Xem Coaches</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <!-- AI Chatbot Modal -->
    <div class="chatbot-modal" id="chatbot-modal">
        <div class="chatbot-container">
            <div class="chatbot-header">
                <div class="chatbot-title">
                    <i class="fas fa-robot"></i>
                    <span>AI Fitness Assistant</span>
                </div>
                <button class="chatbot-close" onclick="closeChatbot()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="chatbot-messages" id="chatbot-messages">
                <div class="bot-message">
                    <div class="message-avatar">
                        <i class="fas fa-robot"></i>
                    </div>
                    <div class="message-content">
                        <p>Hello! I'm your AI fitness assistant. I can help you with:</p>
                        <ul>
                            <li>BMI calculations and health advice</li>
                            <li>Workout recommendations</li>
                            <li>Nutrition and diet tips</li>
                            <li>Progress tracking guidance</li>
                            <li>Motivation and goal setting</li>
                        </ul>
                        <p>What can I help you with today?</p>
                    </div>
                </div>
            </div>
            
            <div class="chatbot-input">
                <div class="input-container">
                    <input type="text" id="chatbot-input" placeholder="Ask me anything about fitness..." maxlength="500">
                    <button id="chatbot-send" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
                <div class="typing-indicator" id="typing-indicator" style="display: none;">
                    <i class="fas fa-circle"></i>
                    <i class="fas fa-circle"></i>
                    <i class="fas fa-circle"></i>
                    <span>AI is typing...</span>
                </div>
            </div>
        </div>
    </div>

        <script>
            // Update current time
            function updateTime() {
                const now = new Date();
                const timeString = now.toLocaleTimeString();
                document.getElementById('currentTime').textContent = timeString;
            }

            // Update time every second
            setInterval(updateTime, 1000);
            updateTime();
            
            // Check if we should show cart tab on page load
            window.addEventListener('DOMContentLoaded', function() {
                const urlParams = new URLSearchParams(window.location.search);
                const hash = window.location.hash;
                
                // If coming from cart servlet or hash is #cart, show cart tab
                if (urlParams.get('from') === 'cart' || hash === '#cart') {
                    showUserTab('cart');
                }
            });

            // Tab switching
            function showUserTab(tabName, clickedElement) {
                // Remove active class from all panels and nav items
                document.querySelectorAll('.user-tab-panel').forEach(panel => {
                    panel.classList.remove('active');
                });
                document.querySelectorAll('.nav-item').forEach(item => {
                    item.classList.remove('active');
                });

                // Add active class to selected panel and nav item
                document.getElementById(tabName).classList.add('active');
                if (clickedElement) {
                    clickedElement.closest('.nav-item').classList.add('active');
                } else {
                    // Find the nav item by tab name
                    document.querySelectorAll('.nav-item').forEach(item => {
                        if (item.onclick && item.onclick.toString().includes(tabName) || 
                            item.textContent.includes(tabName === 'cart' ? 'Cart' : tabName)) {
                            item.classList.add('active');
                        }
                    });
                }

                // Update content title
                const titles = {
                    'overview': 'Overview',
                    'workouts': 'My Workouts',
                    'diet': 'My Diet',
                    'progress': 'My Progress',
                    'recommendations': 'Recommendations',
                    'cart': 'Lịch Sử Mua Hàng'
                };
                document.getElementById('userContentTitle').textContent = titles[tabName] || 'Dashboard';
                
                // If cart tab, reload page to get latest cart data
                if (tabName === 'cart') {
                    // Reload the page to get latest cart data from server
                    window.location.href = 'user-dashboard#cart';
                }
            }

            // Global search functionality
            document.getElementById('userSearch').addEventListener('input', function (e) {
                const searchTerm = e.target.value.toLowerCase();
                const activeTab = document.querySelector('.user-tab-panel.active');

                if (activeTab) {
                    const rows = activeTab.querySelectorAll('.table-row');
                    rows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        if (text.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                }
            });

            // Add progress function
            function addProgress() {
                alert('Add Progress functionality would be implemented here');
            }

            // Add new function
            function addNew() {
                const activeTab = document.querySelector('.user-tab-panel.active');
                const tabId = activeTab ? activeTab.id : 'overview';

                switch (tabId) {
                    case 'workouts':
                        alert('Add Workout functionality would be implemented here');
                        break;
                    case 'diet':
                        alert('Add Meal functionality would be implemented here');
                        break;
                    case 'progress':
                        alert('Add Progress functionality would be implemented here');
                        break;
                    default:
                        alert('Add functionality would be implemented here');
                }
            }
            
            // Chatbot functions
            function openChatbot() {
                document.getElementById('chatbot-modal').style.display = 'flex';
                document.getElementById('chatbot-input').focus();
            }
            
            function closeChatbot() {
                document.getElementById('chatbot-modal').style.display = 'none';
            }
            
            function sendMessage() {
                const input = document.getElementById('chatbot-input');
                const message = input.value.trim();
                
                if (!message) return;
                
                // Add user message to chat
                addMessage(message, 'user');
                input.value = '';
                
                // Show typing indicator
                showTypingIndicator();
                
                // Send message to server
                fetch('${pageContext.request.contextPath}/chatbot', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'message=' + encodeURIComponent(message)
                })
                .then(response => response.json())
                .then(data => {
                    hideTypingIndicator();
                    if (data.error) {
                        addMessage('Sorry, I encountered an error. Please try again.', 'bot');
                    } else {
                        addMessage(data.response, 'bot');
                    }
                })
                .catch(error => {
                    hideTypingIndicator();
                    addMessage('Sorry, I\'m having trouble right now. Please try again later.', 'bot');
                });
            }
            
            function addMessage(content, sender) {
                const messagesContainer = document.getElementById('chatbot-messages');
                const messageDiv = document.createElement('div');
                messageDiv.className = sender + '-message';
                
                const avatar = document.createElement('div');
                avatar.className = 'message-avatar';
                avatar.innerHTML = sender === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';
                
                const messageContent = document.createElement('div');
                messageContent.className = 'message-content';
                messageContent.innerHTML = '<p>' + content.replace(/\n/g, '<br>') + '</p>';
                
                messageDiv.appendChild(avatar);
                messageDiv.appendChild(messageContent);
                messagesContainer.appendChild(messageDiv);
                
                // Scroll to bottom
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            function showTypingIndicator() {
                document.getElementById('typing-indicator').style.display = 'flex';
                const messagesContainer = document.getElementById('chatbot-messages');
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            function hideTypingIndicator() {
                document.getElementById('typing-indicator').style.display = 'none';
            }
            
            // Allow Enter key to send message
            document.getElementById('chatbot-input').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });
            
        </script>
<script>
function buyWorkout(id, name, price) {
    if (!id || !name || !price) {
        alert('Thông tin workout không đầy đủ');
        return;
    }
    
    // Chuyển đến trang thanh toán với thông tin workout
    const url = '<%= request.getContextPath() %>/payment.jsp?type=workout&id=' + id + 
                '&name=' + encodeURIComponent(name) + 
                '&price=' + price;
    window.location.href = url;
}
</script>



    </body>
</html>



    </body>
</html>