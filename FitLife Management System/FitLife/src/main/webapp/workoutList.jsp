<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Workouts</title>
    <link rel="stylesheet" href="../css/admin.css">
</head>
<body>
<%@ include file="adminHeader.jsp" %>

<h2>🏋️‍♂️ Manage Workouts</h2>

<a href="workout?action=add" class="btn btn-primary">➕ Add New Workout</a>

<table border="1" cellpadding="10" cellspacing="0" style="margin-top:20px; width:90%;">
    <tr style="background:#ddd;">
        <th>ID</th>
        <th>Name</th>
        <th>Type</th>
        <th>Duration (min)</th>
        <th>Calories</th>
        <th>BMI Category</th>
        <th>Description</th>
        <th>Action</th>
    </tr>
    <c:forEach var="w" items="${workouts}">
        <tr>
            <td>${w.workoutId}</td>
            <td>${w.workoutName}</td>
            <td>${w.workoutType}</td>
            <td>${w.duration}</td>
            <td>${w.caloriesBurned}</td>
            <td>${w.bmiCategory}</td>
            <td>${w.description}</td>
            <td>
                <a href="workout?action=edit&id=${w.workoutId}" class="btn btn-warning">✏️ Edit</a>
                <a href="workout?action=delete&id=${w.workoutId}" 
                   class="btn btn-danger" 
                   onclick="return confirm('Are you sure to delete this workout?')">🗑 Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>
