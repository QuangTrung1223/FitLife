package model;

import java.sql.Timestamp;

public class Course {
    private int id;
    private String courseName;
    private String description;
    private String courseType;
    private String suitableBmiCategory;
    private int duration;
    private int caloriesBurned;
    private Timestamp createdAt;

    public Course(int id, String courseName, String description, String courseType, 
                 String suitableBmiCategory, int duration, int caloriesBurned, Timestamp createdAt) {
        this.id = id;
        this.courseName = courseName;
        this.description = description;
        this.courseType = courseType;
        this.suitableBmiCategory = suitableBmiCategory;
        this.duration = duration;
        this.caloriesBurned = caloriesBurned;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCourseType() { return courseType; }
    public void setCourseType(String courseType) { this.courseType = courseType; }
    public String getSuitableBmiCategory() { return suitableBmiCategory; }
    public void setSuitableBmiCategory(String suitableBmiCategory) { this.suitableBmiCategory = suitableBmiCategory; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public int getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(int caloriesBurned) { this.caloriesBurned = caloriesBurned; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}