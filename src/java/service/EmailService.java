package service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailService {
    private static final String FROM_EMAIL = "he180827phammanhhiep@gmail.com";
    private static final String APP_PASSWORD = "akqf ltai htyr kxcw";

    public void sendResolutionEmail(String toEmail, String customerName, int ticketId, String note, String token) {
        String subject = "[CRM] Ticket #" + ticketId + " đã được xử lý";

        String acceptLink = "http://localhost:8080/CRM/ticket-verify?token=" + token + "&decision=accept";
        String rejectLink = "http://localhost:8080/CRM/ticket-verify?token=" + token + "&decision=reject";

        StringBuilder content = new StringBuilder();
        content.append("<html><body style='font-family: Arial, sans-serif;'>");
        content.append("<h2>Chào ").append(customerName).append(",</h2>");
        content.append("<p>Ticket #<strong>").append(ticketId)
                .append("</strong> của bạn đã được đánh dấu là đã giải quyết.</p>");
        content.append("<p><strong>Giải pháp:</strong> ").append(note).append("</p>");
        content.append("<p>Vui lòng xác nhận kết quả xử lý:</p>");
        content.append("<ol>");
        content.append("<li><a href='").append(acceptLink).append(
                "' style='color: #4CAF50; text-decoration: none; font-weight: bold;'>Chấp nhận (Đã xong)</a></li>");
        content.append("<li><a href='").append(rejectLink).append(
                "' style='color: #f44336; text-decoration: none; font-weight: bold;'>Từ chối (Vẫn còn lỗi)</a></li>");
        content.append("</ol>");
        content.append("<p><em>Nếu bạn không phản hồi trong vòng 3 ngày, ticket sẽ tự động đóng.</em></p>");
        content.append("</body></html>");

        sendEmailHtml(toEmail, subject, content.toString());
    }

    public void sendEscalationEmail(String toManagerEmail, int ticketId) {
        String subject = "KHẨN CẤP: Ticket #" + ticketId + " Bị khách hàng từ chối giải pháp";
        StringBuilder content = new StringBuilder();
        content.append("<html><body style='font-family: Arial, sans-serif;'>");
        content.append("<h2 style='color: #f44336;'>KHẨN CẤP</h2>");
        content.append("<p>Ticket #<strong>").append(ticketId)
                .append("</strong> đã bị khách hàng từ chối sau khi được đánh dấu là đã giải quyết.</p>");
        content.append("<p><strong>Vui lòng kiểm tra ngay lập tức.</strong></p>");
        content.append("</body></html>");

        sendEmailHtml(toManagerEmail, subject, content.toString());
    }

    public void sendThankYouEmail(String toEmail, String customerName) {
        String subject = "[CRM] Cảm ơn bạn đã quan tâm đến dịch vụ của chúng tôi";
        
        StringBuilder content = new StringBuilder();
        content.append("<html><body style='font-family: Arial, sans-serif;'>");
        content.append("<h2>Chào ").append(customerName).append(",</h2>");
        content.append("<p>Cảm ơn bạn đã để lại thông tin quan tâm đến dịch vụ của chúng tôi.</p>");
        content.append("<p>Đội ngũ của chúng tôi đã nhận được thông tin của bạn và sẽ sớm có nhân viên liên hệ để tư vấn chi tiết hơn.</p>");
        content.append("<p>Trong lúc chờ đợi, nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại phản hồi lại email này.</p>");
        content.append("<br>");
        content.append("<p>Trân trọng,<br>Đội ngũ CRM System</p>");
        content.append("</body></html>");

        sendEmailHtml(toEmail, subject, content.toString());
    }

    /**
     * Send a marketing email to a lead.
     * @param toEmail Recipient email
     * @param subject Email subject
     * @param htmlContent HTML body content
     * @return true if sent successfully, false otherwise
     */
    public boolean sendMarketingEmail(String toEmail, String subject, String htmlContent) {
        try {
            sendEmailHtml(toEmail, subject, htmlContent);
            return true;
        } catch (Exception e) {
            System.err.println("Failed to send marketing email to " + toEmail + ": " + e.getMessage());
            return false;
        }
    }

    private void sendEmailHtml(String to, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "CRM  System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);

            System.out.println("HTML Email sent successfully to: " + to);

        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
            System.err.println("Failed to send HTML email to " + to + ": " + e.getMessage());
        }
    }
}
