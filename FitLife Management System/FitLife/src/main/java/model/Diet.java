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
public class Diet {
    private int dietId;
   
    private String mealName;
    private int calories;
    private String mealType; // breakfast, lunch, dinner, snack
    private String description;
    private LocalDate date;
    private String bmiCategory; // underweight, normal, overweight, obese

    public Diet() {}

    public Diet(int dietId, int userId, String mealName, int calories, String mealType, String description, LocalDate date, String bmiCategory) {
        this.dietId = dietId;
     
        this.mealName = mealName;
        this.calories = calories;
        this.mealType = mealType;
        this.description = description;
        this.date = date;
        this.bmiCategory = bmiCategory;
    }

    public int getDietId() { return dietId; }
    public void setDietId(int dietId) { this.dietId = dietId; }

    

    public String getMealName() { return mealName; }
    public void setMealName(String mealName) { this.mealName = mealName; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public String getMealType() { return mealType; }
    public void setMealType(String mealType) { this.mealType = mealType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getBmiCategory() { return bmiCategory; }
    public void setBmiCategory(String bmiCategory) { this.bmiCategory = bmiCategory; }
}
