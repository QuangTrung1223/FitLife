package controller;

import dal.DietDAO;
import dal.WorkoutDAO;
import model.Diet;
import model.Workout;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SampleDataServlet", urlPatterns = {"/admin/add-sample-data"})
public class SampleDataServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        String userRole = (String) session.getAttribute("user_role");
        
        // Admin check
        if (sessionLogin == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        WorkoutDAO workoutDAO = new WorkoutDAO();
        DietDAO dietDAO = new DietDAO();
        
        try {
            // Add 20 sample workouts
            addSampleWorkouts(workoutDAO);
            
            // Add 20 sample diets
            addSampleDiets(dietDAO);
            
            session.setAttribute("success", "Sample data added successfully! 20 workouts and 20 diets have been added.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to add sample data: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
    }
    
    private void addSampleWorkouts(WorkoutDAO workoutDAO) {
        List<Workout> workouts = new ArrayList<>();
        
        workouts.add(new Workout(0, 0, "Push-ups", 20, 250, "Strength", "Classic upper body exercise for chest, shoulders, and triceps. Great for building strength and endurance.", null, null));
        workouts.add(new Workout(0, 0, "Deadlift", 45, 400, "Strength", "Powerful compound movement targeting hamstrings, glutes, and lower back. Essential for overall strength.", null, null));
        workouts.add(new Workout(0, 0, "Squats", 30, 300, "Strength", "Fundamental lower body exercise targeting quadriceps, hamstrings, and glutes. Perfect for building leg strength.", null, null));
        workouts.add(new Workout(0, 0, "Bench Press", 35, 350, "Strength", "Classic chest exercise targeting pectorals, anterior deltoids, and triceps. Great for upper body development.", null, null));
        workouts.add(new Workout(0, 0, "Pull-ups", 25, 200, "Strength", "Excellent upper body exercise targeting lats, biceps, and rear deltoids. Builds impressive back strength.", null, null));
        workouts.add(new Workout(0, 0, "Plank", 15, 100, "Core", "Isometric core exercise that strengthens the entire core, shoulders, and glutes. Improves stability.", null, null));
        workouts.add(new Workout(0, 0, "Jump Rope", 25, 300, "Cardio", "High-intensity cardio workout that improves cardiovascular fitness, coordination, and agility.", null, null));
        workouts.add(new Workout(0, 0, "Bicep Curls", 20, 180, "Strength", "Isolation exercise targeting the biceps. Perfect for building arm strength and definition.", null, null));
        workouts.add(new Workout(0, 0, "Leg Press", 35, 350, "Strength", "Machine-based exercise targeting quadriceps, hamstrings, and glutes. Safer alternative to squats.", null, null));
        workouts.add(new Workout(0, 0, "Sit-ups", 20, 150, "Core", "Classic abdominal exercise targeting the rectus abdominis. Great for core strength and definition.", null, null));
        workouts.add(new Workout(0, 0, "Bench Dips", 20, 160, "Strength", "Bodyweight exercise targeting triceps and shoulders. Excellent for upper body strength.", null, null));
        workouts.add(new Workout(0, 0, "Treadmill Run", 40, 400, "Cardio", "Cardiovascular exercise that improves endurance, burns calories, and strengthens the heart.", null, null));
        workouts.add(new Workout(0, 0, "Russian Twists", 15, 120, "Core", "Core exercise targeting obliques and improving rotational strength. Great for functional fitness.", null, null));
        workouts.add(new Workout(0, 0, "Kettlebell Swings", 30, 250, "Functional", "Dynamic exercise targeting posterior chain, core, and cardiovascular system. Builds power and endurance.", null, null));
        workouts.add(new Workout(0, 0, "Box Jumps", 25, 220, "Plyometric", "Plyometric exercise that improves explosive power, agility, and lower body strength.", null, null));
        workouts.add(new Workout(0, 0, "Shoulder Press", 30, 270, "Strength", "Overhead pressing movement targeting deltoids, triceps, and core. Builds shoulder strength.", null, null));
        workouts.add(new Workout(0, 0, "Lunges", 25, 180, "Strength", "Unilateral lower body exercise targeting quadriceps, hamstrings, and glutes. Improves balance.", null, null));
        workouts.add(new Workout(0, 0, "Burpees", 20, 250, "Cardio", "Full-body exercise combining squat, push-up, and jump. Excellent for cardiovascular fitness.", null, null));
        workouts.add(new Workout(0, 0, "Mountain Climbers", 20, 200, "Cardio", "Dynamic core and cardio exercise that improves endurance, agility, and core strength.", null, null));
        workouts.add(new Workout(0, 0, "Wall Sits", 30, 150, "Strength", "Isometric exercise targeting quadriceps and glutes. Great for building leg endurance and strength.", null, null));
        
        for (Workout workout : workouts) {
            workoutDAO.addWorkout(workout);
        }
    }

    private void addSampleDiets(DietDAO dietDAO) {
        List<Diet> diets = new ArrayList<>();
        
        diets.add(new Diet(0, 0, "Oatmeal with Banana", 320, "Breakfast", "Healthy breakfast with oats, banana slices, and honey drizzle. Rich in fiber and potassium.", null, null));
        diets.add(new Diet(0, 0, "Scrambled Eggs & Toast", 350, "Breakfast", "Protein-packed breakfast with eggs, whole grain toast, and butter. Great source of protein and carbs.", null, null));
        diets.add(new Diet(0, 0, "Grilled Chicken Salad", 420, "Lunch", "Lean protein salad with mixed greens, tomatoes, cucumbers, and olive oil dressing.", null, null));
        diets.add(new Diet(0, 0, "Baked Salmon with Veggies", 480, "Lunch", "Omega-3 rich salmon with roasted vegetables. Excellent for heart health and muscle recovery.", null, null));
        diets.add(new Diet(0, 0, "Mixed Berry Smoothie", 200, "Snack", "Antioxidant-rich smoothie with berries, yogurt, and honey. Great post-workout recovery drink.", null, null));
        diets.add(new Diet(0, 0, "Chicken & Rice Bowl", 550, "Lunch", "Classic bodybuilding meal with grilled chicken, brown rice, and steamed vegetables.", null, null));
        diets.add(new Diet(0, 0, "Sushi Platter", 420, "Dinner", "Fresh fish with rice and seaweed. Rich in protein, omega-3, and essential minerals.", null, null));
        diets.add(new Diet(0, 0, "Fresh Fruit Bowl", 180, "Snack", "Seasonal fruits including apples, oranges, grapes, and berries. Rich in vitamins and antioxidants.", null, null));
        diets.add(new Diet(0, 0, "Whole Grain Pasta", 520, "Dinner", "Complex carbohydrate meal with whole wheat pasta, tomato sauce, and herbs.", null, null));
        diets.add(new Diet(0, 0, "Grilled Steak", 650, "Dinner", "Lean beef steak with roasted potatoes and steamed broccoli. High in protein and iron.", null, null));
        diets.add(new Diet(0, 0, "Vegetable Soup", 210, "Lunch", "Light soup with mixed vegetables, herbs, and vegetable broth. Low calorie and nutritious.", null, null));
        diets.add(new Diet(0, 0, "Avocado Toast", 330, "Breakfast", "Whole grain bread topped with mashed avocado, eggs, and seasonings. Healthy fats and protein.", null, null));
        diets.add(new Diet(0, 0, "Tofu Stir Fry", 400, "Dinner", "Plant-based protein with bell peppers, carrots, and soy sauce. Great vegetarian option.", null, null));
        diets.add(new Diet(0, 0, "Berry Yogurt Bowl", 260, "Snack", "Greek yogurt topped with fresh berries, granola, and honey. High protein and probiotics.", null, null));
        diets.add(new Diet(0, 0, "Shrimp Pasta", 530, "Dinner", "Seafood pasta with whole wheat noodles, shrimp, and olive oil. Lean protein and complex carbs.", null, null));
        diets.add(new Diet(0, 0, "Protein Smoothie", 280, "Snack", "Post-workout shake with whey protein, banana, oats, and almond milk.", null, null));
        diets.add(new Diet(0, 0, "Caesar Salad", 340, "Lunch", "Classic salad with romaine lettuce, croutons, parmesan cheese, and Caesar dressing.", null, null));
        diets.add(new Diet(0, 0, "Quinoa Bowl", 450, "Lunch", "Superfood grain bowl with quinoa, black beans, vegetables, and tahini dressing.", null, null));
        diets.add(new Diet(0, 0, "Turkey Wrap", 380, "Lunch", "Lean turkey breast wrapped in whole wheat tortilla with vegetables and hummus.", null, null));
        diets.add(new Diet(0, 0, "Green Smoothie", 150, "Snack", "Nutrient-dense smoothie with spinach, kale, banana, and coconut water.", null, null));
        
        for (Diet diet : diets) {
            dietDAO.addDiet(diet);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
