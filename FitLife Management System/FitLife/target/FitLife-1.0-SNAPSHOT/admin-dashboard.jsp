<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - User Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Fix scrolling issue for user management table */
            html, body {
                overflow-x: hidden;
                overflow-y: auto;
                height: auto;
                min-height: 100vh;
            }
            
            .admin-body {
                overflow-y: auto;
                height: auto;
                min-height: 100vh;
            }
            
            .admin-dashboard-container {
                min-height: 100vh;
                height: auto;
                overflow: visible;
            }
            
            .admin-content-area {
                overflow-y: visible;
                overflow-x: hidden;
                min-height: 600px;
                padding-bottom: 50px;
            }
            
            .data-table-container {
                overflow: visible;
                width: 100%;
            }
            
            /* Ensure table is scrollable horizontally if needed */
            .data-table-container .modern-table {
                width: 100%;
                table-layout: auto;
            }
            
            /* Make sure the table wrapper doesn't restrict scrolling */
            .table-wrapper, .table-container {
                overflow: visible;
                width: 100%;
            }
        </style>
    </head>
    <body class="admin-body">
        <div class="admin-dashboard-container">
            <!-- Top Header Bar -->
            <header class="admin-top-bar">
                <div class="admin-welcome-section">
                    <h1 class="admin-title">
                        <i class="fas fa-user-shield"></i> Admin Dashboard
                    </h1>
                    <p class="admin-subtitle">Manage users, workouts, diets, and progress</p>
                </div>
                <div class="admin-actions-section">
                    <button class="admin-action-btn refresh">
                        <i class="fas fa-sync-alt"></i> Refresh Data
                    </button>
                    <button class="admin-action-btn export">
                        <i class="fas fa-file-export"></i> Export Report
                    </button>
                    <span class="admin-time">
                        <i class="fas fa-clock"></i> <span id="current-time"></span>
                    </span>
                </div>
            </header>

            <!-- Main Grid Layout -->
            <div class="admin-main-grid">
                <!-- Sidebar -->
                <aside class="admin-sidebar">
                    <div class="sidebar-section">
                        <h3 class="sidebar-title">Quick Stats</h3>
                        <div class="quick-stats">
                            <div class="quick-stat-item">
                                <span class="stat-icon users"><i class="fas fa-users"></i></span>
                                <div class="stat-info">
                                    <span class="stat-number">${totalUsers}</span>
                                    <span class="stat-label">Total Users</span>
                                </div>
                            </div>
                            <div class="quick-stat-item online-users">
                                <span class="stat-icon online"><i class="fas fa-circle"></i></span>
                                <div class="stat-info">
                                    <span class="stat-number">${onlineUsersCount}</span>
                                    <span class="stat-label">Online Now</span>
                                </div>
                            </div>
                            <div class="quick-stat-item">
                                <span class="stat-icon workouts"><i class="fas fa-dumbbell"></i></span>
                                <div class="stat-info">
                                    <span class="stat-number">${totalWorkouts}</span>
                                    <span class="stat-label">Total Workouts</span>
                                </div>
                            </div>
                            <div class="quick-stat-item">
                                <span class="stat-icon diets"><i class="fas fa-utensils"></i></span>
                                <div class="stat-info">
                                    <span class="stat-number">${totalDiets}</span>
                                    <span class="stat-label">Total Diets</span>
                                </div>
                            </div>
                            <div class="quick-stat-item">
                                <span class="stat-icon progress"><i class="fas fa-chart-line"></i></span>
                                <div class="stat-info">
                                    <span class="stat-number">${totalProgress}</span>
                                    <span class="stat-label">Progress Records</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Online Users Section -->
                    <div class="sidebar-section">
                        <h3 class="sidebar-title">Online Users</h3>
                        <div class="online-users-section">
                            <div class="online-count">
                                <i class="fas fa-circle online-indicator"></i>
                                <span class="online-text">${onlineUsersCount} users online</span>
                            </div>
                            <div class="online-users-list">
                                <c:choose>
                                    <c:when test="${not empty onlineUsers}">
                                        <c:forEach var="onlineUser" items="${onlineUsers}">
                                            <div class="online-user-item">
                                                <i class="fas fa-user-circle"></i>
                                                <span class="online-username">${onlineUser}</span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-online-users">
                                            <i class="fas fa-user-slash"></i>
                                            <span>No users online</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="sidebar-section">
                        <h3 class="sidebar-title">Navigation</h3>
                        <div class="admin-nav">
                            <button class="nav-item active" data-tab="users"><i class="fas fa-users"></i> User Management</button>
                            <a href="${pageContext.request.contextPath}/admin-workout" class="nav-item">
                                <i class="fas fa-dumbbell"></i> Workouts
                            </a>
                            <a href="${pageContext.request.contextPath}/admin-diet" class="nav-item">
                                <i class="fas fa-utensils"></i> Diets
                            </a>
                            <button class="nav-item" data-tab="progress"><i class="fas fa-chart-line"></i> Progress</button>
                            <a href="admin/progress-tracking" class="nav-item progress-tracking">
                                <i class="fas fa-chart-bar"></i> Progress Tracking
                            </a>
                        </div>
                    </div>
                </aside>

                <!-- Content Area -->
                <main class="admin-content-area">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="success-message">
                            <i class="fas fa-check-circle"></i> ${sessionScope.success}
                            <c:remove var="success" scope="session" />
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                            <c:remove var="error" scope="session" />
                        </div>
                    </c:if>

                    <!-- Debug Info -->
                    <div style="background: #f0f0f0; padding: 10px; margin: 10px 0; border-radius: 5px;">
                        <strong>Debug Info:</strong><br>
                        Total Users: ${totalUsers}<br>
                        Users List Size: ${allUsers.size()}<br>
                        Users Empty: ${empty allUsers}<br>
                        <c:if test="${not empty allUsers}">
                            First User: ${allUsers[0].username} (ID: ${allUsers[0].userId})
                        </c:if>
                    </div>

                    <div class="content-header">
                        <h2 id="content-title"><i class="fas fa-users"></i> User Management</h2>
                        <div class="content-actions">
                            <div class="search-container">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Search users..." id="user-search">
                            </div>
                            <!-- Thêm nút Add User -->
                            <button class="admin-action-btn add" onclick="openAddUserModal()">
                                <i class="fas fa-plus"></i> Add User
                            </button>
                            <!-- Thêm nút Add Sample Data -->
                            <button class="admin-action-btn sample" onclick="addSampleData()">
                                <i class="fas fa-database"></i> Add Sample Data
                            </button>

                        </div>
                    </div>

                    <!-- User Data Table -->
                    <div class="data-table-container" id="users-tab">
                        <div class="table-header">
                            <div class="table-title">
                                <i class="fas fa-table"></i> All Users
                            </div>
                            <div class="table-filters">
                                <select class="filter-select" id="role-filter">
                                    <option value="all">All Roles</option>
                                    <option value="user">User</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>
                        </div>
                        <table class="modern-table">
                            <thead>
                                <tr class="table-header-row">
                                    <th class="col">User</th>
                                    <th class="col">ID</th>
                                    <th class="col">Email</th>
                                    <th class="col">Role</th>
                                    <th class="col">Join Date</th>
                                    <th class="col">Status</th>
                                    <!-- Thêm cột mới cho Gender, Age, Height, Weight -->
                                    <th class="col">Gender</th>
                                    <th class="col">Age</th>
                                    <th class="col">Height</th>
                                    <th class="col">Weight</th>
                                    <th class="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="table-body">
                                <c:choose>
                                    <c:when test="${not empty allUsers}">
                                        <c:forEach var="user" items="${allUsers}">
                                            <tr class="table-row">
                                                <td class="col user-cell">
                                                    <div class="user-avatar-small">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div class="user-details">
                                                        <span class="username">${user.username}</span>
                                                    </div>
                                                </td>
                                                <td class="col id-text">${user.userId}</td>
                                                <td class="col email-text">${user.email}</td>
                                                <td class="col">
                                                    <c:if test="${not empty user.role}">
                                                        <span class="role-badge ${user.role.toLowerCase()}">${user.role}</span>
                                                    </c:if>
                                                    <c:if test="${empty user.role}">
                                                        <span class="role-badge user">user</span>
                                                    </c:if>
                                                </td>
                                                <td class="col date-text">
                                                    <c:choose>
                                                        <c:when test="${not empty user.joinDate}">
                                                            <fmt:formatDate value="${user.joinDate}" pattern="dd-MM-yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>N/A</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col">
                                                    <c:if test="${not empty user.status}">
                                                        <span class="role-badge ${user.status.toLowerCase()}">${user.status}</span>
                                                    </c:if>
                                                    <c:if test="${empty user.status}">
                                                        <span class="role-badge active">active</span>
                                                    </c:if>
                                                </td>
                                                <!-- Thêm td mới cho Gender, Age, Height, Weight -->
                                                <td class="col">${user.gender != null ? user.gender : 'N/A'}</td>
                                                <td class="col">${user.age > 0 ? user.age : 'N/A'}</td>
                                                <td class="col">${user.height > 0 ? user.height : 'N/A'}</td>
                                                <td class="col">${user.weight > 0 ? user.weight : 'N/A'}</td>
                                                <td class="col action-buttons">
                                                    <button class="action-btn view" onclick="viewUser('${user.userId}')">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="action-btn edit" onclick="editUser('${user.userId}')">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="action-btn delete" onclick="deleteUser('${user.userId}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="11" class="empty-state"> <!-- Điều chỉnh colspan từ 7 thành 11 -->
                                                <i class="fas fa-users-slash"></i>
                                                <h3>No Users Found</h3>
                                                <p>It looks like there are no users to display. Try adding a new user or adjusting your filters.</p>

                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Workouts Tab -->
                    <div class="data-table-container" id="workouts-tab" style="display: none;">
                        <div class="content-header">
                            <h2 id="content-title-workouts"><i class="fas fa-dumbbell"></i> Workout Management</h2>
                            <div class="content-actions">
                                <div class="search-container">
                                    <i class="fas fa-search"></i>
                                    <input type="text" placeholder="Search workouts..." id="workout-search">
                                </div>
                                <button class="admin-action-btn add" onclick="openAddWorkoutModal()">
                                    <i class="fas fa-plus"></i> Add Workout
                                </button>
                            </div>
                        </div>
                        <div class="table-header">
                            <div class="table-title">
                                <i class="fas fa-dumbbell"></i> All Workouts
                            </div>
                            <div class="table-filters">
                                <select class="filter-select" id="workout-type-filter">
                                    <option value="all">All Types</option>
                                    <option value="Strength">Strength</option>
                                    <option value="Cardio">Cardio</option>
                                    <option value="Core">Core</option>
                                    <option value="Functional">Functional</option>
                                    <option value="Plyometric">Plyometric</option>
                                </select>
                            </div>
                        </div>

                        <!-- Workout Cards Grid -->
                        <div class="workout-cards-grid">
                            <c:choose>
                                <c:when test="${not empty allWorkouts}">
                                    <c:forEach var="workout" items="${allWorkouts}">
                                        <div class="workout-card" data-type="${workout.workoutType}">
                                            <div class="workout-header">
                                                <h3 class="workout-name">${workout.workoutName}</h3>
                                                <span class="workout-type-badge ${workout.workoutType.toLowerCase()}">${workout.workoutType}</span>
                                            </div>
                                            <div class="workout-body">
                                                <p class="workout-description">${workout.description}</p>
                                                <div class="workout-stats">
                                                    <div class="stat-item">
                                                        <i class="fas fa-clock"></i>
                                                        <span>${workout.duration} min</span>
                                                    </div>
                                                    <div class="stat-item">
                                                        <i class="fas fa-fire"></i>
                                                        <span>${workout.caloriesBurned} cal</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="workout-actions">
                                                <button class="action-btn view" onclick="viewWorkout('${workout.workoutId}')">
                                                    <i class="fas fa-eye"></i> View
                                                </button>
                                                <button class="action-btn edit" onclick="editWorkout('${workout.workoutId}')">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button class="action-btn delete" onclick="deleteWorkout('${workout.workoutId}')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-dumbbell"></i>
                                        <h3>No Workouts Found</h3>
                                        <p>It looks like there are no workouts to display.</p>
                                        <button class="admin-action-btn add" onclick="addSampleData()">
                                            <i class="fas fa-plus"></i> Add Sample Workouts
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Diets Tab -->
                    <div class="data-table-container" id="diets-tab" style="display: none;">
                        <div class="content-header">
                            <h2 id="content-title-diets"><i class="fas fa-utensils"></i> Diet Management</h2>
                            <div class="content-actions">
                                <div class="search-container">
                                    <i class="fas fa-search"></i>
                                    <input type="text" placeholder="Search diets..." id="diet-search">
                                </div>
                                <button class="admin-action-btn add" onclick="openAddDietModal()">
                                    <i class="fas fa-plus"></i> Add Diet
                                </button>
                            </div>
                        </div>
                        <div class="table-header">
                            <div class="table-title">
                                <i class="fas fa-utensils"></i> All Diets
                            </div>
                            <div class="table-filters">
                                <select class="filter-select" id="meal-type-filter">
                                    <option value="all">All Types</option>
                                    <option value="Breakfast">Breakfast</option>
                                    <option value="Lunch">Lunch</option>
                                    <option value="Dinner">Dinner</option>
                                    <option value="Snack">Snack</option>
                                </select>
                            </div>
                        </div>

                        <!-- Diet Cards Grid -->
                        <div class="meal-cards-grid">
                            <c:choose>
                                <c:when test="${not empty allDiets}">
                                    <c:forEach var="diet" items="${allDiets}">
                                        <div class="meal-card" data-type="${diet.mealType}">
                                            <div class="meal-header">
                                                <h3 class="meal-name">${diet.mealName}</h3>
                                                <span class="meal-type-badge ${diet.mealType.toLowerCase()}">${diet.mealType}</span>
                                            </div>
                                            <div class="meal-body">
                                                <p class="meal-description">${diet.description}</p>
                                                <div class="meal-stats">
                                                    <div class="stat-item">
                                                        <i class="fas fa-fire"></i>
                                                        <span>${diet.calories} cal</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="meal-actions">
                                                <button class="action-btn view" onclick="viewDiet('${diet.dietId}')">
                                                    <i class="fas fa-eye"></i> View
                                                </button>
                                                <button class="action-btn edit" onclick="editDiet('${diet.dietId}')">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button class="action-btn delete" onclick="deleteDiet('${diet.dietId}')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-utensils"></i>
                                        <h3>No Diets Found</h3>
                                        <p>It looks like there are no diets to display.</p>
                                        <button class="admin-action-btn add" onclick="addSampleData()">
                                            <i class="fas fa-plus"></i> Add Sample Diets
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Progress Tab -->
                    <div class="data-table-container" id="progress-tab" style="display: none;">
                        <div class="table-header">
                            <div class="table-title">
                                <i class="fas fa-chart-line"></i> All Users Progress
                            </div>
                            <div class="table-filters">
                                <select class="filter-select" id="progress-user-filter">
                                    <option value="all">All Users</option>
                                    <c:forEach var="user" items="${allUsers}">
                                        <option value="${user.userId}">${user.username}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <table class="modern-table">
                            <thead>
                                <tr class="table-header-row">
                                    <th class="col">Progress ID</th>
                                    <th class="col">User ID</th>
                                    <th class="col">Username</th>
                                    <th class="col">Date</th>
                                    <th class="col">Weight (kg)</th>
                                    <th class="col">Muscle Mass (kg)</th>
                                    <th class="col">Fat %</th>
                                    <th class="col">BMI</th>
                                    <th class="col">Category</th>
                                    <th class="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="table-body">
                                <c:choose>
                                    <c:when test="${not empty allProgress}">
                                        <c:forEach var="progress" items="${allProgress}">
                                            <tr class="table-row" data-user-id="${progress.userId}">
                                                <td class="col id-text">${progress.progressId}</td>
                                                <td class="col">${progress.userId}</td>
                                                <td class="col">
                                                    <c:forEach var="user" items="${allUsers}">
                                                        <c:if test="${user.userId == progress.userId}">
                                                            ${user.username}
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td class="col date-text">
                                                    <c:choose>
                                                        <c:when test="${not empty progress.date}">
                                                            <fmt:formatDate value="${progress.date}" pattern="dd-MM-yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>N/A</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col">${progress.weight != null ? progress.weight : 'N/A'}</td>
                                                <td class="col">${progress.muscleMass != null ? progress.muscleMass : 'N/A'}</td>
                                                <td class="col">${progress.fatPercent != null ? progress.fatPercent : 'N/A'}%</td>
                                                <td class="col">${progress.bmi != null ? progress.bmi : 'N/A'}</td>
                                                <td class="col">
                                                    <c:if test="${not empty progress.bmiCategory}">
                                                        <span class="role-badge ${progress.bmiCategory.toLowerCase()}">${progress.bmiCategory}</span>
                                                    </c:if>
                                                    <c:if test="${empty progress.bmiCategory}">
                                                        N/A
                                                    </c:if>
                                                </td>
                                                <td class="col action-buttons">
                                                    <button class="action-btn view" onclick="viewProgress('${progress.progressId}', '${progress.userId}')">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" class="empty-state">
                                                <i class="fas fa-chart-line"></i>
                                                <h3>No Progress Records Found</h3>
                                                <p>It looks like there are no progress records to display.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>

        <!-- Modal for Adding User -->
        <div class="modal" id="add-user-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Add New User</h2>
                    <span class="close" onclick="closeModal('add-user-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="add-user-form" action="${pageContext.request.contextPath}/admin/add-user" method="post" enctype="application/x-www-form-urlencoded" accept-charset="UTF-8" onsubmit="return validateAddUserForm()">
                        <div class="input-field full-width">
                            <label><i class="fas fa-user"></i> Username</label>
                            <input type="text" name="username" id="add-username" required minlength="3" maxlength="50">
                            <small class="field-note">Username must be between 3-50 characters</small>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-envelope"></i> Email</label>
                            <input type="email" name="email" id="add-email" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-lock"></i> Password</label>
                            <input type="password" name="password" id="add-password" required minlength="6">
                            <small class="field-note">Password must be at least 6 characters</small>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-user-tag"></i> Role</label>
                            <select name="role" required>
                                <option value="user">User</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-venus-mars"></i> Gender</label>
                            <select name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-birthday-cake"></i> Age</label>
                            <input type="number" name="age" min="1" max="120" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-ruler-vertical"></i> Height (cm)</label>
                            <input type="number" step="0.01" name="height" min="50" max="300" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-weight"></i> Weight (kg)</label>
                            <input type="number" step="0.01" name="weight" min="10" max="500" required>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeModal('add-user-modal')">Cancel</button>
                            <button type="submit" class="btn-primary">Add User</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Thêm Modal for Viewing User -->
        <div class="modal" id="view-user-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>View User Details</h2>
                    <span class="close" onclick="closeModal('view-user-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <div class="user-detail">
                        <label><i class="fas fa-user"></i> Username:</label>
                        <span id="view-username"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-envelope"></i> Email:</label>
                        <span id="view-email"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-user-tag"></i> Role:</label>
                        <span id="view-role"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-calendar-alt"></i> Join Date:</label>
                        <span id="view-joinDate"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-check-circle"></i> Status:</label>
                        <span id="view-status"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-venus-mars"></i> Gender:</label>
                        <span id="view-gender"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-birthday-cake"></i> Age:</label>
                        <span id="view-age"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-ruler-vertical"></i> Height:</label>
                        <span id="view-height"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-weight"></i> Weight:</label>
                        <span id="view-weight"></span>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal('view-user-modal')">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Editing User - Full Edit Form -->
        <div class="modal" id="edit-user-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-user-edit"></i> Edit User - All Information</h2>
                    <span class="close" onclick="closeModal('edit-user-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="edit-user-form" action="${pageContext.request.contextPath}/admin/update-user" method="post" enctype="application/x-www-form-urlencoded" accept-charset="UTF-8" onsubmit="return validateEditUserForm()">
                        <input type="hidden" name="id" id="edit-id">

                        <div class="form-section">
                            <h3 class="form-section-title"><i class="fas fa-user-circle"></i> Basic Information</h3>
                            <div class="input-field-grid">
                                <div class="input-field">
                                    <label><i class="fas fa-user"></i> Username *</label>
                                    <input type="text" name="username" id="edit-username" required minlength="3" maxlength="50" placeholder="Enter username">
                                    <small class="field-note">3-50 characters</small>
                                </div>
                                <div class="input-field">
                                    <label><i class="fas fa-envelope"></i> Email *</label>
                                    <input type="email" name="email" id="edit-email" required placeholder="Enter email">
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="form-section-title"><i class="fas fa-lock"></i> Security</h3>
                            <div class="input-field full-width">
                                <label><i class="fas fa-key"></i> Password</label>
                                <input type="password" name="password" id="edit-password" minlength="6" placeholder="Enter new password">
                                <small class="field-note">Leave blank to keep current password, or enter new password (min 6 characters)</small>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="form-section-title"><i class="fas fa-cog"></i> Account Settings</h3>
                            <div class="input-field-grid">
                                <div class="input-field">
                                    <label><i class="fas fa-user-tag"></i> Role *</label>
                                    <select name="role" id="edit-role" required>
                                        <option value="user">User</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                </div>
                                <div class="input-field">
                                    <label><i class="fas fa-check-circle"></i> Status *</label>
                                    <select name="status" id="edit-status" required>
                                        <option value="active">Active</option>
                                        <option value="inactive">Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="form-section-title"><i class="fas fa-id-card"></i> Personal Information</h3>
                            <div class="input-field-grid">
                                <div class="input-field">
                                    <label><i class="fas fa-venus-mars"></i> Gender *</label>
                                    <select name="gender" id="edit-gender" required>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                    </select>
                                </div>
                                <div class="input-field">
                                    <label><i class="fas fa-birthday-cake"></i> Age *</label>
                                    <input type="number" name="age" id="edit-age" min="1" max="120" required placeholder="Enter age">
                                    <small class="field-note">Years</small>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="form-section-title"><i class="fas fa-ruler-combined"></i> Physical Information</h3>
                            <div class="input-field-grid">
                                <div class="input-field">
                                    <label><i class="fas fa-ruler-vertical"></i> Height *</label>
                                    <input type="number" step="0.01" name="height" id="edit-height" min="50" max="300" required placeholder="Enter height">
                                    <small class="field-note">Centimeters (cm)</small>
                                </div>
                                <div class="input-field">
                                    <label><i class="fas fa-weight"></i> Weight *</label>
                                    <input type="number" step="0.01" name="weight" id="edit-weight" min="10" max="500" required placeholder="Enter weight">
                                    <small class="field-note">Kilograms (kg)</small>
                                </div>
                            </div>
                        </div>

                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeModal('edit-user-modal')">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i> Update All Information
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal for Adding Workout -->
        <div class="modal" id="add-workout-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-dumbbell"></i> Add New Workout</h2>
                    <span class="close" onclick="closeModal('add-workout-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="add-workout-form" action="${pageContext.request.contextPath}/admin-workout?action=add" method="post">
                        <div class="input-field full-width">
                            <label><i class="fas fa-dumbbell"></i> Workout Name</label>
                            <input type="text" name="workoutName" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-align-left"></i> Description</label>
                            <textarea name="description" rows="4" required></textarea>
                        </div>
                        <div class="input-field-grid">
                            <div class="input-field">
                                <label><i class="fas fa-tag"></i> Workout Type</label>
                                <select name="workoutType" required>
                                    <option value="Strength">Strength</option>
                                    <option value="Cardio">Cardio</option>
                                    <option value="Core">Core</option>
                                    <option value="Functional">Functional</option>
                                    <option value="Plyometric">Plyometric</option>
                                </select>
                            </div>
                            <div class="input-field">
                                <label><i class="fas fa-clock"></i> Duration (minutes)</label>
                                <input type="number" name="duration" min="1" required>
                            </div>
                        </div>
                        <div class="input-field-grid">
                            <div class="input-field">
                                <label><i class="fas fa-fire"></i> Calories Burned</label>
                                <input type="number" name="caloriesBurned" min="0" required>
                            </div>
                            <div class="input-field">
                                <label><i class="fas fa-user-tag"></i> BMI Category</label>
                                <select name="bmiCategory" required>
                                    <option value="underweight">Underweight</option>
                                    <option value="normal">Normal</option>
                                    <option value="overweight">Overweight</option>
                                    <option value="obese">Obese</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeModal('add-workout-modal')">Cancel</button>
                            <button type="submit" class="btn-primary">Add Workout</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal for Viewing Workout -->
        <div class="modal" id="view-workout-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-dumbbell"></i> Workout Details</h2>
                    <span class="close" onclick="closeModal('view-workout-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <div class="user-detail">
                        <label><i class="fas fa-dumbbell"></i> Workout Name:</label>
                        <span id="view-workout-name"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-align-left"></i> Description:</label>
                        <span id="view-workout-description"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-tag"></i> Workout Type:</label>
                        <span id="view-workout-type"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-clock"></i> Duration:</label>
                        <span id="view-workout-duration"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-fire"></i> Calories Burned:</label>
                        <span id="view-workout-calories"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-user-tag"></i> BMI Category:</label>
                        <span id="view-workout-bmi"></span>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal('view-workout-modal')">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Editing Workout -->
        <div class="modal" id="edit-workout-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-dumbbell"></i> Edit Workout</h2>
                    <span class="close" onclick="closeModal('edit-workout-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="edit-workout-form" action="${pageContext.request.contextPath}/admin-workout?action=update" method="post">
                        <input type="hidden" name="id" id="edit-workout-id">
                        <div class="input-field full-width">
                            <label><i class="fas fa-dumbbell"></i> Workout Name</label>
                            <input type="text" name="workoutName" id="edit-workout-name" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-align-left"></i> Description</label>
                            <textarea name="description" id="edit-workout-description" rows="4" required></textarea>
                        </div>
                        <div class="input-field-grid">
                            <div class="input-field">
                                <label><i class="fas fa-tag"></i> Workout Type</label>
                                <select name="workoutType" id="edit-workout-type" required>
                                    <option value="Strength">Strength</option>
                                    <option value="Cardio">Cardio</option>
                                    <option value="Core">Core</option>
                                    <option value="Functional">Functional</option>
                                    <option value="Plyometric">Plyometric</option>
                                </select>
                            </div>
                            <div class="input-field">
                                <label><i class="fas fa-clock"></i> Duration (minutes)</label>
                                <input type="number" name="duration" id="edit-workout-duration" min="1" required>
                            </div>
                        </div>
                        <div class="input-field-grid">
                            <div class="input-field">
                                <label><i class="fas fa-fire"></i> Calories Burned</label>
                                <input type="number" name="caloriesBurned" id="edit-workout-calories" min="0" required>
                            </div>
                            <div class="input-field">
                                <label><i class="fas fa-user-tag"></i> BMI Category</label>
                                <select name="bmiCategory" id="edit-workout-bmi" required>
                                    <option value="underweight">Underweight</option>
                                    <option value="normal">Normal</option>
                                    <option value="overweight">Overweight</option>
                                    <option value="obese">Obese</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeModal('edit-workout-modal')">Cancel</button>
                            <button type="submit" class="btn-primary">Update Workout</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal for Adding Diet -->
        <div class="modal" id="add-diet-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-utensils"></i> Add New Diet</h2>
                    <span class="close" onclick="closeModal('add-diet-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="add-diet-form" action="${pageContext.request.contextPath}/admin-diet?action=add" method="post">
                        <div class="input-field full-width">
                            <label><i class="fas fa-utensils"></i> Meal Name</label>
                            <input type="text" name="mealName" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-align-left"></i> Description</label>
                            <textarea name="description" rows="4" required></textarea>
                        </div>
                        <div class="input-field-grid">
                            <div class="input-field">
                                <label><i class="fas fa-tag"></i> Meal Type</label>
                                <select name="mealType" required>
                                    <option value="Breakfast">Breakfast</option>
                                    <option value="Lunch">Lunch</option>
                                    <option value="Dinner">Dinner</option>
                                    <option value="Snack">Snack</option>
                                </select>
                            </div>
                            <div class="input-field">
                                <label><i class="fas fa-fire"></i> Calories</label>
                                <input type="number" name="calories" min="0" required>
                            </div>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-user-tag"></i> BMI Category</label>
                            <select name="bmiCategory" required>
                                <option value="underweight">Underweight</option>
                                <option value="normal">Normal</option>
                                <option value="overweight">Overweight</option>
                                <option value="obese">Obese</option>
                            </select>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeModal('add-diet-modal')">Cancel</button>
                            <button type="submit" class="btn-primary">Add Diet</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal for Viewing Diet -->
        <div class="modal" id="view-diet-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-utensils"></i> Diet Details</h2>
                    <span class="close" onclick="closeModal('view-diet-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <div class="user-detail">
                        <label><i class="fas fa-utensils"></i> Meal Name:</label>
                        <span id="view-diet-name"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-align-left"></i> Description:</label>
                        <span id="view-diet-description"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-tag"></i> Meal Type:</label>
                        <span id="view-diet-type"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-fire"></i> Calories:</label>
                        <span id="view-diet-calories"></span>
                    </div>
                    <div class="user-detail">
                        <label><i class="fas fa-user-tag"></i> BMI Category:</label>
                        <span id="view-diet-bmi"></span>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal('view-diet-modal')">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Editing Diet -->
        <div class="modal" id="edit-diet-modal">
            <div class="modal-content modal-content-large">
                <div class="modal-header">
                    <h2><i class="fas fa-utensils"></i> Edit Diet</h2>
                    <span class="close" onclick="closeModal('edit-diet-modal')">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="edit-diet-form" action="${pageContext.request.contextPath}/admin-diet?action=update" method="post">
                        <input type="hidden" name="id" id="edit-diet-id">
                        <div class="input-field full-width">
                            <label><i class="fas fa-utensils"></i> Meal Name</label>
                            <input type="text" name="mealName" id="edit-diet-name" required>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-align-left"></i> Description</label>
                            <textarea name="description" id="edit-diet-description" rows="4" required></textarea>
                        </div>
                        <div class="input-field-grid">
                            <div class="input-field">
                                <label><i class="fas fa-tag"></i> Meal Type</label>
                                <select name="mealType" id="edit-diet-type" required>
                                    <option value="Breakfast">Breakfast</option>
                                    <option value="Lunch">Lunch</option>
                                    <option value="Dinner">Dinner</option>
                                    <option value="Snack">Snack</option>
                                </select>
                            </div>
                            <div class="input-field">
                                <label><i class="fas fa-fire"></i> Calories</label>
                                <input type="number" name="calories" id="edit-diet-calories" min="0" required>
                            </div>
                        </div>
                        <div class="input-field full-width">
                            <label><i class="fas fa-user-tag"></i> BMI Category</label>
                            <select name="bmiCategory" id="edit-diet-bmi" required>
                                <option value="underweight">Underweight</option>
                                <option value="normal">Normal</option>
                                <option value="overweight">Overweight</option>
                                <option value="obese">Obese</option>
                            </select>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeModal('edit-diet-modal')">Cancel</button>
                            <button type="submit" class="btn-primary">Update Diet</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Thêm biến JS để lưu dữ liệu users từ server
            var users = [];
            <c:choose>
                <c:when test="${not empty allUsers}">
                    <c:forEach var="user" items="${allUsers}" varStatus="status">
            try {
            users.push({
            id: ${user.userId},
                    username: '<c:out value="${user.username != null ? user.username : ''}" escapeXml="true" />',
                    email: '<c:out value="${user.email != null ? user.email : ''}" escapeXml="true" />',
                    role: '<c:out value="${user.role != null ? user.role : 'user'}" escapeXml="true" />',
                    joinDate: '<fmt:formatDate value="${user.joinDate}" pattern="dd-MM-yyyy"/>',
                    status: '<c:out value="${user.status != null ? user.status : 'active'}" escapeXml="true" />',
                    gender: '<c:out value="${user.gender != null ? user.gender : 'Male'}" escapeXml="true" />',
                    age: ${user.age != null && user.age > 0 ? user.age : 0},
                    height: ${user.height != null && user.height > 0 ? user.height : 0},
                    weight: ${user.weight != null && user.weight > 0 ? user.weight : 0}
            });
            } catch (e) {
            console.error('Error adding user to array:', e);
            }
                    </c:forEach>
                </c:when>
            </c:choose>

            console.log('=== USERS LOADED ===');
            console.log('Users count:', users.length);
            console.log('Users array:', users);
            // Thêm biến JS để lưu dữ liệu workouts từ server
            var workouts = [
            <c:forEach var="workout" items="${allWorkouts}" varStatus="status">
            {
            id: '${workout.workoutId}',
                    workoutName: '${workout.workoutName}',
                    description: '${workout.description}',
                    workoutType: '${workout.workoutType}',
                    duration: '${workout.duration}',
                    caloriesBurned: '${workout.caloriesBurned}',
                    bmiCategory: '${workout.bmiCategory}'
            }${not status.last ? ',' : ''}
            </c:forEach>
            ];
            // Thêm biến JS để lưu dữ liệu diets từ server
            var diets = [
            <c:forEach var="diet" items="${allDiets}" varStatus="status">
            {
            id: '${diet.dietId}',
                    mealName: '${diet.mealName}',
                    description: '${diet.description}',
                    mealType: '${diet.mealType}',
                    calories: '${diet.calories}',
                    bmiCategory: '${diet.bmiCategory}'
            }${not status.last ? ',' : ''}
            </c:forEach>
            ];
            // Update current time
            function updateTime() {
            const now = new Date();
            const options = { hour: '2-digit', minute: '2-digit', hour12: true };
            document.getElementById('current-time').textContent = now.toLocaleTimeString('en-US', options);
            }
            setInterval(updateTime, 1000);
            updateTime();
            // Modal functions - Make them global
            window.closeModal = function(modalId) {
            console.log('Closing modal:', modalId);
            const modal = document.getElementById(modalId);
            if (modal) {
            modal.style.display = 'none';
            console.log('Modal closed');
            } else {
            console.error('Modal not found:', modalId);
            }
            };
            window.openAddUserModal = function() {
            console.log('Opening add user modal');
            try {
            const modal = document.getElementById('add-user-modal');
            console.log('Modal element:', modal);
            if (modal) {
            modal.style.display = 'block';
            modal.style.animation = 'modalSlideIn 0.3s ease';
            console.log('Modal opened successfully');
            return true;
            } else {
            console.error('Modal not found: add-user-modal');
            alert('Không tìm thấy modal Add User. Vui lòng refresh trang.');
            return false;
            }
            } catch (error) {
            console.error('Error opening add user modal:', error);
            alert('Lỗi khi mở modal: ' + error.message);
            return false;
            }
            };
            // User CRUD functions - Make them global
            window.viewUser = function(userId) {
            console.log('=== VIEW USER ===');
            console.log('User ID:', userId);
            console.log('Users array length:', users ? users.length : 0);
            console.log('Users array:', users);
            try {
            if (!users || users.length === 0) {
            console.error('Users array is empty');
            alert('Không có dữ liệu user. Vui lòng refresh trang.');
            return false;
            }

            // Convert userId to number for comparison
            const userIdNum = parseInt(userId);
            console.log('Searching for user ID:', userIdNum);
            const user = users.find(u => {
            const match = parseInt(u.id) === userIdNum;
            console.log('Comparing:', parseInt(u.id), '===', userIdNum, '=', match);
            return match;
            });
            console.log('Found user:', user);
            if (!user) {
            alert('Không tìm thấy user với ID: ' + userId + '. Tổng số users: ' + users.length);
            return false;
            }

            const modal = document.getElementById('view-user-modal');
            if (!modal) {
            console.error('View user modal not found');
            alert('Không tìm thấy modal View User. Vui lòng refresh trang.');
            return false;
            }

            // Set user data to modal
            const setElement = (id, value) => {
            const el = document.getElementById(id);
            if (el) {
            el.textContent = value || 'N/A';
            console.log('Set', id, 'to', value);
            } else {
            console.error('Element not found:', id);
            }
            };
            setElement('view-username', user.username || 'N/A');
            setElement('view-email', user.email || 'N/A');
            setElement('view-role', user.role || 'N/A');
            setElement('view-joinDate', user.joinDate || 'N/A');
            setElement('view-status', user.status || 'N/A');
            setElement('view-gender', user.gender || 'N/A');
            setElement('view-age', user.age || 'N/A');
            setElement('view-height', (user.height || 0) + ' cm');
            setElement('view-weight', (user.weight || 0) + ' kg');
            modal.style.display = 'block';
            console.log('View user modal opened successfully');
            return true;
            } catch (error) {
            console.error('Error in viewUser:', error);
            alert('Lỗi khi xem user: ' + error.message);
            return false;
            }
            };
            window.editUser = function(userId) {
            console.log('=== EDIT USER ===');
            console.log('User ID:', userId);
            console.log('Users array length:', users ? users.length : 0);
            try {
            if (!users || users.length === 0) {
            console.error('Users array is empty');
            alert('Không có dữ liệu user. Vui lòng refresh trang.');
            return false;
            }

            // Convert userId to number for comparison
            const userIdNum = parseInt(userId);
            console.log('Searching for user ID:', userIdNum);
            const user = users.find(u => parseInt(u.id) === userIdNum);
            console.log('Found user:', user);
            if (!user) {
            alert('Không tìm thấy user với ID: ' + userId + '. Tổng số users: ' + users.length);
            return false;
            }

            const modal = document.getElementById('edit-user-modal');
            if (!modal) {
            console.error('Edit user modal not found');
            alert('Không tìm thấy modal Edit User. Vui lòng refresh trang.');
            return false;
            }

            // Set user data to form
            const setElement = (id, value) => {
            const el = document.getElementById(id);
            if (el) {
            el.value = value || '';
            console.log('Set', id, 'to', value);
            } else {
            console.error('Element not found:', id);
            }
            };
            setElement('edit-id', user.id);
            setElement('edit-username', user.username || '');
            setElement('edit-email', user.email || '');
            const role = (user.role || 'user').toLowerCase();
            setElement('edit-role', role === 'admin' ? 'admin' : 'user');
            const status = (user.status || 'active').toLowerCase();
            setElement('edit-status', status === 'inactive' ? 'inactive' : 'active');
            setElement('edit-gender', (user.gender === 'Female') ? 'Female' : 'Male');
            setElement('edit-age', user.age || 0);
            setElement('edit-height', user.height || 0);
            setElement('edit-weight', user.weight || 0);
            const passwordEl = document.getElementById('edit-password');
            if (passwordEl) passwordEl.value = ''; // Để trống để không thay đổi

            modal.style.display = 'block';
            console.log('Edit user modal opened successfully');
            return true;
            } catch (error) {
            console.error('Error in editUser:', error);
            alert('Lỗi khi sửa user: ' + error.message);
            return false;
            }
            };
            window.deleteUser = function(userId) {
            console.log('=== DELETE USER ===');
            console.log('User ID:', userId);
            try {
            if (!userId) {
            alert('User ID không hợp lệ!');
            return false;
            }

            if (confirm('Bạn có chắc chắn muốn xóa user ID ' + userId + ' không?\n\nLưu ý: Hành động này không thể hoàn tác!')) {
            const deleteUrl = '${pageContext.request.contextPath}/admin/delete-user?id=' + userId;
            console.log('Deleting user, redirecting to:', deleteUrl);
            window.location.href = deleteUrl;
            return true;
            }
            return false;
            } catch (error) {
            console.error('Error in deleteUser:', error);
            alert('Lỗi khi xóa user: ' + error.message);
            return false;
            }
            };
            // Form validation functions
            window.validateAddUserForm = function() {
            console.log('Validating add user form...');
            try {
            const usernameEl = document.getElementById('add-username');
            const emailEl = document.getElementById('add-email');
            const passwordEl = document.getElementById('add-password');
            if (!usernameEl || !emailEl || !passwordEl) {
            alert('Form elements not found. Please refresh the page.');
            return false;
            }

            const username = usernameEl.value.trim();
            const email = emailEl.value.trim();
            const password = passwordEl.value;
            if (username.length < 3 || username.length > 50) {
            alert('Username must be between 3-50 characters');
            usernameEl.focus();
            return false;
            }

            if (!email || !email.includes('@')) {
            alert('Please enter a valid email address');
            emailEl.focus();
            return false;
            }

            if (password.length < 6) {
            alert('Password must be at least 6 characters');
            passwordEl.focus();
            return false;
            }

            console.log('Add user form validated, submitting...');
            return true;
            } catch (error) {
            console.error('Error validating add user form:', error);
            alert('Validation error: ' + error.message);
            return false;
            }
            };
            window.validateEditUserForm = function() {
            console.log('Validating edit user form...');
            try {
            const userIdEl = document.getElementById('edit-id');
            const usernameEl = document.getElementById('edit-username');
            const emailEl = document.getElementById('edit-email');
            const passwordEl = document.getElementById('edit-password');
            const ageEl = document.getElementById('edit-age');
            const heightEl = document.getElementById('edit-height');
            const weightEl = document.getElementById('edit-weight');
            if (!userIdEl || !usernameEl || !emailEl || !ageEl || !heightEl || !weightEl) {
            alert('Form elements not found. Please refresh the page.');
            return false;
            }

            const userId = userIdEl.value;
            const username = usernameEl.value.trim();
            const email = emailEl.value.trim();
            const password = passwordEl ? passwordEl.value : '';
            const age = ageEl.value;
            const height = heightEl.value;
            const weight = weightEl.value;
            if (!userId) {
            alert('User ID is missing! Please refresh the page.');
            return false;
            }

            // Validate username
            if (username.length < 3 || username.length > 50) {
            alert('Username must be between 3-50 characters');
            usernameEl.focus();
            return false;
            }

            // Validate email
            if (!email || !email.includes('@')) {
            alert('Please enter a valid email address');
            emailEl.focus();
            return false;
            }

            // Validate password (optional)
            if (password && password.length > 0 && password.length < 6) {
            alert('Password must be at least 6 characters (or leave blank to keep current password)');
            if (passwordEl) passwordEl.focus();
            return false;
            }

            // Validate age
            const ageNum = parseInt(age);
            if (isNaN(ageNum) || ageNum < 1 || ageNum > 120) {
            alert('Age must be between 1-120 years');
            ageEl.focus();
            return false;
            }

            // Validate height
            const heightNum = parseFloat(height);
            if (isNaN(heightNum) || heightNum < 50 || heightNum > 300) {
            alert('Height must be between 50-300 cm');
            heightEl.focus();
            return false;
            }

            // Validate weight
            const weightNum = parseFloat(weight);
            if (isNaN(weightNum) || weightNum < 10 || weightNum > 500) {
            alert('Weight must be between 10-500 kg');
            weightEl.focus();
            return false;
            }

            console.log('Edit user form validated, submitting...');
            console.log('Updating user ID:', userId);
            console.log('Will update password:', password && password.length > 0);
            console.log('Will update all fields: Username, Email, Role, Status, Gender, Age, Height, Weight');
            return true;
            } catch (error) {
            console.error('Error validating edit user form:', error);
            alert('Validation error: ' + error.message);
            return false;
            }
            };
            // Add form submission handlers
            document.addEventListener('DOMContentLoaded', function() {
            const addForm = document.getElementById('add-user-form');
            const editForm = document.getElementById('edit-user-form');
            if (addForm) {
            addForm.addEventListener('submit', function(e) {
            console.log('Add user form submitted');
            // Form will submit if validation passes
            });
            }

            if (editForm) {
            editForm.addEventListener('submit', function(e) {
            console.log('Edit user form submitted');
            // Form will submit if validation passes
            });
            }
            });
            // Workout functions
            function openAddWorkoutModal() {
            document.getElementById('add-workout-modal').style.display = 'block';
            }

            function viewWorkout(workoutId) {
            const workout = workouts.find(w => w.id == workoutId);
            if (workout) {
            document.getElementById('view-workout-name').textContent = workout.workoutName || 'N/A';
            document.getElementById('view-workout-description').textContent = workout.description || 'N/A';
            document.getElementById('view-workout-type').textContent = workout.workoutType || 'N/A';
            document.getElementById('view-workout-duration').textContent = (workout.duration || 0) + ' minutes';
            document.getElementById('view-workout-calories').textContent = (workout.caloriesBurned || 0) + ' cal';
            document.getElementById('view-workout-bmi').textContent = workout.bmiCategory || 'N/A';
            document.getElementById('view-workout-modal').style.display = 'block';
            } else {
            alert('Workout not found');
            }
            }

            function editWorkout(workoutId) {
            const workout = workouts.find(w => w.id == workoutId);
            if (workout) {
            document.getElementById('edit-workout-id').value = workout.id;
            document.getElementById('edit-workout-name').value = workout.workoutName || '';
            document.getElementById('edit-workout-description').value = workout.description || '';
            document.getElementById('edit-workout-type').value = workout.workoutType || 'Strength';
            document.getElementById('edit-workout-duration').value = workout.duration || 0;
            document.getElementById('edit-workout-calories').value = workout.caloriesBurned || 0;
            document.getElementById('edit-workout-bmi').value = workout.bmiCategory || 'normal';
            document.getElementById('edit-workout-modal').style.display = 'block';
            } else {
            alert('Workout not found');
            }
            }

            function deleteWorkout(workoutId) {
            if (confirm('Are you sure you want to delete workout ID ' + workoutId + '?')) {
            window.location.href = '${pageContext.request.contextPath}/admin-workout?action=delete&id=' + workoutId;
            }
            }

            // Diet functions
            function openAddDietModal() {
            document.getElementById('add-diet-modal').style.display = 'block';
            }

            function viewDiet(dietId) {
            const diet = diets.find(d => d.id == dietId);
            if (diet) {
            document.getElementById('view-diet-name').textContent = diet.mealName || 'N/A';
            document.getElementById('view-diet-description').textContent = diet.description || 'N/A';
            document.getElementById('view-diet-type').textContent = diet.mealType || 'N/A';
            document.getElementById('view-diet-calories').textContent = (diet.calories || 0) + ' cal';
            document.getElementById('view-diet-bmi').textContent = diet.bmiCategory || 'N/A';
            document.getElementById('view-diet-modal').style.display = 'block';
            } else {
            alert('Diet not found');
            }
            }

            function editDiet(dietId) {
            const diet = diets.find(d => d.id == dietId);
            if (diet) {
            document.getElementById('edit-diet-id').value = diet.id;
            document.getElementById('edit-diet-name').value = diet.mealName || '';
            document.getElementById('edit-diet-description').value = diet.description || '';
            document.getElementById('edit-diet-type').value = diet.mealType || 'Breakfast';
            document.getElementById('edit-diet-calories').value = diet.calories || 0;
            document.getElementById('edit-diet-bmi').value = diet.bmiCategory || 'normal';
            document.getElementById('edit-diet-modal').style.display = 'block';
            } else {
            alert('Diet not found');
            }
            }

            function deleteDiet(dietId) {
            if (confirm('Are you sure you want to delete diet ID ' + dietId + '?')) {
            window.location.href = '${pageContext.request.contextPath}/admin-diet?action=delete&id=' + dietId;
            }
            }

            function viewProgress(progressId, userId) {
            // Find and display progress details
            const progressRow = document.querySelector(`tr[data-user-id="${userId}"]`);
            if (progressRow) {
            const cells = progressRow.querySelectorAll('td');
            const details = {
            progressId: cells[0].textContent.trim(),
                    userId: cells[1].textContent.trim(),
                    username: cells[2].textContent.trim(),
                    date: cells[3].textContent.trim(),
                    weight: cells[4].textContent.trim(),
                    muscleMass: cells[5].textContent.trim(),
                    fatPercent: cells[6].textContent.trim(),
                    bmi: cells[7].textContent.trim(),
                    category: cells[8].textContent.trim()
            };
            let message = 'Progress Details:\n';
            message += `Progress ID: ${details.progressId}\n`;
            message += `User: ${details.username} (ID: ${details.userId})\n`;
            message += `Date: ${details.date}\n`;
            message += `Weight: ${details.weight} kg\n`;
            message += `Muscle Mass: ${details.muscleMass} kg\n`;
            message += `Fat %: ${details.fatPercent}\n`;
            message += `BMI: ${details.bmi}\n`;
            message += `Category: ${details.category}`;
            alert(message);
            }
            }

            function editProgress(progressId) {
            alert('Edit functionality for progress ' + progressId + ' would be implemented here');
            }

            function deleteProgress(progressId) {
            if (confirm('Are you sure you want to delete progress ' + progressId + '?')) {
            alert('Delete functionality for progress ' + progressId + ' would be implemented here');
            }
            }

            // Filter progress by user
            document.getElementById('progress-user-filter')?.addEventListener('change', function(e) {
            const userId = e.target.value;
            const rows = document.querySelectorAll('#progress-tab .table-row');
            rows.forEach(row => {
            const rowUserId = row.getAttribute('data-user-id');
            row.style.display = (userId === 'all' || rowUserId === userId) ? '' : 'none';
            });
            });
            // Function để thêm sample data
            function addSampleData() {
            if (confirm('Are you sure you want to add sample data? This will add 20 workouts and 20 diets to the database.')) {
            window.location.href = '${pageContext.request.contextPath}/admin/add-sample-data';
            }
            }

            // Search and filter functionality for users
            function initUserSearch() {
            const userSearchInput = document.getElementById('user-search');
            const roleFilterSelect = document.getElementById('role-filter');
            if (userSearchInput) {
            userSearchInput.addEventListener('input', function(e) {
            const searchText = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('#users-tab .table-row');
            console.log('Searching for:', searchText, 'Found rows:', rows.length);
            rows.forEach(row => {
            const usernameEl = row.querySelector('.username');
            const emailEl = row.querySelector('.email-text');
            if (usernameEl && emailEl) {
            const username = usernameEl.textContent.toLowerCase();
            const email = emailEl.textContent.toLowerCase();
            const matches = username.includes(searchText) || email.includes(searchText);
            row.style.display = matches ? '' : 'none';
            console.log('Row matches:', matches, 'Username:', username, 'Email:', email);
            }
            });
            });
            console.log('User search initialized');
            } else {
            console.error('User search input not found');
            }

            if (roleFilterSelect) {
            roleFilterSelect.addEventListener('change', function(e) {
            const role = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('#users-tab .table-row');
            console.log('Filtering by role:', role, 'Found rows:', rows.length);
            rows.forEach(row => {
            const roleBadge = row.querySelector('.role-badge');
            if (roleBadge) {
            const userRole = roleBadge.textContent.toLowerCase();
            const matches = role === 'all' || userRole === role;
            row.style.display = matches ? '' : 'none';
            console.log('Row role matches:', matches, 'User role:', userRole);
            }
            });
            });
            console.log('Role filter initialized');
            } else {
            console.error('Role filter select not found');
            }
            }

            // Search and filter functionality for workouts
            document.getElementById('workout-search')?.addEventListener('input', function(e) {
            const searchText = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('#workouts-tab .workout-card');
            cards.forEach(card => {
            const workoutName = card.querySelector('.workout-name')?.textContent.toLowerCase() || '';
            const description = card.querySelector('.workout-description')?.textContent.toLowerCase() || '';
            card.style.display = (workoutName.includes(searchText) || description.includes(searchText)) ? '' : 'none';
            });
            });
            document.getElementById('workout-type-filter')?.addEventListener('change', function(e) {
            const type = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('#workouts-tab .workout-card');
            cards.forEach(card => {
            const cardType = card.getAttribute('data-type')?.toLowerCase() || '';
            card.style.display = (type === 'all' || cardType === type) ? '' : 'none';
            });
            });
            // Search and filter functionality for diets
            document.getElementById('diet-search')?.addEventListener('input', function(e) {
            const searchText = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('#diets-tab .meal-card');
            cards.forEach(card => {
            const mealName = card.querySelector('.meal-name')?.textContent.toLowerCase() || '';
            const description = card.querySelector('.meal-description')?.textContent.toLowerCase() || '';
            card.style.display = (mealName.includes(searchText) || description.includes(searchText)) ? '' : 'none';
            });
            });
            document.getElementById('meal-type-filter')?.addEventListener('change', function(e) {
            const type = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('#diets-tab .meal-card');
            cards.forEach(card => {
            const cardType = card.getAttribute('data-type')?.toLowerCase() || '';
            card.style.display = (type === 'all' || cardType === type) ? '' : 'none';
            });
            });
            // Tab switching functionality
            document.querySelectorAll('.nav-item').forEach(button => {
            button.addEventListener('click', function() {
            // Remove active class from all buttons
            document.querySelectorAll('.nav-item').forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked button
            this.classList.add('active');
            // Hide all tabs
            document.querySelectorAll('.data-table-container').forEach(tab => {
            tab.style.display = 'none';
            });
            // Show selected tab
            const tabId = this.getAttribute('data-tab') + '-tab';
            const tabElement = document.getElementById(tabId);
            if (tabElement) {
            tabElement.style.display = 'block';
            }

            // Update content title
            const titles = {
            'users': '<i class="fas fa-users"></i> User Management',
                    'workouts': '<i class="fas fa-dumbbell"></i> Workout Management',
                    'diets': '<i class="fas fa-utensils"></i> Diet Management',
                    'progress': '<i class="fas fa-chart-line"></i> Progress Management'
            };
            const titleElement = document.getElementById('content-title');
            if (titleElement) {
            titleElement.innerHTML = titles[this.getAttribute('data-tab')] || '';
            }
            });
            });
            // Close modal when clicking outside
            window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
            console.log('Closing modal by clicking outside');
            event.target.style.display = 'none';
            }
            };
            // Add event listeners when page loads
            function initPage() {
            console.log('=== INITIALIZING PAGE ===');
            console.log('Users count:', users.length);
            // Test if all functions are defined
            console.log('Testing functions...');
            console.log('viewUser defined:', typeof window.viewUser === 'function');
            console.log('editUser defined:', typeof window.editUser === 'function');
            console.log('deleteUser defined:', typeof window.deleteUser === 'function');
            console.log('openAddUserModal defined:', typeof window.openAddUserModal === 'function');
            console.log('closeModal defined:', typeof window.closeModal === 'function');
            // Test if modals exist
            const addModal = document.getElementById('add-user-modal');
            const editModal = document.getElementById('edit-user-modal');
            const viewModal = document.getElementById('view-user-modal');
            console.log('Add modal exists:', !!addModal);
            console.log('Edit modal exists:', !!editModal);
            console.log('View modal exists:', !!viewModal);
            // Test if buttons exist
            const addButton = document.querySelector('button[onclick*="openAddUserModal"]');
            console.log('Add button exists:', !!addButton);
            // Make sure modals are hidden initially
            if (addModal) {
            addModal.style.display = 'none';
            console.log('Add modal hidden');
            }
            if (editModal) {
            editModal.style.display = 'none';
            console.log('Edit modal hidden');
            }
            if (viewModal) {
            viewModal.style.display = 'none';
            console.log('View modal hidden');
            }

            // Initialize user search and filter
            initUserSearch();
            // Test CRUD buttons in table
            const viewButtons = document.querySelectorAll('button[onclick*="viewUser"]');
            const editButtons = document.querySelectorAll('button[onclick*="editUser"]');
            const deleteButtons = document.querySelectorAll('button[onclick*="deleteUser"]');
            console.log('View buttons found:', viewButtons.length);
            console.log('Edit buttons found:', editButtons.length);
            console.log('Delete buttons found:', deleteButtons.length);
            // Add event delegation as backup if onclick fails
            // This will catch clicks even if onclick handler fails
            document.body.addEventListener('click', function(e) {
            const button = e.target.closest('button.action-btn');
            if (!button) return;
            // Only handle if onclick didn't work (check after a small delay)
            setTimeout(function() {
            // Check if modal was opened, if not, try delegation
            const viewModal = document.getElementById('view-user-modal');
            const editModal = document.getElementById('edit-user-modal');
            // This is just for logging, actual handlers are in onclick
            const onclick = button.getAttribute('onclick');
            if (onclick) {
            console.log('Button clicked with onclick:', onclick);
            }
            }, 100);
            }, true); // Use capture phase

            console.log('=== PAGE INITIALIZATION COMPLETE ===');
            }

            // Run initialization when DOM is ready
            function startInitialization() {
            if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', function() {
            setTimeout(initPage, 100); // Small delay to ensure everything is loaded
            });
            } else {
            // DOM is already loaded
            setTimeout(initPage, 100);
            }
            }

            startInitialization();
            // Test function availability after page load
            window.addEventListener('load', function() {
            console.log('=== PAGE FULLY LOADED ===');
            console.log('Testing CRUD functions availability...');
            const functions = {
            'viewUser': typeof window.viewUser,
                    'editUser': typeof window.editUser,
                    'deleteUser': typeof window.deleteUser,
                    'openAddUserModal': typeof window.openAddUserModal,
                    'closeModal': typeof window.closeModal,
                    'validateAddUserForm': typeof window.validateAddUserForm,
                    'validateEditUserForm': typeof window.validateEditUserForm
            };
            console.log('Function types:', functions);
            const allDefined = Object.values(functions).every(type => type === 'function');
            if (allDefined) {
            console.log('✅ All CRUD functions are defined correctly!');
            } else {
            console.error('❌ Some functions are not defined!');
            Object.entries(functions).forEach(([name, type]) => {
            if (type !== 'function') {
            console.error('  -', name, 'is', type, 'instead of function');
            }
            });
            }

            // Test if we can find user buttons
            const testButtons = document.querySelectorAll('#users-tab button.action-btn');
            console.log('Found action buttons in users table:', testButtons.length);
            if (testButtons.length > 0) {
            console.log('First button onclick:', testButtons[0].getAttribute('onclick'));
            }

            console.log('=== END PAGE LOAD TEST ===');
            });
            // Gọi hàm khi nhập liệu (thay đổi giá trị)
            document.getElementById('height').addEventListener('input', calculateBMIPreview);
            document.getElementById('weight').addEventListener('input', calculateBMIPreview);
            // Gọi ngay khi load trang (nếu có giá trị mặc định)
            window.addEventListener('load', calculateBMIPreview);
        </script>
    </body>
</html>