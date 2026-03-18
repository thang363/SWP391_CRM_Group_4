package util;

import java.util.concurrent.CompletableFuture;

public class EmailService {

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

            service.EmailService mailer = new service.EmailService();
            boolean success = mailer.sendMarketingEmail(toEmail, subject, content.toString());
            
            if (success) {
                System.out.println("[Feedback Email] Successfully sent feedback request to: " + toEmail);
            } else {
                System.err.println("[Feedback Email] Failed to send feedback request to: " + toEmail);
            }
        });
    }

    public static void sendThankYouEmailAsync(String toEmail, String customerName) {
        CompletableFuture.runAsync(() -> {
            service.EmailService mailer = new service.EmailService();
            mailer.sendThankYouEmail(toEmail, customerName);
            System.out.println("[Thank You Email] Successfully sent thank you email to: " + toEmail);
        });
    }
}
