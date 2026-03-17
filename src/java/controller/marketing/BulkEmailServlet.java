package controller.marketing;

import com.google.gson.Gson;
import dao.CampaignDAO;
import dao.LeadDAO;
import dao.impl.CampaignDAOImpl;
import dao.impl.LeadDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Campaign;
import model.entity.Lead;
import service.EmailService;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for Bulk Email Marketing.
 * - doGet: Show leads with email, grouped by campaign.
 * - doPost: Send marketing emails to selected leads.
 */
@WebServlet("/marketing/bulk-email")
public class BulkEmailServlet extends HttpServlet {

    private final LeadDAO leadDAO;
    private final CampaignDAO campaignDAO;
    private final EmailService emailService;
    private final Gson gson;

    public BulkEmailServlet() {
        this.leadDAO = new LeadDAOImpl();
        this.campaignDAO = new CampaignDAOImpl();
        this.emailService = new EmailService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get campaign filter
        String campaignIdStr = request.getParameter("campaignId");
        Integer campaignId = null;
        if (campaignIdStr != null && !campaignIdStr.trim().isEmpty()) {
            try {
                campaignId = Integer.parseInt(campaignIdStr);
            } catch (NumberFormatException ignored) {}
        }

        // Fetch leads with email
        List<Lead> leads;
        if (campaignId != null) {
            leads = leadDAO.findByCampaignIdWithEmail(campaignId);
        } else {
            leads = leadDAO.findAllWithEmail();
        }

        // Campaigns for dropdown filter
        List<Campaign> campaigns = campaignDAO.findAll();

        // Set attributes
        request.setAttribute("leads", leads);
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("selectedCampaignId", campaignId);
        request.setAttribute("currentPage", "bulk-email");
        request.setAttribute("pageTitle", "Email Marketing");

        request.getRequestDispatcher("/views/marketing/bulk-email.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("send".equals(action)) {
            handleSendEmails(request, response);
        } else if ("loadLeads".equals(action)) {
            handleLoadLeads(request, response);
        } else {
            sendJsonResponse(response, false, "Action không hợp lệ", null);
        }
    }

    /**
     * Send marketing emails to selected leads.
     */
    private void handleSendEmails(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String subject = request.getParameter("subject");
        String htmlContent = request.getParameter("content");
        String[] leadIds = request.getParameterValues("leadIds[]");

        // Validate
        if (subject == null || subject.trim().isEmpty()) {
            sendJsonResponse(response, false, "Tiêu đề email không được để trống", null);
            return;
        }
        if (htmlContent == null || htmlContent.trim().isEmpty()) {
            sendJsonResponse(response, false, "Nội dung email không được để trống", null);
            return;
        }
        if (leadIds == null || leadIds.length == 0) {
            sendJsonResponse(response, false, "Vui lòng chọn ít nhất một lead để gửi email", null);
            return;
        }

        int successCount = 0;
        int failCount = 0;
        
        // Generate a unique broadcast ID for this batch
        String broadcastId = String.valueOf(System.currentTimeMillis());

        for (String idStr : leadIds) {
            try {
                int leadId = Integer.parseInt(idStr);
                Lead lead = leadDAO.findById(leadId);

                if (lead != null && lead.getEmail() != null && !lead.getEmail().isEmpty()) {
                    // Personalize content: replace variables
                    String personalizedContent = htmlContent
                            .replace("{{name}}", lead.getFullName() != null ? lead.getFullName() : "")
                            .replace("{{email}}", lead.getEmail())
                            .replace("{{id}}", String.valueOf(lead.getId()));
                            
                    // Append broadcast ID (bid) to any tracking link that lacks it
                    personalizedContent = personalizedContent.replaceAll(
                        "(?i)(/marketing/track-click\\?leadId=\\d+(?:&campaignId=\\d+)?)(\"|')", 
                        "$1&bid=" + broadcastId + "$2"
                    );

                    boolean sent = emailService.sendMarketingEmail(lead.getEmail(), subject, personalizedContent);
                    if (sent) {
                        successCount++;
                    } else {
                        failCount++;
                    }
                } else {
                    failCount++;
                }
            } catch (NumberFormatException e) {
                failCount++;
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("successCount", successCount);
        result.put("failCount", failCount);

        String message = "Đã gửi thành công " + successCount + "/" + (successCount + failCount) + " email.";
        if (failCount > 0) {
            message += " (" + failCount + " email gửi thất bại)";
        }

        sendJsonResponse(response, true, message, result);
    }

    /**
     * Load leads for a specific campaign (AJAX).
     */
    private void handleLoadLeads(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String campaignIdStr = request.getParameter("campaignId");
        List<Lead> leads;

        if (campaignIdStr != null && !campaignIdStr.trim().isEmpty()) {
            try {
                int campaignId = Integer.parseInt(campaignIdStr);
                leads = leadDAO.findByCampaignIdWithEmail(campaignId);
            } catch (NumberFormatException e) {
                leads = leadDAO.findAllWithEmail();
            }
        } else {
            leads = leadDAO.findAllWithEmail();
        }

        sendJsonResponse(response, true, "OK", leads);
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success,
                                  String message, Object data) throws IOException {
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        jsonResponse.put("data", data);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
