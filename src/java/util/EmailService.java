package util;

import java.util.concurrent.CompletableFuture;

/**
 * Lớp tiện ích thực hiện gửi Email Bất Đồng Bộ (Asynchronously).
 * Bao bọc các lời gọi JavaMail đồng bộ bên trong luồng CompletableFuture 
 * nhằm tránh làm treo (hang) giao diện/luồng chính khi cấu hình kết nối SMTP.
 */
public class EmailService {

    /**
     * Gửi một email đính kèm đường link chứa mã xác thực đánh giá cho khách hàng.
     * Chạy ngầm trong nền (Async).
     * @param toEmail Email đích đến của khách hàng
     * @param token Mã xác thực duy nhất vừa được tạo
     * @param domainUrl URL thư mục gốc của hệ thống (VD: http://localhost:8080/crm)
     */
    public static void sendFeedbackEmailAsync(String toEmail, String token, String domainUrl) {
        CompletableFuture.runAsync(() -> {
            String feedbackLink = domainUrl + "/feedback?token=" + token;
            String subject = "[CRM] Xin ý kiến đánh giá chất lượng dịch vụ & Hỗ trợ";
            
            StringBuilder content = new StringBuilder();
            content.append("<html><body style='font-family: Arial, sans-serif;'>");
            content.append("<h2>Kính gửi Quý khách,</h2>");
            content.append("<p>Cảm ơn Quý khách đã tin tưởng và sử dụng dịch vụ của chúng tôi.</p>");
            content.append("<p>Phản hồi của Quý khách là cơ sở quan trọng giúp chúng tôi cải thiện chất lượng phục vụ.</p>");
            content.append("<p><a href='").append(feedbackLink)
                   .append("' style='display:inline-block; padding:10px 20px; background-color:#0d6efd; color:#ffffff; text-decoration:none; border-radius:5px;'>")
                   .append("👉 Bấm vào đây để Đánh Giá</a></p>");
            content.append("<p>Trân trọng,<br>Đội ngũ Chăm sóc khách hàng CRM</p>");
            content.append("</body></html>");

            // Khởi tạo dịch vụ gửi JavaMail Đồng Bộ
            service.EmailService mailer = new service.EmailService();
            // Lệnh chặn (Blocking) này được xử lý an toàn nhờ có Async Pool
            boolean success = mailer.sendMarketingEmail(toEmail, subject, content.toString());
            
            if (success) {
                System.out.println("[Feedback Email] Successfully sent feedback request to: " + toEmail);
            } else {
                System.err.println("[Feedback Email] Failed to send feedback request to: " + toEmail);
            }
        });
    }

    /**
     * Gửi email 'Cảm ơn' đơn giản tới khách hàng theo luồng bất đồng bộ.
     * @param toEmail Email đích đến
     * @param customerName Tên của khách hàng cá nhân / tên tập đoàn
     */
    public static void sendThankYouEmailAsync(String toEmail, String customerName) {
        CompletableFuture.runAsync(() -> {
            service.EmailService mailer = new service.EmailService();
            mailer.sendThankYouEmail(toEmail, customerName);
            System.out.println("[Thank You Email] Successfully sent thank you email to: " + toEmail);
        });
    }
}
