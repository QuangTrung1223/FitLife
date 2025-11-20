package dal;

import model.Coach;
import util.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CoachDAO extends DBContext {
    
    public List<Coach> getAllCoaches() {
        List<Coach> coaches = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Coach ORDER BY coach_id";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Coach coach = new Coach();
                coach.setCoachId(rs.getInt("coach_id"));
                coach.setCoachName(rs.getString("coach_name"));
                coach.setSpecialization(rs.getString("specialization"));
                coach.setExperience(rs.getString("experience"));
                coach.setDescription(rs.getString("description"));
                coach.setImageUrl(rs.getString("image_url"));
                coach.setPrice(rs.getDouble("price"));
                coach.setRating(rs.getDouble("rating"));
                coach.setCertifications(rs.getString("certifications"));
                coach.setLocation(rs.getString("location"));
                coaches.add(coach);
            }
            
            System.out.println("CoachDAO: Lấy được " + coaches.size() + " coach từ database.");
        } catch (Exception e) {
            System.err.println("CoachDAO: Lỗi khi lấy danh sách coaches: " + e.getMessage());
            e.printStackTrace();
        }
        return coaches;
    }
    
    public Coach getCoachById(int coachId) {
        try {
            String sql = "SELECT * FROM Coach WHERE coach_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, coachId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Coach coach = new Coach();
                coach.setCoachId(rs.getInt("coach_id"));
                coach.setCoachName(rs.getString("coach_name"));
                coach.setSpecialization(rs.getString("specialization"));
                coach.setExperience(rs.getString("experience"));
                coach.setDescription(rs.getString("description"));
                coach.setImageUrl(rs.getString("image_url"));
                coach.setPrice(rs.getDouble("price"));
                coach.setRating(rs.getDouble("rating"));
                coach.setCertifications(rs.getString("certifications"));
                coach.setLocation(rs.getString("location"));
                return coach;
            }
        } catch (Exception e) {
            System.err.println("CoachDAO: Lỗi khi lấy coach theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Tạo danh sách coaches mẫu nếu database chưa có
    public List<Coach> getSampleCoaches() {
        List<Coach> coaches = new ArrayList<>();
        
        String[] coachNames = {
            "Michael Johnson", "Sarah Williams", "David Chen", "Emma Brown", "James Taylor",
            "Olivia Martinez", "Daniel Lee", "Sophia Garcia", "Matthew Wilson", "Isabella Anderson",
            "Christopher Moore", "Ava Jackson", "Andrew Thomas", "Mia White", "Joshua Harris",
            "Charlotte Martin", "Ryan Thompson", "Amelia Clark", "Tyler Rodriguez", "Harper Lewis"
        };
        
        String[] specializations = {
            "Strength Training", "Cardio Fitness", "Yoga & Flexibility", "Weight Loss", "Muscle Building",
            "CrossFit", "Pilates", "Boxing", "Running", "Swimming",
            "HIIT", "Powerlifting", "Bodybuilding", "Calisthenics", "Dance Fitness",
            "Martial Arts", "Cycling", "Functional Training", "Rehabilitation", "Athletic Performance"
        };
        
        String[] images = {
            "https://img.freepik.com/free-photo/young-powerful-sportsman-training-push-ups-dark-wall_176420-537.jpg",
            "https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=1200",
            "https://media.istockphoto.com/id/1370779476/photo/shot-of-a-sporty-young-woman-exercising-with-a-barbell-in-a-gym.jpg",
            "https://t4.ftcdn.net/jpg/00/95/32/41/360_F_95324105_nanCVHMiu7r8B0qSur3k1siBWxacfmII.jpg",
            "https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-4.1.0",
            "https://media.istockphoto.com/id/628092382/photo/its-great-for-the-abs.jpg",
            "https://media.istockphoto.com/id/1177167264/photo/quick-feet-quick-feet.jpg",
            "https://media.istockphoto.com/id/1400845852/photo/one-active-mixed-race-man-from-the-back-stretching-arms-and-triceps-by-pulling-elbow-with.jpg",
            "https://t4.ftcdn.net/jpg/07/83/29/29/360_F_783292909_0fhoXLONr7v4IUr4jP7dF5Yygp9TMwcA.jpg",
            "https://media.istockphoto.com/id/1252207646/photo/man-kick-boxer-training-alone-in-gym.jpg",
            "https://t4.ftcdn.net/jpg/03/82/37/89/360_F_382378953_Dcp6TQjMlVym6dg24IdsXDZGkrYpORIS.jpg",
            "https://images.pexels.com/photos/421160/pexels-photo-421160.jpeg",
            "https://media.istockphoto.com/id/1857910044/photo/slim-woman-practicing-yoga-in-seated-spinal-twist-pose.jpg",
            "https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=1200",
            "https://media.istockphoto.com/id/1310511832/photo/asian-woman-stretching-her-back-in-a-training-gym.jpg",
            "https://t3.ftcdn.net/jpg/03/16/08/66/360_F_316086673_NfxzsibpOdTYFDQZ9SUsaxQbheBZSHbf.jpg",
            "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop",
            "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300&h=200&fit=crop",
            "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=200&fit=crop",
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop"
        };
        
        double[] prices = {
            2000000, 1800000, 2200000, 1900000, 2100000,
            2500000, 1700000, 2000000, 2300000, 1850000,
            2400000, 1950000, 2150000, 2000000, 2250000,
            1800000, 2100000, 2050000, 1950000, 2200000
        };
        
        String[] experiences = {
            "5 years", "7 years", "3 years", "6 years", "4 years",
            "8 years", "5 years", "9 years", "6 years", "4 years",
            "7 years", "5 years", "6 years", "8 years", "5 years",
            "4 years", "7 years", "6 years", "5 years", "9 years"
        };
        
        for (int i = 0; i < 20; i++) {
            Coach coach = new Coach();
            coach.setCoachId(i + 1);
            coach.setCoachName(coachNames[i]);
            coach.setSpecialization(specializations[i]);
            coach.setExperience(experiences[i]);
            coach.setDescription("Professional fitness trainer specializing in " + specializations[i] + ". With " + experiences[i] + " of experience, I help clients achieve their fitness goals through personalized training programs.");
            coach.setImageUrl(images[i % images.length]);
            coach.setPrice(prices[i]);
            coach.setRating(4.0 + (Math.random() * 1.0)); // Rating from 4.0 to 5.0
            coach.setCertifications("NASM Certified, CPR/AED");
            coach.setLocation("Ho Chi Minh City");
            coaches.add(coach);
        }
        
        return coaches;
    }
}
