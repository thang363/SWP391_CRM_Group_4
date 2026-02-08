package service;

// import jakarta.mail.*;
// import jakarta.mail.internet.InternetAddress;
// import jakarta.mail.internet.MimeMessage;
// import java.util.Properties;

public class EmailService {
    private static final String FROM_EMAIL = "support@crm.com";

    public void sendResolutionEmail(String toEmail, String customerName, int ticketId, String note) {
        String subject = "Ticket #" + ticketId + " has been resolved";

        String acceptLink = "http://localhost:8080/SWP391_CRM_Group_4/tickets?action=verify-ticket&id=" + ticketId
                + "&decision=accept";
        String rejectLink = "http://localhost:8080/SWP391_CRM_Group_4/tickets?action=verify-ticket&id=" + ticketId
                + "&decision=reject";

        StringBuilder content = new StringBuilder();
        content.append("Dear ").append(customerName).append(",\n\n");
        content.append("Your ticket #").append(ticketId).append(" has been marked as resolved.\n");
        content.append("Solution: ").append(note).append("\n\n");
        content.append("Please verify the solution:\n");
        content.append("1. Accept Solution: ").append(acceptLink).append("\n");
        content.append("2. Reject (Still having issues): ").append(rejectLink).append("\n\n");
        content.append("If you do not respond within 3 days, the ticket will be closed automatically.");

        // Log to console for testing
        System.out.println("----- EMAIL SIMULATION -----");
        System.out.println("To: " + toEmail);
        System.out.println("Subject: " + subject);
        System.out.println("Content:\n" + content.toString());
        System.out.println("----------------------------");
    }

    public void sendEscalationEmail(String toManagerEmail, int ticketId) {
        String subject = "URGENT: Ticket #" + ticketId + " Re-opened by Customer";
        String content = "Ticket #" + ticketId
                + " was rejected by the customer after resolution. Please investigate immediately.";

        System.out.println("----- ESCALATION EMAIL SIMULATION -----");
        System.out.println("To: " + toManagerEmail);
        System.out.println("Subject: " + subject);
        System.out.println("Content: " + content);
        System.out.println("---------------------------------------");
    }

    // private void sendEmail(String to, String subject, String body) {
    // // Implementation requires jakarta.mail or javax.mail library
    // }
}
