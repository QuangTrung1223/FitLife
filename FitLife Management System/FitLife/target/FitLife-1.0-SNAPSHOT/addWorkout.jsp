<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Workout</title>
    <link rel="stylesheet" href="../css/admin.css">
</head>
<body>
<%@ include file="adminHeader.jsp" %>

<h2>➕ Add New Workout</h2>

<form action="workout" method="post">
    <input type="hidden" name="action" value="create">

    <label>Workout Name:</label>
    <input type="text" name="workoutName" required><br>

    <label>Workout Type:</label>
    <input type="text" name="workoutType" required><br>

    <label>Duration (minutes):</label>
    <input type="number" name="duration" required><br>

    <label>Calories Burned:</label>
    <input type="number" name="caloriesBurned" required><br>

    <label>BMI Category:</label>
    <input type="text" name="bmiCategory" required><br>

    <label>Description:</label><br>
    <textarea name="description" rows="5" cols="40"></textarea><br><br>

    <button type="submit">Save Workout</button>
    <a href="workout" class="btn">Cancel</a>
</form>

</body>
</html>
