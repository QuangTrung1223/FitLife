<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                                    <span class="bmi-value-large">${latestProgress.bmi}</span>
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
                        <button class="nav-item active" onclick="showUserTab('overview')">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Overview</span>
                        </button>
                        <button class="nav-item" onclick="showUserTab('workouts')">
                            <i class="fas fa-dumbbell"></i>
                            <span>My Workouts</span>
                        </button>
                        <button class="nav-item" onclick="showUserTab('diet')">
                            <i class="fas fa-apple-alt"></i>
                            <span>My Diet</span>
                        </button>
                        <button class="nav-item" onclick="showUserTab('progress')">
                            <i class="fas fa-chart-line"></i>
                            <span>My Progress</span>
                        </button>
                        <button class="nav-item" onclick="showUserTab('recommendations')">
                            <i class="fas fa-lightbulb"></i>
                            <span>Recommendations</span>
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
                                                <span class="bmi-value-large">${latestProgress.bmi}</span>
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
                    <div id="workouts" class="user-tab-panel">
                        <div class="data-table-container">
                            <div class="table-header">
                                <div class="table-title">
                                    <i class="fas fa-dumbbell"></i>
                                    <span>My Workouts</span>
                                </div>
                                <div class="table-filters">
                                    <select class="filter-select">
                                        <option value="all">All Types</option>
                                        <option value="cardio">Cardio</option>
                                        <option value="strength">Strength</option>
                                        <option value="flexibility">Flexibility</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="modern-table">
                                <div class="table-header-row">
                                    <div class="col workout-col">Workout</div>
                                    <div class="col type-col">Type</div>
                                    <div class="col duration-col">Duration</div>
                                    <div class="col calories-col">Calories</div>
                                    <div class="col date-col">Date</div>
                                </div>
                                
                                <div class="table-body">
                                    <c:choose>
                                        <c:when test="${not empty userWorkouts}">
                                            <c:forEach var="workout" items="${userWorkouts}">
                                                <div class="table-row">
                                                    <div class="col workout-col">
                                                        <div class="workout-cell">
                                                            <div class="workout-icon">
                                                                <i class="fas fa-dumbbell"></i>
                                                            </div>
                                                            <div class="workout-details">
                                                                <span class="workout-name">${workout.workoutName}</span>
                                                                <c:if test="${not empty workout.description}">
                                                                    <span class="workout-desc">${workout.description}</span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col type-col">
                                                        <span class="type-badge">${workout.workoutType}</span>
                                                    </div>
                                                    <div class="col duration-col">
                                                        <span class="duration-value">${workout.duration} min</span>
                                                    </div>
                                                    <div class="col calories-col">
                                                        <span class="calories-value">${workout.caloriesBurned} cal</span>
                                                    </div>
                                                    <div class="col date-col">
                                                        <span class="date-text">${workout.date}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-dumbbell"></i>
                                                <h3>No workouts yet</h3>
                                                <p>Start your fitness journey by adding your first workout!</p>
                                                <button class="action-btn primary">Add Workout</button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Diet Tab -->
                    <div id="diet" class="user-tab-panel">
                        <div class="data-table-container">
                            <div class="table-header">
                                <div class="table-title">
                                    <i class="fas fa-apple-alt"></i>
                                    <span>My Diet</span>
                                </div>
                                <div class="table-filters">
                                    <select class="filter-select">
                                        <option value="all">All Meals</option>
                                        <option value="breakfast">Breakfast</option>
                                        <option value="lunch">Lunch</option>
                                        <option value="dinner">Dinner</option>
                                        <option value="snack">Snack</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="modern-table">
                                <div class="table-header-row">
                                    <div class="col meal-col">Meal</div>
                                    <div class="col type-col">Type</div>
                                    <div class="col calories-col">Calories</div>
                                    <div class="col category-col">BMI Category</div>
                                    <div class="col date-col">Date</div>
                                </div>
                                
                                <div class="table-body">
                                    <c:choose>
                                        <c:when test="${not empty userDiets}">
                                            <c:forEach var="diet" items="${userDiets}">
                                                <div class="table-row">
                                                    <div class="col meal-col">
                                                        <div class="meal-cell">
                                                            <div class="meal-icon">
                                                                <i class="fas fa-apple-alt"></i>
                                                            </div>
                                                            <div class="meal-details">
                                                                <span class="meal-name">${diet.mealName}</span>
                                                                <c:if test="${not empty diet.description}">
                                                                    <span class="meal-desc">${diet.description}</span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col type-col">
                                                        <span class="meal-type-badge">${diet.mealType}</span>
                                                    </div>
                                                    <div class="col calories-col">
                                                        <span class="calories-value">${diet.calories} cal</span>
                                                    </div>
                                                    <div class="col category-col">
                                                        <span class="bmi-badge ${diet.bmiCategory}">${diet.bmiCategory}</span>
                                                    </div>
                                                    <div class="col date-col">
                                                        <span class="date-text">${diet.date}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-apple-alt"></i>
                                                <h3>No meals logged yet</h3>
                                                <p>Start tracking your nutrition by adding your first meal!</p>
                                                <button class="action-btn primary">Add Meal</button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
                                                        <span class="bmi-value">${progress.bmi}</span>
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

        // Tab switching
        function showUserTab(tabName) {
            // Remove active class from all panels and nav items
            document.querySelectorAll('.user-tab-panel').forEach(panel => {
                panel.classList.remove('active');
            });
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Add active class to selected panel and nav item
            document.getElementById(tabName).classList.add('active');
            event.target.closest('.nav-item').classList.add('active');
            
            // Update content title
            const titles = {
                'overview': 'Overview',
                'workouts': 'My Workouts', 
                'diet': 'My Diet',
                'progress': 'My Progress',
                'recommendations': 'Recommendations'
            };
            document.getElementById('userContentTitle').textContent = titles[tabName];
        }

        // Global search functionality
        document.getElementById('userSearch').addEventListener('input', function(e) {
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
            
            switch(tabId) {
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
    </script>
</body>
</html>