package Service;

import java.util.Properties;
import java.util.Random;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    private final String fromEmail = "qtrunghzz05@gmail.com"; // Thay bằng email của bạn
    private final String password = "buxaecoobafmbthk"; // Thay bằng mật khẩu ứng dụng

    public String sendOtpEmail(String toEmail) {
        // Tạo mã OTP 6 chữ số
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Cấu hình properties cho Jakarta Mail
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Tạo session
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // Tạo email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("OTP to reset password| FitLife");
            message.setText("Hello There,\n\nYour OTP is: " + otp + "\nPlease use this OTP to reset your password.\n\nThank you so much !,\nFitLife Team");

            // Gửi email
            Transport.send(message);
            return otp; // Trả về mã OTP để lưu trong session
        } catch (MessagingException e) {
            e.printStackTrace();
            return null;
        }
    }
}