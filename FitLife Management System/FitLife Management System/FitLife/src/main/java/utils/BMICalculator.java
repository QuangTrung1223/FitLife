/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Guang Trump
 */
public class BMICalculator {
    
    /**
     * Tính chỉ số BMI từ chiều cao (m) và cân nặng (kg)
     */
    public static double calculateBMI(double height, double weight) {
        if (height <= 0 || weight <= 0) {
            throw new IllegalArgumentException("Height and weight must be positive values");
        }
        return weight / (height * height);
    }
    
    /**
     * Phân loại BMI thành các category
     */
    public static String getBMICategory(double bmi) {
        if (bmi < 18.5) {
            return "underweight";
        } else if (bmi < 25) {
            return "normal";
        } else if (bmi < 30) {
            return "overweight";
        } else {
            return "obese";
        }
    }
    
    /**
     * Lấy mô tả tiếng Việt cho category BMI
     */
    public static String getBMICategoryDescription(String category) {
        switch (category.toLowerCase()) {
            case "underweight":
                return "Thiếu cân";
            case "normal":
                return "Bình thường";
            case "overweight":
                return "Thừa cân";
            case "obese":
                return "Béo phì";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Lấy khuyến nghị bài tập dựa trên BMI category
     */
    public static String[] getWorkoutRecommendations(String bmiCategory) {
        switch (bmiCategory.toLowerCase()) {
            case "underweight":
                return new String[]{
                    "Bài tập tăng cơ bắp: Nâng tạ, Squat, Deadlift",
                    "Cardio nhẹ: Đi bộ, Yoga",
                    "Ăn uống đủ chất để tăng cân lành mạnh"
                };
            case "normal":
                return new String[]{
                    "Duy trì sức khỏe: Chạy bộ, Bơi lội",
                    "Tập thể dục đa dạng: Gym, Yoga, Pilates",
                    "Tập luyện sức bền và linh hoạt"
                };
            case "overweight":
                return new String[]{
                    "Cardio cường độ cao: Chạy bộ, Đạp xe",
                    "Tập HIIT để đốt cháy mỡ thừa",
                    "Kết hợp cardio và strength training"
                };
            case "obese":
                return new String[]{
                    "Bắt đầu với bài tập nhẹ: Đi bộ, Bơi lội",
                    "Tránh các bài tập có tác động mạnh",
                    "Tập dưới sự hướng dẫn của chuyên gia"
                };
            default:
                return new String[]{"Vui lòng tham khảo ý kiến bác sĩ"};
        }
    }
    
    /**
     * Lấy khuyến nghị chế độ ăn dựa trên BMI category
     */
    public static String[] getDietRecommendations(String bmiCategory) {
        switch (bmiCategory.toLowerCase()) {
            case "underweight":
                return new String[]{
                    "Tăng calo: Ăn thêm bữa phụ, thực phẩm giàu protein",
                    "Chọn thực phẩm giàu dinh dưỡng: Bơ, hạt, sữa",
                    "Ăn đủ 3 bữa chính + 2-3 bữa phụ"
                };
            case "normal":
                return new String[]{
                    "Duy trì chế độ ăn cân bằng: Protein, Carb, Chất béo",
                    "Ăn nhiều rau xanh và trái cây",
                    "Uống đủ nước và hạn chế đồ ngọt"
                };
            case "overweight":
                return new String[]{
                    "Giảm calo: Hạn chế đồ ngọt, đồ chiên",
                    "Tăng protein, giảm carb đơn giản",
                    "Ăn nhiều rau xanh và protein nạc"
                };
            case "obese":
                return new String[]{
                    "Chế độ ăn giảm cân an toàn",
                    "Tăng cường rau xanh, giảm tinh bột",
                    "Tham khảo ý kiến chuyên gia dinh dưỡng"
                };
            default:
                return new String[]{"Vui lòng tham khảo ý kiến bác sĩ"};
        }
    }
}
