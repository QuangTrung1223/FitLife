package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import util.DBContext;

public class CourseDAO extends DBContext {

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Courses";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course(
                    rs.getInt("course_id"),
                    rs.getString("course_name"),
                    rs.getString("description"),
                    rs.getString("course_type"),
                    rs.getString("suitable_bmi_category"),
                    rs.getInt("duration"),
                    rs.getInt("calories_burned"),
                    rs.getTimestamp("created_at")
                );
                list.add(course);
            }
            System.out.println("CourseDAO: Lấy được " + list.size() + " khóa học từ database.");
        } catch (SQLException e) {
            System.out.println("CourseDAO: Lỗi khi lấy danh sách khóa học.");
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> getCoursesByBmiCategory(String bmiCategory) {
        List<Course> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Courses WHERE suitable_bmi_category LIKE ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, "%" + bmiCategory + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course(
                    rs.getInt("course_id"),
                    rs.getString("course_name"),
                    rs.getString("description"),
                    rs.getString("course_type"),
                    rs.getString("suitable_bmi_category"),
                    rs.getInt("duration"),
                    rs.getInt("calories_burned"),
                    rs.getTimestamp("created_at")
                );
                list.add(course);
            }
            System.out.println("CourseDAO: Lấy được " + list.size() + " khóa học cho BMI category: " + bmiCategory);
        } catch (SQLException e) {
            System.out.println("CourseDAO: Lỗi khi lấy khóa học theo BMI category.");
            e.printStackTrace();
        }
        return list;
    }

    public Course getCourseById(int courseId) {
        try {
            String sql = "SELECT * FROM Courses WHERE course_id = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Course(
                    rs.getInt("course_id"),
                    rs.getString("course_name"),
                    rs.getString("description"),
                    rs.getString("course_type"),
                    rs.getString("suitable_bmi_category"),
                    rs.getInt("duration"),
                    rs.getInt("calories_burned"),
                    rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException e) {
            System.out.println("CourseDAO: Lỗi khi lấy khóa học theo ID.");
            e.printStackTrace();
        }
        return null;
    }
}