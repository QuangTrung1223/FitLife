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
public class Progress {
    private int progressId;
    private int userId;
    private double weight;
    private double muscleMass;
    private double fatPercent;
    private double bmi;
    private String bmiCategory; // underweight, normal, overweight, obese
    private LocalDate date;
    private String notes;

    public Progress() {}

    public Progress(int progressId, int userId, double weight, double muscleMass, double fatPercent, double bmi, String bmiCategory, LocalDate date, String notes) {
        this.progressId = progressId;
        this.userId = userId;
        this.weight = weight;
        this.muscleMass = muscleMass;
        this.fatPercent = fatPercent;
        this.bmi = bmi;
        this.bmiCategory = bmiCategory;
        this.date = date;
        this.notes = notes;
    }

    public int getProgressId() { return progressId; }
    public void setProgressId(int progressId) { this.progressId = progressId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public double getMuscleMass() { return muscleMass; }
    public void setMuscleMass(double muscleMass) { this.muscleMass = muscleMass; }

    public double getFatPercent() { return fatPercent; }
    public void setFatPercent(double fatPercent) { this.fatPercent = fatPercent; }

    public double getBmi() { return bmi; }
    public void setBmi(double bmi) { this.bmi = bmi; }

    public String getBmiCategory() { return bmiCategory; }
    public void setBmiCategory(String bmiCategory) { this.bmiCategory = bmiCategory; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
