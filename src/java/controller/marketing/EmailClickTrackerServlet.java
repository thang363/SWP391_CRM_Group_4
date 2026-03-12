package controller.marketing;

import dao.LeadDAO;
import dao.impl.LeadDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Frictionless tracking servlet for email clicks.
 * Records interaction, updates score, and redirects to a thank you page.
 */
@WebServlet(name = "EmailClickTrackerServlet", urlPatterns = {"/marketing/track-click"})
public class EmailClickTrackerServlet extends HttpServlet {

    private LeadDAO leadDAO;

    @Override
    public void init() throws ServletException {
        leadDAO = new LeadDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String leadIdStr = request.getParameter("leadId");
        String campaignIdStr = request.getParameter("campaignId");
        String bid = request.getParameter("bid");

        if (leadIdStr != null && !leadIdStr.isEmpty()) {
            try {
                int leadId = Integer.parseInt(leadIdStr);
                Integer campaignId = (campaignIdStr != null && !campaignIdStr.isEmpty()) ? Integer.parseInt(campaignIdStr) : null;
                
                String interactionDetails = "Lead clicked 'Interested' link in marketing email.";
                if (bid != null && !bid.isEmpty()) {
                    interactionDetails = "Email Click (Broadcast " + bid + ")";
                }

                // Record Interaction: +10 points for clicking interest link
                leadDAO.recordInteraction(
                    leadId, 
                    campaignId, 
                    "Email Click", 
                    interactionDetails, 
                    10
                );

                // Redirect to Thank You page
                request.getRequestDispatcher("/views/marketing/thank-you.jsp").forward(request, response);
                return;

            } catch (NumberFormatException e) {
                // Ignore invalid IDs
            }
        }

        // Default: just show thank you anyway (or redirect to home)
        request.getRequestDispatcher("/views/marketing/thank-you.jsp").forward(request, response);
    }
}
