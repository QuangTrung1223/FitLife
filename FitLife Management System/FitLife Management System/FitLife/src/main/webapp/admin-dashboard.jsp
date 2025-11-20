<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="admin-body">
    <%@ include file="header.jsp" %>

    <div class="admin-dashboard-container">
        <!-- Top Header Bar -->
        <div class="admin-top-bar">
            <div class="admin-welcome-section">
                <h1 class="admin-title">
                    <i class="fas fa-user-shield"></i>
                    <span>Admin Dashboard</span>
                </h1>
                <p class="admin-subtitle">Comprehensive management panel for FitLife system</p>
            </div>
            <div class="admin-actions-section">
                <button class="admin-action-btn refresh" onclick="refreshData()">
                    <i class="fas fa-sync-alt"></i>
                    <span>Refresh</span>
                </button>
                <button class="admin-action-btn export">
                    <i class="fas fa-download"></i>
                    <span>Export</span>
                </button>
                <div class="admin-time">
                    <i class="fas fa-clock"></i>
                    <span id="currentTime"></span>
                </div>
            </div>
        </div>

        <!-- Main Content Grid -->
        <div class="admin-main-grid">
            <!-- Left Sidebar -->
            <div class="admin-sidebar">
                <div class="sidebar-section">
                    <h3 class="sidebar-title">Quick Stats</h3>
                    <div class="quick-stats">
                        <div class="quick-stat-item">
                            <div class="stat-icon users">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">${allUsers.size()}</span>
                                <span class="stat-label">Users</span>
                            </div>
                        </div>
                        <div class="quick-stat-item">
                            <div class="stat-icon workouts">
                                <i class="fas fa-dumbbell"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">${allWorkouts.size()}</span>
                                <span class="stat-label">Workouts</span>
                            </div>
                        </div>
                        <div class="quick-stat-item">
                            <div class="stat-icon diets">
                                <i class="fas fa-apple-alt"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">${allDiets.size()}</span>
                                <span class="stat-label">Meals</span>
                            </div>
                        </div>
                        <div class="quick-stat-item">
                            <div class="stat-icon progress">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number">${allProgress.size()}</span>
                                <span class="stat-label">Progress</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="sidebar-section">
                    <h3 class="sidebar-title">Navigation</h3>
                    <nav class="admin-nav">
                        <button class="nav-item active" onclick="showAdminTab('users')">
                            <i class="fas fa-users"></i>
                            <span>User Management</span>
                        </button>
                        <button class="nav-item" onclick="showAdminTab('progress')">
                            <i class="fas fa-chart-line"></i>
                            <span>Progress Overview</span>
                        </button>
                        <button class="nav-item" onclick="showAdminTab('workouts')">
                            <i class="fas fa-dumbbell"></i>
                            <span>Workout Activity</span>
                        </button>
                        <button class="nav-item" onclick="showAdminTab('diets')">
                            <i class="fas fa-apple-alt"></i>
                            <span>Diet Activity</span>
                        </button>
                    </nav>
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="admin-content-area">
                <!-- Content Header -->
                <div class="content-header">
                    <h2 id="contentTitle">User Management</h2>
                    <div class="content-actions">
                        <div class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search..." id="globalSearch">
                        </div>
                        <button class="action-btn primary">
                            <i class="fas fa-plus"></i>
                            <span>Add New</span>
                        </button>
                    </div>
                </div>

                <!-- Tab Content -->
                <div class="admin-tab-content">
                    <!-- Users Management Tab -->
                    <div id="users" class="admin-tab-panel active">
                        <div class="data-table-container">
                            <div class="table-header">
                                <div class="table-title">
                                    <i class="fas fa-users"></i>
                                    <span>User Management</span>
                                </div>
                                <div class="table-filters">
                                    <select class="filter-select">
                                        <option value="all">All Roles</option>
                                        <option value="user">Users</option>
                                        <option value="admin">Admins</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="modern-table">
                                <div class="table-header-row">
                                    <div class="col user-col">User</div>
                                    <div class="col email-col">Email</div>
                                    <div class="col role-col">Role</div>
                                    <div class="col id-col">ID</div>
                                    <div class="col actions-col">Actions</div>
                                </div>
                                
                                <div class="table-body">
                                    <c:forEach var="user" items="${allUsers}">
                                        <div class="table-row" data-username="${user.username}">
                                            <div class="col user-col">
                                                <div class="user-cell">
                                                    <div class="user-avatar-small">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div class="user-details">
                                                        <span class="username">${user.username}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col email-col">
                                                <span class="email-text">${user.email}</span>
                                            </div>
                                            <div class="col role-col">
                                                <span class="role-badge ${user.role}">${user.role}</span>
                                            </div>
                                            <div class="col id-col">
                                                <span class="id-text">${user.userId}</span>
                                            </div>
                                            <div class="col actions-col">
                                                <div class="action-buttons">
                                                    <button class="action-btn view" onclick="viewUserDetails(${user.userId}, '${user.username}')" title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="action-btn edit" onclick="editUser(${user.userId}, '${user.username}', '${user.email}', '${user.role}')" title="Edit User">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="action-btn delete" onclick="deleteUser(${user.userId}, '${user.username}')" title="Delete User">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Progress Overview Tab -->
                    <div id="progress" class="admin-tab-panel">
                        <div class="data-table-container">
                            <div class="table-header">
                                <div class="table-title">
                                    <i class="fas fa-chart-line"></i>
                                    <span>Progress Overview</span>
                                </div>
                                <div class="table-filters">
                                    <select class="filter-select" id="progressFilter">
                                        <option value="all">All BMI Categories</option>
                                        <option value="normal">Normal BMI</option>
                                        <option value="overweight">Overweight</option>
                                        <option value="obese">Obese</option>
                                        <option value="underweight">Underweight</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="modern-table">
                                <div class="table-header-row">
                                    <div class="col user-col">User</div>
                                    <div class="col weight-col">Weight</div>
                                    <div class="col bmi-col">BMI</div>
                                    <div class="col muscle-col">Muscle</div>
                                    <div class="col fat-col">Fat %</div>
                                    <div class="col date-col">Date</div>
                                    <div class="col category-col">Category</div>
                                </div>
                                
                                <div class="table-body">
                                    <c:forEach var="progress" items="${allProgress}">
                                        <div class="table-row" data-category="${progress.bmiCategory}">
                                            <div class="col user-col">
                                                <div class="user-cell">
                                                    <div class="user-avatar-small">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div class="user-details">
                                                        <span class="username">User ${progress.userId}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col weight-col">
                                                <span class="metric-value">${progress.weight} kg</span>
                                            </div>
                                            <div class="col bmi-col">
                                                <span class="bmi-value">${progress.bmi}</span>
                                            </div>
                                            <div class="col muscle-col">
                                                <span class="metric-value">${progress.muscleMass} kg</span>
                                            </div>
                                            <div class="col fat-col">
                                                <span class="metric-value">${progress.fatPercent}%</span>
                                            </div>
                                            <div class="col date-col">
                                                <span class="date-text">${progress.date}</span>
                                            </div>
                                            <div class="col category-col">
                                                <span class="bmi-badge ${progress.bmiCategory}">${progress.bmiCategory}</span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Workout Activity Tab -->
                    <div id="workouts" class="admin-tab-panel">
                        <div class="data-table-container">
                            <div class="table-header">
                                <div class="table-title">
                                    <i class="fas fa-dumbbell"></i>
                                    <span>Workout Activity</span>
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
                                    <div class="col user-col">User</div>
                                    <div class="col type-col">Type</div>
                                    <div class="col duration-col">Duration</div>
                                    <div class="col calories-col">Calories</div>
                                    <div class="col date-col">Date</div>
                                </div>
                                
                                <div class="table-body">
                                    <c:forEach var="workout" items="${allWorkouts}">
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
                                            <div class="col user-col">
                                                <span class="user-text">User ${workout.userId}</span>
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
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Diet Activity Tab -->
                    <div id="diets" class="admin-tab-panel">
                        <div class="data-table-container">
                            <div class="table-header">
                                <div class="table-title">
                                    <i class="fas fa-apple-alt"></i>
                                    <span>Diet Activity</span>
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
                                    <div class="col user-col">User</div>
                                    <div class="col type-col">Type</div>
                                    <div class="col calories-col">Calories</div>
                                    <div class="col category-col">BMI Category</div>
                                    <div class="col date-col">Date</div>
                                </div>
                                
                                <div class="table-body">
                                    <c:forEach var="diet" items="${allDiets}">
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
                                            <div class="col user-col">
                                                <span class="user-text">User ${diet.userId}</span>
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
                                </div>
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>

    <!-- User Details Modal -->
    <div id="userDetailsModal" class="modal">
        <div class="modal-content-large">
            <div class="modal-header">
                <h2 id="modalTitle">User Details</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body" id="modalContent">
                <!-- Content will be loaded here -->
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Edit User</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <form id="editUserForm">
                    <input type="hidden" id="editUserId">
                    <div class="form-group">
                        <label for="editUsername">Username</label>
                        <input type="text" id="editUsername" required>
                    </div>
                    <div class="form-group">
                        <label for="editEmail">Email</label>
                        <input type="email" id="editEmail" required>
                    </div>
                    <div class="form-group">
                        <label for="editRole">Role</label>
                        <select id="editRole">
                            <option value="user">User</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeEditModal()">Cancel</button>
                        <button type="submit" class="btn-primary">Save Changes</button>
                    </div>
                </form>
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
        function showAdminTab(tabName) {
            // Remove active class from all panels and nav items
            document.querySelectorAll('.admin-tab-panel').forEach(panel => {
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
                'users': 'User Management',
                'progress': 'Progress Overview', 
                'workouts': 'Workout Activity',
                'diets': 'Diet Activity'
            };
            document.getElementById('contentTitle').textContent = titles[tabName];
        }

        // Global search functionality
        document.getElementById('globalSearch').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const activeTab = document.querySelector('.admin-tab-panel.active');
            
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

        // View user details
        function viewUserDetails(userId, username) {
            document.getElementById('modalTitle').textContent = `${username} - User Details`;
            document.getElementById('modalContent').innerHTML = `
                <div class="user-details">
                    <p>Loading user details for User ID: ${userId}</p>
                    <p>This feature would show comprehensive user information, progress history, and activity summary.</p>
                </div>
            `;
            document.getElementById('userDetailsModal').style.display = 'block';
        }

        // Edit user
        function editUser(userId, username, email, role) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editRole').value = role;
            document.getElementById('editUserModal').style.display = 'block';
        }

        // Delete user
        function deleteUser(userId, username) {
            if (confirm(`Are you sure you want to delete user "${username}"? This action cannot be undone.`)) {
                // In a real application, this would make an AJAX call to delete the user
                alert(`User "${username}" would be deleted. (This is a demo - no actual deletion performed)`);
            }
        }

        // Close modals
        document.querySelectorAll('.close').forEach(closeBtn => {
            closeBtn.onclick = function() {
                this.closest('.modal').style.display = 'none';
            }
        });

        // Close edit modal
        function closeEditModal() {
            document.getElementById('editUserModal').style.display = 'none';
        }

        // Handle edit form submission
        document.getElementById('editUserForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const userId = document.getElementById('editUserId').value;
            const username = document.getElementById('editUsername').value;
            const email = document.getElementById('editEmail').value;
            const role = document.getElementById('editRole').value;
            
            // In a real application, this would make an AJAX call to update the user
            alert(`User ${userId} would be updated with:\nUsername: ${username}\nEmail: ${email}\nRole: ${role}`);
            closeEditModal();
        });

        // Close modals when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }

        // Refresh data function
        function refreshData() {
            location.reload();
        }

        // Progress filter functionality
        document.getElementById('progressFilter').addEventListener('change', function(e) {
            const filter = e.target.value;
            const progressTab = document.getElementById('progress');
            if (progressTab) {
                const rows = progressTab.querySelectorAll('.table-row');
                rows.forEach(row => {
                    if (filter === 'all') {
                        row.style.display = '';
                    } else {
                        const category = row.dataset.category;
                        if (category === filter) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>
