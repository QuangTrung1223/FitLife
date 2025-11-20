<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Workout</title>
    <link rel="stylesheet" href="../css/admin.css">
</head>
<body>
<%@ include file="adminHeader.jsp" %>

<h2>✏️ Edit Workout</h2>

<form action="workout" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="workoutId" value="${workout.workoutId}">

    <label>Workout Name:</label>
    <input type="text" name="workoutName" value="${workout.workoutName}" required><br>

    <label>Workout Type:</label>
    <input type="text" name="workoutType" value="${workout.workoutType}" required><br>

    <label>Duration (minutes):</label>
    <input type="number" name="duration" value="${workout.duration}" required><br>

    <label>Calories Burned:</label>
    <input type="number" name="caloriesBurned" value="${workout.caloriesBurned}" required><br>

    <label>BMI Category:</label>
    <input type="text" name="bmiCategory" value="${workout.bmiCategory}" required><br>

    <label>Description:</label><br>
    <textarea name="description" rows="5" cols="40">${workout.description}</textarea><br><br>

    <button type="submit">Update Workout</button>
    <a href="workout" class="btn">Cancel</a>
</form>

</body>
</html>
