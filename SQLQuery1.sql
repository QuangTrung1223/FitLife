-- =========================================
-- DATABASE CLEAN CREATION SCRIPT
-- Tạo database mới với cấu trúc đã được tối ưu
-- =========================================




USE FitnessDB;
GO
-- =========================================
-- TABLE: Users (đã kết hợp Admin và User)
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
    role NVARCHAR(20) DEFAULT 'user' CHECK (role IN ('user', 'admin')), -- 'user' or 'admin'
    status NVARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    created_at DATETIME DEFAULT GETDATE()
);

ALTER TABLE Users
ADD coach_id INT NULL;

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
-- TABLE: Courses (liên kết với Users)
-- =========================================
CREATE TABLE Courses (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL, -- NULL nếu được tạo bởi admin, hoặc user_id của người tạo
    course_name NVARCHAR(100) NOT NULL,
description NVARCHAR(MAX),
    course_type NVARCHAR(50) NOT NULL,
    suitable_bmi_category NVARCHAR(50),
    duration INT NOT NULL CHECK (duration > 0),
    calories_burned INT NOT NULL CHECK (calories_burned >= 0),
    price DECIMAL(10,2) DEFAULT 0 CHECK (price >= 0),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);
GO

-- =========================================
-- TABLE: Coach
-- =========================================
CREATE TABLE Coach (
    coach_id INT IDENTITY(1,1) PRIMARY KEY,
    coach_name NVARCHAR(100) NOT NULL,
    specialization NVARCHAR(200),
    experience NVARCHAR(200),
    description NVARCHAR(MAX),
    price DECIMAL(10,2),
    rating DECIMAL(3,1),
    certifications NVARCHAR(200),
    location NVARCHAR(200)
);

ALTER TABLE Coach
ADD image_url NVARCHAR(MAX),
    status NVARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'));

ALTER TABLE Users
ADD CONSTRAINT FK_Users_Coach FOREIGN KEY (coach_id)
REFERENCES Coach(coach_id)
ON UPDATE CASCADE
ON DELETE SET NULL; 
GO

-- =========================================
-- TABLE: Cart (Giỏ hàng tạm thời)
-- =========================================
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    item_type NVARCHAR(20) NOT NULL CHECK (item_type IN ('course', 'coach')),
    item_id INT NOT NULL, -- course_id hoặc coach_id
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    added_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE INDEX IX_Cart_User ON Cart(user_id);
CREATE INDEX IX_Cart_Status ON Cart(status);
GO

-- =========================================
-- TABLE: OrderHistory (Lịch sử mua hàng)
-- =========================================
CREATE TABLE OrderHistory (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    item_type NVARCHAR(20) NOT NULL CHECK (item_type IN ('course', 'coach')),
    item_id INT NOT NULL,
    item_name NVARCHAR(200) NOT NULL, -- Lưu tên để không phụ thuộc vào item còn tồn tại
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    order_date DATETIME DEFAULT GETDATE(),
    payment_date DATETIME NULL,
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    order_status NVARCHAR(20) DEFAULT 'active' CHECK (order_status IN ('active', 'completed', 'cancelled', 'expired')),
    start_date DATE NULL, -- Ngày bắt đầu sử dụng
    end_date DATE NULL, -- Ngày kết thúc (nếu có)
    notes NVARCHAR(500),
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);



CREATE INDEX IX_OrderHistory_User ON OrderHistory(user_id);
CREATE INDEX IX_OrderHistory_OrderDate ON OrderHistory(order_date);
CREATE INDEX IX_OrderHistory_PaymentStatus ON OrderHistory(payment_status);
CREATE INDEX IX_OrderHistory_OrderStatus ON OrderHistory(order_status);
GO

-- =========================================
-- VIEW: Order Details
-- =========================================
CREATE VIEW vw_OrderDetails AS
SELECT 
    o.order_id,
    o.user_id,
    u.username,
    u.email,
    o.item_type,
    o.item_id,
    o.item_name,
    CASE 
        WHEN o.item_type = 'course' THEN c.course_name
        WHEN o.item_type = 'coach' THEN co.coach_name
        ELSE o.item_name
    END AS current_item_name,
    o.quantity,
    o.unit_price,
    o.total_amount,
    o.order_date,
    o.payment_date,
    o.payment_method,
    o.payment_status,
    o.order_status,
    o.start_date,
    o.end_date,
    o.notes
FROM OrderHistory o
INNER JOIN Users u ON o.user_id = u.user_id
LEFT JOIN Courses c ON o.item_type = 'course' AND o.item_id = c.course_id
LEFT JOIN Coach co ON o.item_type = 'coach' AND o.item_id = co.coach_id;
GO

-- =========================================
-- SAMPLE DATA
-- =========================================
-- Users (bao gồm cả admin)
INSERT INTO Users (username, password, email, gender, age, height, weight, role)
VALUES 
('johnfit', '12345', 'john@example.com', 'Male', 25, 175, 70, 'user'),
('adminfit', 'admin123', 'admin@fitlife.com', 'Male', 30, 180, 75, 'admin'),
('mike_gym', '12345', 'mike@example.com', 'Male', 28, 178, 72, 'user'),
('sara_health', 'fit2025', 'sara@example.com', 'Female', 27, 162, 52, 'user');
GO

-- Courses (có thể liên kết với user hoặc NULL cho admin-created)
INSERT INTO Courses (user_id, course_name, description, course_type, suitable_bmi_category, duration, calories_burned, price)
VALUES 
(NULL, 'Beginner Strength Training', 'Perfect for those new to strength training', 'Strength', 'normal', 60, 300, 50000),
(NULL, 'Advanced Cardio Workout', 'High-intensity cardio for advanced users', 'Cardio', 'normal', 45, 500, 75000),
(1, 'Personal Yoga Session', 'One-on-one yoga training', 'Flexibility', 'normal', 90, 200, 100000);
GO

-- Workouts (20 bài tập mẫu - cần user_id, dùng admin user_id = 2)
INSERT INTO Workouts (user_id, workout_name, duration, calories_burned, workout_type, description, bmi_category)
VALUES 
(2, 'Push-ups', 20, 250, 'Strength', 'Classic upper body exercise for chest, shoulders, and triceps. Great for building strength and endurance.', 'normal'),
(2, 'Deadlift', 45, 400, 'Strength', 'Powerful compound movement targeting hamstrings, glutes, and lower back. Essential for overall strength.', 'normal'),
(2, 'Squats', 30, 300, 'Strength', 'Fundamental lower body exercise targeting quadriceps, hamstrings, and glutes. Perfect for building leg strength.', 'normal'),
(2, 'Bench Press', 35, 350, 'Strength', 'Classic chest exercise targeting pectorals, anterior deltoids, and triceps. Great for upper body development.', 'normal'),
(2, 'Pull-ups', 25, 200, 'Strength', 'Excellent upper body exercise targeting lats, biceps, and rear deltoids. Builds impressive back strength.', 'normal'),
(2, 'Plank', 15, 100, 'Core', 'Isometric core exercise that strengthens the entire core, shoulders, and glutes. Improves stability.', 'normal'),
(2, 'Jump Rope', 25, 300, 'Cardio', 'High-intensity cardio workout that improves cardiovascular fitness, coordination, and agility.', 'normal'),
(2, 'Bicep Curls', 20, 180, 'Strength', 'Isolation exercise targeting the biceps. Perfect for building arm strength and definition.', 'normal'),
(2, 'Leg Press', 35, 350, 'Strength', 'Machine-based exercise targeting quadriceps, hamstrings, and glutes. Safer alternative to squats.', 'normal'),
(2, 'Sit-ups', 20, 150, 'Core', 'Classic abdominal exercise targeting the rectus abdominis. Great for core strength and definition.', 'normal'),
(2, 'Bench Dips', 20, 160, 'Strength', 'Bodyweight exercise targeting triceps and shoulders. Excellent for upper body strength.', 'normal'),
(2, 'Treadmill Run', 40, 400, 'Cardio', 'Cardiovascular exercise that improves endurance, burns calories, and strengthens the heart.', 'normal'),
(2, 'Russian Twists', 15, 120, 'Core', 'Core exercise targeting obliques and improving rotational strength. Great for functional fitness.', 'normal'),
(2, 'Kettlebell Swings', 30, 250, 'Functional', 'Dynamic exercise targeting posterior chain, core, and cardiovascular system. Builds power and endurance.', 'normal'),
(2, 'Box Jumps', 25, 220, 'Plyometric', 'Plyometric exercise that improves explosive power, agility, and lower body strength.', 'normal'),
(2, 'Shoulder Press', 30, 270, 'Strength', 'Overhead pressing movement targeting deltoids, triceps, and core. Builds shoulder strength.', 'normal'),
(2, 'Lunges', 25, 180, 'Strength', 'Unilateral lower body exercise targeting quadriceps, hamstrings, and glutes. Improves balance.', 'normal'),
(2, 'Burpees', 20, 250, 'Cardio', 'Full-body exercise combining squat, push-up, and jump. Excellent for cardiovascular fitness.', 'normal'),
(2, 'Mountain Climbers', 20, 200, 'Cardio', 'Dynamic core and cardio exercise that improves endurance, agility, and core strength.', 'normal'),
(2, 'Wall Sits', 30, 150, 'Strength', 'Isometric exercise targeting quadriceps and glutes. Great for building leg endurance and strength.', 'normal');
GO

-- Diets (20 bữa ăn mẫu - cần user_id, dùng admin user_id = 2)
INSERT INTO Diets (user_id, meal_name, calories, meal_type, description, bmi_category)
VALUES 
(2, 'Oatmeal with Banana', 320, 'Breakfast', 'Healthy breakfast with oats, banana slices, and honey drizzle. Rich in fiber and potassium.', 'normal'),
(2, 'Scrambled Eggs & Toast', 350, 'Breakfast', 'Protein-packed breakfast with eggs, whole grain toast, and butter. Great source of protein and carbs.', 'normal'),
(2, 'Grilled Chicken Salad', 420, 'Lunch', 'Lean protein salad with mixed greens, tomatoes, cucumbers, and olive oil dressing.', 'normal'),
(2, 'Baked Salmon with Veggies', 480, 'Lunch', 'Omega-3 rich salmon with roasted vegetables. Excellent for heart health and muscle recovery.', 'normal'),
(2, 'Mixed Berry Smoothie', 200, 'Snack', 'Antioxidant-rich smoothie with berries, yogurt, and honey. Great post-workout recovery drink.', 'normal'),
(2, 'Chicken & Rice Bowl', 550, 'Lunch', 'Classic bodybuilding meal with grilled chicken, brown rice, and steamed vegetables.', 'normal'),
(2, 'Sushi Platter', 420, 'Dinner', 'Fresh fish with rice and seaweed. Rich in protein, omega-3, and essential minerals.', 'normal'),
(2, 'Fresh Fruit Bowl', 180, 'Snack', 'Seasonal fruits including apples, oranges, grapes, and berries. Rich in vitamins and antioxidants.', 'normal'),
(2, 'Whole Grain Pasta', 520, 'Dinner', 'Complex carbohydrate meal with whole wheat pasta, tomato sauce, and herbs.', 'normal'),
(2, 'Grilled Steak', 650, 'Dinner', 'Lean beef steak with roasted potatoes and steamed broccoli. High in protein and iron.', 'normal'),
(2, 'Vegetable Soup', 210, 'Lunch', 'Light soup with mixed vegetables, herbs, and vegetable broth. Low calorie and nutritious.', 'normal'),
(2, 'Avocado Toast', 330, 'Breakfast', 'Whole grain bread topped with mashed avocado, eggs, and seasonings. Healthy fats and protein.', 'normal'),
(2, 'Tofu Stir Fry', 400, 'Dinner', 'Plant-based protein with bell peppers, carrots, and soy sauce. Great vegetarian option.', 'normal'),
(2, 'Berry Yogurt Bowl', 260, 'Snack', 'Greek yogurt topped with fresh berries, granola, and honey. High protein and probiotics.', 'normal'),
(2, 'Shrimp Pasta', 530, 'Dinner', 'Seafood pasta with whole wheat noodles, shrimp, and olive oil. Lean protein and complex carbs.', 'normal'),
(2, 'Protein Smoothie', 280, 'Snack', 'Post-workout shake with whey protein, banana, oats, and almond milk.', 'normal'),
(2, 'Caesar Salad', 340, 'Lunch', 'Classic salad with romaine lettuce, croutons, parmesan cheese, and Caesar dressing.', 'normal'),
(2, 'Quinoa Bowl', 450, 'Lunch', 'Superfood grain bowl with quinoa, black beans, vegetables, and tahini dressing.', 'normal'),
(2, 'Turkey Wrap', 380, 'Lunch', 'Lean turkey breast wrapped in whole wheat tortilla with vegetables and hummus.', 'normal'),
(2, 'Green Smoothie', 150, 'Snack', 'Nutrient-dense smoothie with spinach, kale, banana, and coconut water.', 'normal');
GO

-- Coaches (20 huấn luyện viên mẫu)
INSERT INTO Coach (coach_name, specialization, experience, description, image_url, price, rating, certifications, location, status)
VALUES
('Michael Johnson', 'Strength Training', '5 years', 'Professional fitness trainer specializing in Strength Training. With 5 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://img.freepik.com/free-photo/young-powerful-sportsman-training-push-ups-dark-wall_176420-537.jpg', 2000000, 4.5, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Sarah Williams', 'Cardio Fitness', '7 years', 'Professional fitness trainer specializing in Cardio Fitness. With 7 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=1200', 1800000, 4.7, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('David Chen', 'Yoga & Flexibility', '3 years', 'Professional fitness trainer specializing in Yoga & Flexibility. With 3 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/1370779476/photo/shot-of-a-sporty-young-woman-exercising-with-a-barbell-in-a-gym.jpg', 2200000, 4.3, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Emma Brown', 'Weight Loss', '6 years', 'Professional fitness trainer specializing in Weight Loss. With 6 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://t4.ftcdn.net/jpg/00/95/32/41/360_F_95324105_nanCVHMiu7r8B0qSur3k1siBWxacfmII.jpg', 1900000, 4.6, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('James Taylor', 'Muscle Building', '4 years', 'Professional fitness trainer specializing in Muscle Building. With 4 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-4.1.0', 2100000, 4.4, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Olivia Martinez', 'CrossFit', '8 years', 'Professional fitness trainer specializing in CrossFit. With 8 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/628092382/photo/its-great-for-the-abs.jpg', 2500000, 4.9, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Daniel Lee', 'Pilates', '5 years', 'Professional fitness trainer specializing in Pilates. With 5 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/1177167264/photo/quick-feet-quick-feet.jpg', 1700000, 4.2, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Sophia Garcia', 'Boxing', '9 years', 'Professional fitness trainer specializing in Boxing. With 9 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/1400845852/photo/one-activ…-back-stretching-arms-and-triceps-by-pulling-elbow-with.jpg', 2000000, 4.8, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Matthew Wilson', 'Running', '6 years', 'Professional fitness trainer specializing in Running. With 6 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://t4.ftcdn.net/jpg/07/83/29/29/360_F_783292909_0fhoXLONr7v4IUr4jP7dF5Yygp9TMwcA.jpg', 2300000, 4.5, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Isabella Anderson', 'Swimming', '4 years', 'Professional fitness trainer specializing in Swimming. With 4 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/1252207646/photo/man-kick-boxer-training-alone-in-gym.jpg', 1850000, 4.3, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Christopher Moore', 'HIIT', '7 years', 'Professional fitness trainer specializing in HIIT. With 7 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://t4.ftcdn.net/jpg/03/82/37/89/360_F_382378953_Dcp6TQjMlVym6dg24IdsXDZGkrYpORIS.jpg', 2400000, 4.7, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Ava Jackson', 'Powerlifting', '5 years', 'Professional fitness trainer specializing in Powerlifting. With 5 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.pexels.com/photos/421160/pexels-photo-421160.jpeg', 1950000, 4.4, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Andrew Thomas', 'Bodybuilding', '6 years', 'Professional fitness trainer specializing in Bodybuilding. With 6 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/1857910044/photo/slim-woman-practicing-yoga-in-seated-spinal-twist-pose.jpg', 2150000, 4.6, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Mia White', 'Calisthenics', '8 years', 'Professional fitness trainer specializing in Calisthenics. With 8 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=1200', 2000000, 4.8, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Joshua Harris', 'Dance Fitness', '5 years', 'Professional fitness trainer specializing in Dance Fitness. With 5 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://media.istockphoto.com/id/1310511832/photo/asian-woman-stretching-her-back-in-a-training-gym.jpg', 2250000, 4.5, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Charlotte Martin', 'Martial Arts', '4 years', 'Professional fitness trainer specializing in Martial Arts. With 4 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://t3.ftcdn.net/jpg/03/16/08/66/360_F_316086673_NfxzsibpOdTYFDQZ9SUsaxQbheBZSHbf.jpg', 1800000, 4.2, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Ryan Thompson', 'Cycling', '7 years', 'Professional fitness trainer specializing in Cycling. With 7 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop', 2100000, 4.7, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Amelia Clark', 'Functional Training', '6 years', 'Professional fitness trainer specializing in Functional Training. With 6 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300&h=200&fit=crop', 2050000, 4.5, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Tyler Rodriguez', 'Rehabilitation', '5 years', 'Professional fitness trainer specializing in Rehabilitation. With 5 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=200&fit=crop', 1950000, 4.3, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active'),
('Harper Lewis', 'Athletic Performance', '9 years', 'Professional fitness trainer specializing in Athletic Performance. With 9 years of experience, I help clients achieve their fitness goals through personalized training programs.', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop', 2200000, 4.9, 'NASM Certified, CPR/AED', 'Ho Chi Minh City', 'active');
GO
select * from users
-- Sample Orders
INSERT INTO OrderHistory (user_id, item_type, item_id, item_name, quantity, unit_price, total_amount, payment_status, order_status)
VALUES 
(1, 'course', 1, 'Beginner Strength Training', 1, 50000, 50000, 'paid', 'active'),
(1, 'coach', 1, 'John Trainer', 1, 200000, 200000, 'paid', 'active'),
(3, 'course', 2, 'Advanced Cardio Workout', 1, 75000, 75000, 'pending', 'active');
GO

PRINT '=========================================';
PRINT 'DATABASE ĐÃ ĐƯỢC TẠO THÀNH CÔNG';
PRINT '=========================================';
PRINT 'Tables đã tạo:';
PRINT '  - Users (kết hợp admin và user)';
PRINT '  - Workouts';
PRINT '  - Diets';
PRINT '  - Progress';
PRINT '  - Courses (liên kết với Users)';
PRINT '  - Coach';
PRINT '  - Cart (giỏ hàng)';
PRINT '  - OrderHistory (lịch sử mua hàng)';
PRINT '  - View: vw_OrderDetails';
PRINT '=========================================';
GO