-- =========================================
-- DATABASE CREATION
-- =========================================
CREATE DATABASE FitnessDB;
GO
USE FitnessDB;
GO

-- =========================================
-- TABLE: Users
-- =========================================
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    age INT CHECK (age > 0),
    height FLOAT CHECK (height > 0),
    weight FLOAT CHECK (weight > 0),
    role NVARCHAR(20) DEFAULT 'user', -- 'user' or 'admin'
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- =========================================
-- TABLE: Workouts
-- =========================================
CREATE TABLE Workouts (
    workout_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    workout_name NVARCHAR(100) NOT NULL,
    duration INT CHECK (duration > 0),  -- minutes
    calories_burned INT CHECK (calories_burned >= 0),
    workout_type NVARCHAR(50),
    description NVARCHAR(500),
    bmi_category NVARCHAR(20),
    date DATE DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
GO

-- =========================================
-- TABLE: Diets
-- =========================================
CREATE TABLE Diets (
    diet_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    meal_name NVARCHAR(100) NOT NULL,
    calories INT CHECK (calories >= 0),
    meal_type NVARCHAR(20),
    description NVARCHAR(500),
    bmi_category NVARCHAR(20),
    date DATE DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
GO

-- =========================================
-- TABLE: Progress
-- =========================================
CREATE TABLE Progress (
    progress_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    weight FLOAT CHECK (weight > 0),
    muscle_mass FLOAT CHECK (muscle_mass >= 0),
    fat_percent FLOAT CHECK (fat_percent >= 0 AND fat_percent <= 100),
    bmi FLOAT CHECK (bmi > 0),
    bmi_category NVARCHAR(20),
    notes NVARCHAR(500),
    date DATE DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
GO

-- =========================================
-- TABLE: Admin (optional)
-- =========================================
CREATE TABLE Admin (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100),
    role NVARCHAR(20) DEFAULT 'admin',
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- =========================================
-- SAMPLE DATA
-- =========================================
INSERT INTO Users (username, password, email, gender, age, height, weight, role)
VALUES 
('johnfit', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'john@example.com', 'Male', 25, 175, 70, 'user'),
('adminfit', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@fitlife.com', 'Male', 30, 180, 75, 'admin');
GO

INSERT INTO Workouts (user_id, workout_name, duration, calories_burned, workout_type, description, bmi_category, date)
VALUES 
(1, 'Push Ups', 30, 200, 'Strength', 'Upper body strength training', 'normal', '2025-10-01'),
(1, 'Running', 45, 400, 'Cardio', 'Morning jog in the park', 'normal', '2025-10-02');
GO

INSERT INTO Diets (user_id, meal_name, calories, meal_type, description, bmi_category, date)
VALUES 
(1, 'Breakfast - Oatmeal', 350, 'Breakfast', 'Healthy oatmeal with fruits', 'normal', '2025-10-01'),
(1, 'Lunch - Chicken Salad', 450, 'Lunch', 'Grilled chicken with mixed greens', 'normal', '2025-10-01');
GO

INSERT INTO Progress (user_id, weight, muscle_mass, fat_percent, bmi, bmi_category, notes, date)
VALUES 
(1, 69.5, 29.0, 15.5, 22.7, 'normal', 'Good progress this week', '2025-10-03');
GO
