/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;

/**
 *
 * @author Guang Trump
 */
public class Workout {
    private int workoutId;
   
    private String workoutName;
    private int duration; // minutes
    private int caloriesBurned;
    private String workoutType; // cardio, strength, flexibility, etc.
    private String description;
    private LocalDate date;
    private String bmiCategory; // underweight, normal, overweight, obese

    public Workout() {}

    public Workout(int workoutId, int userId, String workoutName, int duration, int caloriesBurned, String workoutType, String description, LocalDate date, String bmiCategory) {
        this.workoutId = workoutId;
        
        this.workoutName = workoutName;
        this.duration = duration;
        this.caloriesBurned = caloriesBurned;
        this.workoutType = workoutType;
        this.description = description;
        this.date = date;
        this.bmiCategory = bmiCategory;
    }

    public int getWorkoutId() { return workoutId; }
    public void setWorkoutId(int workoutId) { this.workoutId = workoutId; }

    public String getWorkoutName() { return workoutName; }
    public void setWorkoutName(String workoutName) { this.workoutName = workoutName; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public int getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(int caloriesBurned) { this.caloriesBurned = caloriesBurned; }

    public String getWorkoutType() { return workoutType; }
    public void setWorkoutType(String workoutType) { this.workoutType = workoutType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getBmiCategory() { return bmiCategory; }
    public void setBmiCategory(String bmiCategory) { this.bmiCategory = bmiCategory; }
}
