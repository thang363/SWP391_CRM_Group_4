package util;

import java.util.concurrent.CompletableFuture;

public class EmailService {

    public static void sendFeedbackEmailAsync(String toEmail, String token, String domainUrl) {
        CompletableFuture.runAsync(() -> {
            try {
                // Chạy giả lập độ trễ mạng khi gửi email
                Thread.sleep(1000);

                String feedbackLink = domainUrl + "/feedback?token=" + token;

                // Print simulation mail in console output
                System.out.println("=======================================================================");
                System.out.println("[Email Service] Email Sent Asynchronously!");
                System.out.println("To: " + toEmail);
                System.out.println("Subject: [CRM] Xin ý kiến đánh giá chất lượng dịch vụ & Hỗ trợ");
                System.out.println("Body: Vui lòng click vào đường link bảo mật bên dưới để gửi đánh giá:");
                System.out.println("Link: " + feedbackLink);
                System.out.println("=======================================================================");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
    }
}
