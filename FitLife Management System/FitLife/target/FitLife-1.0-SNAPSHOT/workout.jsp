<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Workouts | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-workout-diet.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <c:set var="isAdmin" value="${isAdmin}" />
    <c:set var="workouts" value="${workouts}" />

    <!-- Admin Workout Management Section -->
    <c:if test="${isAdmin}">
        <div class="admin-workout-container">
            <div class="admin-header">
                <h1><i class="fas fa-dumbbell"></i> Workout Management - Admin</h1>
                <div class="admin-actions">
                    <button class="btn-add" onclick="openAddWorkoutModal()">
                        <i class="fas fa-plus"></i> Add New Workout
                    </button>
                    <a href="admin-dashboard" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <!-- Workout Grid -->
            <div class="workout-grid-admin">
                <c:choose>
                    <c:when test="${not empty workouts}">
                        <c:forEach var="workout" items="${workouts}">
                            <div class="workout-card-admin">
                                <div class="workout-image">
                                    <img src="https://img.freepik.com/free-photo/young-powerful-sportsman-training-push-ups-dark-wall_176420-537.jpg" 
                                         alt="${workout.workoutName}">
                                </div>
                                <div class="workout-content-admin">
                                    <h3>${workout.workoutName}</h3>
                                    <p class="workout-description">${workout.description}</p>
                                    <div class="workout-stats">
                                        <span><i class="fas fa-clock"></i> ${workout.duration} min</span>
                                        <span><i class="fas fa-fire"></i> ${workout.caloriesBurned} cal</span>
                                        <span class="badge ${workout.workoutType.toLowerCase()}">${workout.workoutType}</span>
                                    </div>
                                    <div class="workout-actions">
                                        <button class="btn-edit" onclick="editWorkoutFromCard(this)" 
                                                data-id="${workout.workoutId}"
                                                data-name="${workout.workoutName}"
                                                data-duration="${workout.duration}"
                                                data-calories="${workout.caloriesBurned}"
                                                data-type="${workout.workoutType}"
                                                data-description="${workout.description}"
                                                data-bmi="${workout.bmiCategory}">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="btn-delete" onclick="deleteWorkout(${workout.workoutId})">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-dumbbell"></i>
                            <h3>No Workouts Found</h3>
                            <p>Add your first workout to get started!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Add Workout Modal -->
        <div id="addWorkoutModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Add New Workout</h2>
                    <span class="close" onclick="closeModal('addWorkoutModal')">&times;</span>
                </div>
                <form action="workout?action=add" method="post" class="modal-form">
                    <div class="form-group">
                        <label>Workout Name</label>
                        <input type="text" name="workoutName" required>
                    </div>
                    <div class="form-group">
                        <label>Duration (minutes)</label>
                        <input type="number" name="duration" required>
                    </div>
                    <div class="form-group">
                        <label>Calories Burned</label>
                        <input type="number" name="caloriesBurned" required>
                    </div>
                    <div class="form-group">
                        <label>Workout Type</label>
                        <select name="workoutType" required>
                            <option value="Strength">Strength</option>
                            <option value="Cardio">Cardio</option>
                            <option value="Core">Core</option>
                            <option value="Functional">Functional</option>
                            <option value="Plyometric">Plyometric</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>BMI Category</label>
                        <select name="bmiCategory">
                            <option value="Normal">Normal</option>
                            <option value="Underweight">Underweight</option>
                            <option value="Overweight">Overweight</option>
                            <option value="Obese">Obese</option>
                        </select>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-cancel" onclick="closeModal('addWorkoutModal')">Cancel</button>
                        <button type="submit" class="btn-submit">Add Workout</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Workout Modal -->
        <div id="editWorkoutModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Edit Workout</h2>
                    <span class="close" onclick="closeModal('editWorkoutModal')">&times;</span>
                </div>
                <form id="editWorkoutForm" action="workout?action=update" method="post" class="modal-form">
                    <input type="hidden" name="id" id="editWorkoutId">
                    <div class="form-group">
                        <label>Workout Name</label>
                        <input type="text" name="workoutName" id="editWorkoutName" required>
                    </div>
                    <div class="form-group">
                        <label>Duration (minutes)</label>
                        <input type="number" name="duration" id="editDuration" required>
                    </div>
                    <div class="form-group">
                        <label>Calories Burned</label>
                        <input type="number" name="caloriesBurned" id="editCaloriesBurned" required>
                    </div>
                    <div class="form-group">
                        <label>Workout Type</label>
                        <select name="workoutType" id="editWorkoutType" required>
                            <option value="Strength">Strength</option>
                            <option value="Cardio">Cardio</option>
                            <option value="Core">Core</option>
                            <option value="Functional">Functional</option>
                            <option value="Plyometric">Plyometric</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" id="editDescription" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>BMI Category</label>
                        <select name="bmiCategory" id="editBmiCategory">
                            <option value="Normal">Normal</option>
                            <option value="Underweight">Underweight</option>
                            <option value="Overweight">Overweight</option>
                            <option value="Obese">Obese</option>
                        </select>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-cancel" onclick="closeModal('editWorkoutModal')">Cancel</button>
                        <button type="submit" class="btn-submit">Update Workout</button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <!-- Regular User View (Original) -->
    <c:if test="${!isAdmin}">
        <!-- Modern Hero Section -->
        <section class="modern-workouts-hero">
            <div class="hero-background">
                <div class="hero-overlay"></div>
            </div>
            <div class="hero-content-modern">
                <div class="hero-text">
                    <h1><i class="fas fa-dumbbell"></i> Transform Your Body</h1>
                    <p>Discover amazing workout routines designed to help you achieve your fitness goals and live a healthier life</p>
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
            </div>
        </section>
    </c:if>

    <script>
        function openAddWorkoutModal() {
            document.getElementById('addWorkoutModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function editWorkoutFromCard(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name') || '';
            const duration = button.getAttribute('data-duration') || 0;
            const calories = button.getAttribute('data-calories') || 0;
            const type = button.getAttribute('data-type') || 'Strength';
            const description = button.getAttribute('data-description') || '';
            const bmiCategory = button.getAttribute('data-bmi') || 'Normal';
            
            document.getElementById('editWorkoutId').value = id;
            document.getElementById('editWorkoutName').value = name;
            document.getElementById('editDuration').value = duration;
            document.getElementById('editCaloriesBurned').value = calories;
            document.getElementById('editWorkoutType').value = type;
            document.getElementById('editDescription').value = description;
            document.getElementById('editBmiCategory').value = bmiCategory;
            document.getElementById('editWorkoutModal').style.display = 'block';
        }

        function deleteWorkout(id) {
            if (confirm('Are you sure you want to delete this workout?')) {
                window.location.href = 'workout?action=delete&id=' + id;
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }
    </script>
</body>
</html>
