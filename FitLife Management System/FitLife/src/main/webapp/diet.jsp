<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Diet Plans | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/admin-workout-diet.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <c:set var="isAdmin" value="${isAdmin}" />
    <c:set var="diets" value="${diets}" />

    <!-- Admin Diet Management Section -->
    <c:if test="${isAdmin}">
        <div class="admin-diet-container">
            <div class="admin-header">
                <h1><i class="fas fa-utensils"></i> Diet Management - Admin</h1>
                <div class="admin-actions">
                    <button class="btn-add" onclick="openAddDietModal()">
                        <i class="fas fa-plus"></i> Add New Diet
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

            <!-- Diet Grid -->
            <div class="diet-grid-admin">
                <c:choose>
                    <c:when test="${not empty diets}">
                        <c:forEach var="diet" items="${diets}">
                            <div class="diet-card-admin">
                                <div class="diet-image">
                                    <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&fm=jpg" 
                                         alt="${diet.mealName}">
                                </div>
                                <div class="diet-content-admin">
                                    <h3>${diet.mealName}</h3>
                                    <p class="diet-description">${diet.description}</p>
                                    <div class="diet-stats">
                                        <span><i class="fas fa-fire"></i> ${diet.calories} cal</span>
                                        <span class="badge ${diet.mealType.toLowerCase()}">${diet.mealType}</span>
                                </div>
                                    <div class="diet-actions">
                                        <button class="btn-edit" onclick="editDietFromCard(this)"
                                                data-id="${diet.dietId}"
                                                data-name="${diet.mealName}"
                                                data-calories="${diet.calories}"
                                                data-type="${diet.mealType}"
                                                data-description="${diet.description}"
                                                data-bmi="${diet.bmiCategory}">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="btn-delete" onclick="deleteDiet(${diet.dietId})">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-utensils"></i>
                            <h3>No Diets Found</h3>
                            <p>Add your first diet to get started!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                    </div>
                </div>

        <!-- Add Diet Modal -->
        <div id="addDietModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Add New Diet</h2>
                    <span class="close" onclick="closeModal('addDietModal')">&times;</span>
                        </div>
                <form action="diet?action=add" method="post" class="modal-form">
                    <div class="form-group">
                        <label>Meal Name</label>
                        <input type="text" name="mealName" required>
                    </div>
                    <div class="form-group">
                        <label>Calories</label>
                        <input type="number" name="calories" required>
                    </div>
                    <div class="form-group">
                        <label>Meal Type</label>
                        <select name="mealType" required>
                            <option value="Breakfast">Breakfast</option>
                            <option value="Lunch">Lunch</option>
                            <option value="Dinner">Dinner</option>
                            <option value="Snack">Snack</option>
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
                        <button type="button" class="btn-cancel" onclick="closeModal('addDietModal')">Cancel</button>
                        <button type="submit" class="btn-submit">Add Diet</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Diet Modal -->
        <div id="editDietModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Edit Diet</h2>
                    <span class="close" onclick="closeModal('editDietModal')">&times;</span>
            </div>
                <form id="editDietForm" action="diet?action=update" method="post" class="modal-form">
                    <input type="hidden" name="id" id="editDietId">
                    <div class="form-group">
                        <label>Meal Name</label>
                        <input type="text" name="mealName" id="editMealName" required>
                    </div>
                    <div class="form-group">
                        <label>Calories</label>
                        <input type="number" name="calories" id="editCalories" required>
                </div>
                    <div class="form-group">
                        <label>Meal Type</label>
                        <select name="mealType" id="editMealType" required>
                            <option value="Breakfast">Breakfast</option>
                            <option value="Lunch">Lunch</option>
                            <option value="Dinner">Dinner</option>
                            <option value="Snack">Snack</option>
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
                        <button type="button" class="btn-cancel" onclick="closeModal('editDietModal')">Cancel</button>
                        <button type="submit" class="btn-submit">Update Diet</button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <!-- Regular User View (Original) -->
    <c:if test="${!isAdmin}">
        <!-- Modern Hero Section -->
        <section class="modern-diet-hero">
            <div class="hero-background">
                <div class="hero-overlay"></div>
            </div>
            <div class="hero-content-modern">
                <div class="hero-text">
                    <h1><i class="fas fa-apple-alt"></i> Nourish Your Body</h1>
                    <p>Discover healthy diet plans and nutrition tips designed to fuel your fitness journey</p>
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
        </div>
    </section>
    </c:if>

    <script>
        function openAddDietModal() {
            document.getElementById('addDietModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function editDietFromCard(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name') || '';
            const calories = button.getAttribute('data-calories') || 0;
            const type = button.getAttribute('data-type') || 'Breakfast';
            const description = button.getAttribute('data-description') || '';
            const bmiCategory = button.getAttribute('data-bmi') || 'Normal';
            
            document.getElementById('editDietId').value = id;
            document.getElementById('editMealName').value = name;
            document.getElementById('editCalories').value = calories;
            document.getElementById('editMealType').value = type;
            document.getElementById('editDescription').value = description;
            document.getElementById('editBmiCategory').value = bmiCategory;
            document.getElementById('editDietModal').style.display = 'block';
        }

        function deleteDiet(id) {
            if (confirm('Are you sure you want to delete this diet?')) {
                window.location.href = 'diet?action=delete&id=' + id;
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