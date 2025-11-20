<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BMI Calculator | FitLife</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="modern-bmi-calculator">
        <div class="calculator-header-modern">
            <div class="header-content">
                <h1><i class="fas fa-calculator"></i> BMI Calculator</h1>
                <p>Calculate your Body Mass Index and get personalized health recommendations</p>
            </div>
        </div>

        <div class="calculator-layout">
            <!-- Calculator Form -->
            <div class="calculator-section">
                <div class="section-header">
                    <h2><i class="fas fa-user"></i> Your Body Information</h2>
                    <p>Enter your measurements to calculate your BMI</p>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="error-message-modern">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="bmi-calculator" method="post" class="modern-form">
                    <div class="input-group">
                        <div class="input-field">
                            <label for="height">
                                <i class="fas fa-ruler-vertical"></i>
                                Height (cm)
                            </label>
                            <div class="input-wrapper">
                                <input type="number" id="height" name="height" step="0.1" min="100" max="250" 
                                       placeholder="170" required>
                                <span class="input-unit">cm</span>
                            </div>
                        </div>

                        <div class="input-field">
                            <label for="weight">
                                <i class="fas fa-weight"></i>
                                Weight (kg)
                            </label>
                            <div class="input-wrapper">
                                <input type="number" id="weight" name="weight" step="0.1" min="20" max="300" 
                                       placeholder="70" required>
                                <span class="input-unit">kg</span>
                            </div>
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-field">
                            <label for="muscleMass">
                                <i class="fas fa-dumbbell"></i>
                                Muscle Mass (kg)
                            </label>
                            <div class="input-wrapper">
                                <input type="number" id="muscleMass" name="muscleMass" step="0.1" min="0" 
                                       placeholder="25">
                                <span class="input-unit">kg</span>
                            </div>
                            <small class="field-note">Optional</small>
                        </div>

                        <div class="input-field">
                            <label for="fatPercent">
                                <i class="fas fa-percentage"></i>
                                Body Fat (%)
                            </label>
                            <div class="input-wrapper">
                                <input type="number" id="fatPercent" name="fatPercent" step="0.1" min="0" max="100" 
                                       placeholder="15">
                                <span class="input-unit">%</span>
                            </div>
                            <small class="field-note">Optional</small>
                        </div>
                    </div>

                    <div class="input-field full-width">
                        <label for="notes">
                            <i class="fas fa-sticky-note"></i>
                            Additional Notes
                        </label>
                        <textarea id="notes" name="notes" rows="3" 
                                  placeholder="Any additional health information or goals..."></textarea>
                    </div>

                    <button type="submit" class="calculate-btn">
                        <i class="fas fa-calculator"></i>
                        <span>Calculate BMI & Save</span>
                    </button>
                </form>
            </div>

            <!-- BMI Preview & Info -->
            <div class="bmi-preview-section">
                <div class="bmi-preview-card">
                    <h3><i class="fas fa-chart-line"></i> BMI Preview</h3>
                    <div class="bmi-preview-content">
                        <div class="bmi-preview-value" id="bmiPreview">
                            <span class="preview-number">--</span>
                            <span class="preview-label">BMI</span>
                        </div>
                        <div class="bmi-preview-category" id="bmiCategoryPreview">
                            <span class="preview-category">Enter your data</span>
                        </div>
                    </div>
                </div>

                <div class="bmi-info-modern">
                    <h3><i class="fas fa-info-circle"></i> BMI Categories</h3>
                    <div class="bmi-categories-modern">
                        <div class="bmi-category-item">
                            <div class="category-indicator underweight"></div>
                            <div class="category-info">
                                <span class="category-name">Underweight</span>
                                <span class="category-range">BMI < 18.5</span>
                            </div>
                        </div>
                        <div class="bmi-category-item">
                            <div class="category-indicator normal"></div>
                            <div class="category-info">
                                <span class="category-name">Normal</span>
                                <span class="category-range">BMI 18.5 - 24.9</span>
                            </div>
                        </div>
                        <div class="bmi-category-item">
                            <div class="category-indicator overweight"></div>
                            <div class="category-info">
                                <span class="category-name">Overweight</span>
                                <span class="category-range">BMI 25 - 29.9</span>
                            </div>
                        </div>
                        <div class="bmi-category-item">
                            <div class="category-indicator obese"></div>
                            <div class="category-info">
                                <span class="category-name">Obese</span>
                                <span class="category-range">BMI ≥ 30</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tips-card">
                    <h3><i class="fas fa-lightbulb"></i> Tips</h3>
                    <ul class="tips-list">
                        <li><i class="fas fa-check"></i> Measure your height without shoes</li>
                        <li><i class="fas fa-check"></i> Weigh yourself in the morning for accuracy</li>
                        <li><i class="fas fa-check"></i> BMI is a screening tool, not diagnostic</li>
                        <li><i class="fas fa-check"></i> Consult healthcare provider for health advice</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Real-time BMI calculation
        function calculateBMIPreview() {
            const height = parseFloat(document.getElementById('height').value);
            const weight = parseFloat(document.getElementById('weight').value);
            
            if (height && weight && height > 0 && weight > 0) {
                const heightInMeters = height / 100;
                const bmi = weight / (heightInMeters * heightInMeters);
                const bmiRounded = bmi.toFixed(1);
                
                // Update preview
                document.querySelector('.preview-number').textContent = bmiRounded;
                
                // Determine category
                let category = '';
                let categoryClass = '';
                if (bmi < 18.5) {
                    category = 'Underweight';
                    categoryClass = 'underweight';
                } else if (bmi < 25) {
                    category = 'Normal';
                    categoryClass = 'normal';
                } else if (bmi < 30) {
                    category = 'Overweight';
                    categoryClass = 'overweight';
                } else {
                    category = 'Obese';
                    categoryClass = 'obese';
                }
                
                // Update category preview
                const categoryElement = document.querySelector('.preview-category');
                categoryElement.textContent = category;
                categoryElement.className = `preview-category ${categoryClass}`;
                
                // Highlight corresponding category in info
                document.querySelectorAll('.bmi-category-item').forEach(item => {
                    item.classList.remove('active');
                });
                document.querySelector(`.category-indicator.${categoryClass}`).parentElement.classList.add('active');
            } else {
                document.querySelector('.preview-number').textContent = '--';
                document.querySelector('.preview-category').textContent = 'Enter your data';
                document.querySelector('.preview-category').className = 'preview-category';
                document.querySelectorAll('.bmi-category-item').forEach(item => {
                    item.classList.remove('active');
                });
            }
        }

        // Add event listeners
        document.getElementById('height').addEventListener('input', calculateBMIPreview);
        document.getElementById('weight').addEventListener('input', calculateBMIPreview);

        // Calculate on page load if values exist
        document.addEventListener('DOMContentLoaded', calculateBMIPreview);
    </script>
</body>
</html>
