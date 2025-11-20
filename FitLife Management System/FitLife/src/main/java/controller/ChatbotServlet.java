package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chatbot"})
public class ChatbotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String sessionLogin = (String) session.getAttribute("session_login");
        
        System.out.println("=== [ChatbotServlet] Session Debug ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("Session isNew: " + session.isNew());
        System.out.println("Current User: " + (sessionLogin != null ? sessionLogin : "NULL"));
        System.out.println("Session attributes: " + java.util.Collections.list(session.getAttributeNames()));
        
        // Require login (role not required for chatbot)
        if (sessionLogin == null) {
            System.out.println("[ChatbotServlet] User not logged in - returning 401");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Please login first\"}");
            return;
        }
        
        String message = request.getParameter("message");
        System.out.println("[ChatbotServlet] Received message: " + message);
        
        if (message == null || message.trim().isEmpty()) {
            System.out.println("[ChatbotServlet] Empty message");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Message cannot be empty\"}");
            return;
        }
        
        try {
            String botResponse = getBotResponse(message, sessionLogin);
            System.out.println("[ChatbotServlet] Generated response: " + botResponse);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String jsonResponse = "{\"response\":\"" + escapeJson(botResponse) + "\",\"timestamp\":" + System.currentTimeMillis() + "}";
            System.out.println("[ChatbotServlet] Sending JSON: " + jsonResponse);
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Sorry, I'm having trouble right now. Please try again later.\"}");
        }
    }
    
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    private String getBotResponse(String userMessage, String username) {
        String message = userMessage.toLowerCase().trim();
        
        if (message.contains("bmi") || message.contains("weight") || message.contains("height")) {
            return "Hi " + username + "! BMI is calculated using your weight and height. You can use our BMI calculator to get your current BMI and recommendations. Would you like me to help you understand your BMI category?";
        }
        
        if (message.contains("workout") || message.contains("exercise") || message.contains("training")) {
            return "Great question about workouts! We have various exercise programs available. For beginners, I recommend starting with bodyweight exercises like push-ups, squats, and planks. For more advanced users, we offer strength training and cardio programs. What's your fitness level?";
        }
        
        if (message.contains("diet") || message.contains("food") || message.contains("nutrition") || message.contains("meal")) {
            return "Nutrition is key to achieving your fitness goals! We offer balanced meal plans with proper macronutrients. Focus on lean proteins, complex carbohydrates, and healthy fats. Would you like recommendations based on your fitness goals?";
        }
        
        if (message.contains("progress") || message.contains("track") || message.contains("record")) {
            return "Tracking your progress is essential! You can record your weight, measurements, and other metrics in our progress section. Regular tracking helps you stay motivated and adjust your plan as needed. Have you been consistent with your progress tracking?";
        }
        
        if (message.contains("motivation") || message.contains("motivated") || message.contains("motivate")) {
            return "Staying motivated can be challenging, but remember: every expert was once a beginner! Set small, achievable goals and celebrate your wins. Consistency is more important than perfection. What's your main fitness goal right now?";
        }
        
        if (message.contains("goal") || message.contains("target") || message.contains("aim")) {
            return "Setting clear, realistic goals is crucial for success! SMART goals (Specific, Measurable, Achievable, Relevant, Time-bound) work best. Whether it's weight loss, muscle gain, or improved fitness, I can help you create a plan. What would you like to achieve?";
        }
        
        if (message.contains("schedule") || message.contains("routine") || message.contains("plan")) {
            return "Having a structured plan is important! I recommend starting with 3-4 workouts per week and gradually increasing. Include both strength training and cardio. Don't forget rest days - they're crucial for recovery and progress. What's your current schedule like?";
        }
        
        if (message.contains("rest") || message.contains("recovery") || message.contains("sleep")) {
            return "Recovery is just as important as training! Aim for 7-9 hours of quality sleep, stay hydrated, and include rest days in your routine. Proper recovery prevents injuries and improves performance. Are you getting enough rest?";
        }
        
        if (message.contains("injury") || message.contains("pain") || message.contains("hurt")) {
            return "If you're experiencing pain or injury, please consult with a healthcare professional immediately. Don't push through pain - it can lead to serious injuries. Focus on proper form and listen to your body. Are you currently dealing with any injuries?";
        }
        
        if (message.contains("supplement") || message.contains("protein") || message.contains("vitamin")) {
            return "Supplements can support your fitness journey, but they're not magic pills. Focus on getting nutrients from whole foods first. If you're considering supplements, consult with a healthcare provider. What supplements are you thinking about?";
        }
        
        if (message.contains("hello") || message.contains("hi") || message.contains("hey")) {
            return "Hello " + username + "! I'm your FitLife AI assistant. I'm here to help you with fitness questions, workout advice, nutrition tips, and motivation. What can I help you with today?";
        }
        
        if (message.contains("help") || message.contains("assist")) {
            return "I'm here to help you with all things fitness! I can assist with:\n• BMI calculations and health advice\n• Workout recommendations\n• Nutrition and diet tips\n• Progress tracking guidance\n• Motivation and goal setting\n• General fitness questions\n\nWhat would you like to know?";
        }
        
        if (message.contains("thank") || message.contains("thanks")) {
            return "You're welcome, " + username + "! I'm always here to help you on your fitness journey. Keep up the great work and don't hesitate to ask if you need more assistance!";
        }
        
        if (message.contains("bye") || message.contains("goodbye") || message.contains("see you")) {
            return "Goodbye " + username + "! Remember to stay consistent with your fitness routine. I'll be here whenever you need help or motivation. Have a great day!";
        }
        
        return "That's an interesting question, " + username + "! While I specialize in fitness, health, and nutrition topics, I'd be happy to help you with workout plans, diet advice, BMI calculations, or general fitness guidance. Could you rephrase your question or ask about something fitness-related?";
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
