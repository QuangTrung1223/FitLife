<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Progress Tracking - FitLife</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="admin-body">
    <div class="admin-dashboard-container">
        <!-- Top Header Bar -->
        <header class="admin-top-bar">
            <div class="admin-welcome-section">
                <h1 class="admin-title">
                    <i class="fas fa-chart-line"></i> Progress Tracking
                </h1>
                <p class="admin-subtitle">Monitor user progress and fitness journeys</p>
            </div>
            <div class="admin-actions-section">
                <a href="admin-dashboard" class="admin-action-btn refresh">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                <button class="admin-action-btn export" onclick="exportProgressData()">
                    <i class="fas fa-file-export"></i> Export Data
                </button>
                <span class="admin-time">
                    <i class="fas fa-clock"></i> <span id="current-time"></span>
                </span>
            </div>
        </header>

        <!-- Main Content -->
        <div class="admin-main-grid">
            <!-- Sidebar with Statistics -->
            <aside class="admin-sidebar">
                <div class="sidebar-section">
                    <h3 class="sidebar-title">Progress Statistics</h3>
                    <div class="quick-stats">
                        <div class="quick-stat-item">
                            <span class="stat-icon progress"><i class="fas fa-chart-line"></i></span>
                            <div class="stat-info">
                                <span class="stat-number">${totalProgressRecords}</span>
                                <span class="stat-label">Total Records</span>
                            </div>
                        </div>
                        <div class="quick-stat-item">
                            <span class="stat-icon users"><i class="fas fa-users"></i></span>
                            <div class="stat-info">
                                <span class="stat-number">${totalUsers}</span>
                                <span class="stat-label">Total Users</span>
                            </div>
                        </div>
                        <div class="quick-stat-item">
                            <span class="stat-icon active"><i class="fas fa-user-check"></i></span>
                            <div class="stat-info">
                                <span class="stat-number">${usersWithProgress}</span>
                                <span class="stat-label">Active Users</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="sidebar-section">
                    <h3 class="sidebar-title">BMI Distribution</h3>
                    <div class="bmi-distribution">
                        <c:set var="normalCount" value="0" />
                        <c:set var="overweightCount" value="0" />
                        <c:set var="obeseCount" value="0" />
                        <c:set var="underweightCount" value="0" />
                        
                        <c:forEach var="progress" items="${allProgress}">
                            <c:choose>
                                <c:when test="${progress.bmiCategory == 'normal'}">
                                    <c:set var="normalCount" value="${normalCount + 1}" />
                                </c:when>
                                <c:when test="${progress.bmiCategory == 'overweight'}">
                                    <c:set var="overweightCount" value="${overweightCount + 1}" />
                                </c:when>
                                <c:when test="${progress.bmiCategory == 'obese'}">
                                    <c:set var="obeseCount" value="${obeseCount + 1}" />
                                </c:when>
                                <c:when test="${progress.bmiCategory == 'underweight'}">
                                    <c:set var="underweightCount" value="${underweightCount + 1}" />
                                </c:when>
                            </c:choose>
                        </c:forEach>
                        
                        <div class="bmi-stat">
                            <span class="bmi-label normal">Normal</span>
                            <span class="bmi-count">${normalCount}</span>
                        </div>
                        <div class="bmi-stat">
                            <span class="bmi-label overweight">Overweight</span>
                            <span class="bmi-count">${overweightCount}</span>
                        </div>
                        <div class="bmi-stat">
                            <span class="bmi-label obese">Obese</span>
                            <span class="bmi-count">${obeseCount}</span>
                        </div>
                        <div class="bmi-stat">
                            <span class="bmi-label underweight">Underweight</span>
                            <span class="bmi-count">${underweightCount}</span>
                        </div>
                    </div>
                </div>
            </aside>

            <!-- Content Area -->
            <main class="admin-content-area">
                <!-- Content Header -->
                <div class="content-header">
                    <h2 id="content-title"><i class="fas fa-chart-line"></i> User Progress Overview</h2>
                    <div class="content-actions">
                        <div class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search users..." id="progress-search">
                        </div>
                        <select class="filter-select" id="bmi-filter">
                            <option value="all">All BMI Categories</option>
                            <option value="normal">Normal</option>
                            <option value="overweight">Overweight</option>
                            <option value="obese">Obese</option>
                            <option value="underweight">Underweight</option>
                        </select>
                    </div>
                </div>

                <!-- Progress Data Table -->
                <div class="data-table-container">
                    <div class="table-header">
                        <div class="table-title">
                            <i class="fas fa-table"></i> All Progress Records
                        </div>
                        <div class="table-filters">
                            <select class="filter-select" id="user-filter">
                                <option value="all">All Users</option>
                                <c:forEach var="user" items="${allUsers}">
                                    <option value="${user.id}">${user.username}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <table class="modern-table">
                        <thead>
                            <tr class="table-header-row">
                                <th class="col">User</th>
                                <th class="col">Date</th>
                                <th class="col">Weight</th>
                                <th class="col">BMI</th>
                                <th class="col">Category</th>
                                <th class="col">Muscle Mass</th>
                                <th class="col">Fat %</th>
                                <th class="col">Notes</th>
                                <th class="col">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="table-body">
                            <c:choose>
                                <c:when test="${not empty allProgress}">
                                    <c:forEach var="progress" items="${allProgress}">
                                        <c:set var="user" value="${null}" />
                                        <c:forEach var="u" items="${allUsers}">
                                            <c:if test="${u.id == progress.userId}">
                                                <c:set var="user" value="${u}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <tr class="table-row" data-user-id="${progress.userId}" data-bmi-category="${progress.bmiCategory}">
                                            <td class="col user-cell">
                                                <div class="user-avatar-small">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                                <div class="user-details">
                                                    <span class="username">${user.username}</span>
                                                    <span class="user-email">${user.email}</span>
                                                </div>
                                            </td>
                                            <td class="col date-text">
                                                <fmt:formatDate value="${progress.date}" pattern="dd-MM-yyyy"/>
                                            </td>
                                            <td class="col metric-value">${progress.weight} kg</td>
                                            <td class="col bmi-value">${progress.bmi}</td>
                                            <td class="col">
                                                <span class="bmi-badge ${progress.bmiCategory}">${progress.bmiCategory}</span>
                                            </td>
                                            <td class="col metric-value">${progress.muscleMass} kg</td>
                                            <td class="col metric-value">${progress.fatPercent}%</td>
                                            <td class="col notes-text">${progress.notes}</td>
                                            <td class="col action-buttons">
                                                <button class="action-btn view" onclick="viewProgressDetails('${progress.id}')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="action-btn edit" onclick="editProgress('${progress.id}')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="action-btn delete" onclick="deleteProgress('${progress.id}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="empty-state">
                                            <i class="fas fa-chart-line"></i>
                                            <h3>No Progress Records Found</h3>
                                            <p>No progress records are available to display.</p>
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

    <!-- Modal for Viewing Progress Details -->
    <div class="modal" id="view-progress-modal">
        <div class="modal-content modal-content-large">
            <div class="modal-header">
                <h2>Progress Details</h2>
                <span class="close" onclick="closeModal('view-progress-modal')">&times;</span>
            </div>
            <div class="modal-body">
                <div class="progress-details-grid">
                    <div class="detail-section">
                        <h3><i class="fas fa-user"></i> User Information</h3>
                        <div class="detail-item">
                            <label>Username:</label>
                            <span id="view-username"></span>
                        </div>
                        <div class="detail-item">
                            <label>Email:</label>
                            <span id="view-email"></span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h3><i class="fas fa-chart-line"></i> Progress Metrics</h3>
                        <div class="detail-item">
                            <label>Date:</label>
                            <span id="view-date"></span>
                        </div>
                        <div class="detail-item">
                            <label>Weight:</label>
                            <span id="view-weight"></span>
                        </div>
                        <div class="detail-item">
                            <label>BMI:</label>
                            <span id="view-bmi"></span>
                        </div>
                        <div class="detail-item">
                            <label>Category:</label>
                            <span id="view-category"></span>
                        </div>
                        <div class="detail-item">
                            <label>Muscle Mass:</label>
                            <span id="view-muscle"></span>
                        </div>
                        <div class="detail-item">
                            <label>Fat Percentage:</label>
                            <span id="view-fat"></span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h3><i class="fas fa-sticky-note"></i> Notes</h3>
                        <div class="notes-content" id="view-notes"></div>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeModal('view-progress-modal')">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Update current time
        function updateTime() {
            const now = new Date();
            const options = { hour: '2-digit', minute: '2-digit', hour12: true };
            document.getElementById('current-time').textContent = now.toLocaleTimeString('en-US', options);
        }
        setInterval(updateTime, 1000);
        updateTime();

        // Modal functions
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Search functionality
        document.getElementById('progress-search').addEventListener('input', function(e) {
            const searchText = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.table-row');
            rows.forEach(row => {
                const username = row.querySelector('.username').textContent.toLowerCase();
                const email = row.querySelector('.user-email').textContent.toLowerCase();
                row.style.display = (username.includes(searchText) || email.includes(searchText)) ? '' : 'none';
            });
        });

        // BMI filter functionality
        document.getElementById('bmi-filter').addEventListener('change', function(e) {
            const selectedCategory = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.table-row');
            rows.forEach(row => {
                const bmiCategory = row.getAttribute('data-bmi-category');
                row.style.display = (selectedCategory === 'all' || bmiCategory === selectedCategory) ? '' : 'none';
            });
        });

        // User filter functionality
        document.getElementById('user-filter').addEventListener('change', function(e) {
            const selectedUserId = e.target.value;
            const rows = document.querySelectorAll('.table-row');
            rows.forEach(row => {
                const userId = row.getAttribute('data-user-id');
                row.style.display = (selectedUserId === 'all' || userId === selectedUserId) ? '' : 'none';
            });
        });

        // Placeholder functions for actions
        function viewProgressDetails(progressId) {
            // Implement view progress details logic
            alert('View progress details: ' + progressId);
        }

        function editProgress(progressId) {
            // Implement edit progress logic
            alert('Edit progress: ' + progressId);
        }

        function deleteProgress(progressId) {
            if (confirm('Are you sure you want to delete this progress record?')) {
                // Implement delete progress logic
                alert('Progress record deleted: ' + progressId);
            }
        }

        function exportProgressData() {
            // Implement export functionality
            alert('Exporting progress data...');
        }
    </script>
</body>
</html>


