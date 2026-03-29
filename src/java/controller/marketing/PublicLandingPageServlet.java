package controller.marketing;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import dao.LandingPageDAO;
import dao.LeadSubmissionDAO;
import dao.impl.LandingPageDAOImpl;
import dao.impl.LeadSubmissionDAOImpl;
import model.entity.LandingPage;
import model.entity.LeadSubmission;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Public servlet for landing pages (no authentication required)
 * Handles both viewing landing pages and form submissions
 */
@WebServlet(name = "PublicLandingPageServlet", urlPatterns = {"/lp/*"})
public class PublicLandingPageServlet extends HttpServlet {
    
    private LandingPageDAO lpDAO;
    private LeadSubmissionDAO submissionDAO;
    private dao.CampaignDAO campaignDAO;
    private Gson gson;
    
    @Override
    public void init() {
        lpDAO = new LandingPageDAOImpl();
        submissionDAO = new LeadSubmissionDAOImpl();
        campaignDAO = new dao.impl.CampaignDAOImpl();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo(); // e.g., "/123" or null
        
        // If no path specified, show error
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Landing page not found");
            return;
        }
        
        // Extract landing page ID from path
        String[] parts = pathInfo.split("/");
        if (parts.length < 2) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Landing page not found");
            return;
        }
        
        try {
            Integer lpId = Integer.parseInt(parts[1]);
            LandingPage lp = lpDAO.findById(lpId);
            
            if (lp == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Landing page not found");
                return;
            }

            // Get Campaign Info
            model.entity.Campaign campaign = campaignDAO.findById(lp.getCampaignId());
            String campaignStatus = (campaign != null) ? campaign.getStatus() : "";

           
            boolean isCampaignActive = "Active".equalsIgnoreCase(campaignStatus);
            boolean isLPPublic = "active".equalsIgnoreCase(lp.getStatus()) || "Public".equalsIgnoreCase(lp.getStatus());
            
            boolean isPubliclyVisible = isCampaignActive && isLPPublic;
            
          
            
            boolean isLoggedIn = request.getSession(false) != null && 
                                 request.getSession(false).getAttribute(util.Constants.SESSION_USER) != null;

            if (!isPubliclyVisible && !isLoggedIn) {
               
                 response.sendError(HttpServletResponse.SC_FORBIDDEN, "This landing page is not currently active.");
                 return;
            }
            
          

            // Parse data_config JSON and set all attributes dynamically
            if (lp.getDataConfig() != null && !lp.getDataConfig().trim().isEmpty()) {
                try {
                    com.google.gson.JsonObject json = gson.fromJson(lp.getDataConfig(), com.google.gson.JsonObject.class);
                    for (java.util.Map.Entry<String, com.google.gson.JsonElement> entry : json.entrySet()) {
                         if (!entry.getValue().isJsonNull()) {
                             String key = entry.getKey();
                             String value = entry.getValue().getAsString();
                             
                             if ("HERO_TITLE".equals(key)) request.setAttribute("heroTitle", value);
                             else if ("HERO_DESC".equals(key)) request.setAttribute("heroDesc", value);
                             else if ("ABOUT_TITLE".equals(key)) request.setAttribute("aboutTitle", value);
                             else if ("ABOUT_DESC".equals(key)) request.setAttribute("aboutDesc", value);
                             else if (key.startsWith("FEATURE_")) request.setAttribute(toCamelCase(key), value);
                             else request.setAttribute(key, value);
                         }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("landingPageId", lpId);
            request.setAttribute("pageTitle", lp.getName());
            request.setAttribute("campaignStatus", campaignStatus);
            
            // Forward to JSP template
            request.getRequestDispatcher("/templates/standout/landing-page.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid landing page ID");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        // Handle form submission at /lp/submit
        if (pathInfo != null && pathInfo.equals("/submit")) {
            handleFormSubmission(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }
    
    /**
     * Handle contact form submission
     */
    private void handleFormSubmission(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        JsonObject result = new JsonObject();
        
        try {
            // Get form parameters
            String lpIdStr = request.getParameter("landingPageId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String message = request.getParameter("message");
            
            // Validation
            String emailPattern = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";
            String phonePattern = "^(0|84)(3|5|7|8|9)[0-9]{8}$";

            if (lpIdStr == null || fullName == null || email == null || 
                fullName.trim().isEmpty() || email.trim().isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("message", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                out.print(gson.toJson(result));
                return;
            }

            if (!email.matches(emailPattern)) {
                result.addProperty("success", false);
                result.addProperty("message", "Email không hợp lệ.");
                out.print(gson.toJson(result));
                return;
            }

            if (phone != null && !phone.trim().isEmpty() && !phone.matches(phonePattern)) {
                result.addProperty("success", false);
                result.addProperty("message", "Số điện thoại không hợp lệ (Việt Nam: 10 số).");
                out.print(gson.toJson(result));
                return;
            }

            if (message != null && message.length() > 1000) {
                 result.addProperty("success", false);
                 result.addProperty("message", "Nội dung tin nhắn quá dài (tối đa 1000 ký tự).");
                 out.print(gson.toJson(result));
                 return;
            }

            
            Integer lpId = Integer.parseInt(lpIdStr);
            
            // Create submission entity
            LeadSubmission submission = new LeadSubmission();
            submission.setLandingPageId(lpId);
            
            // Retrieve Campaign ID from Landing Page (Already loaded in doGet, need to load it here or query DAO)
            // Since this is doPost, we don't have the lp object from doGet. Load it again.
            LandingPage lp = lpDAO.findById(lpId);
            if(lp != null && lp.getCampaignId() != null) {
                submission.setCampaignId(lp.getCampaignId());
                
                // --- Validation ---
                model.entity.Campaign campaign = campaignDAO.findById(lp.getCampaignId());
                boolean isCampaignActive = campaign != null && "Active".equalsIgnoreCase(campaign.getStatus());
                boolean isLPPublic = "Public".equalsIgnoreCase(lp.getStatus()) || "active".equalsIgnoreCase(lp.getStatus());
                
                // Allow testing for logged-in staff (Draft LP or Draft Campaign)
                boolean isLoggedIn = request.getSession(false) != null && 
                                     request.getSession(false).getAttribute(util.Constants.SESSION_USER_ID) != null;

                if (!isLoggedIn) {
                    if (!isCampaignActive || !isLPPublic) {
                        result.addProperty("success", false);
                        result.addProperty("message", "Trang đích hoặc Chiến dịch hiện không hoạt động. Không thể nhận đăng ký.");
                        out.print(gson.toJson(result));
                        return;
                    }
                    submission.setSource("Landing Page");
                } else {
                    // For logged-in users submitting on non-public LPs/Campaigns
                    if (isCampaignActive && isLPPublic) {
                        submission.setSource("Landing Page");
                    } else {
                        submission.setSource("Internal Test");
                    }
                }
            } else {
                 result.addProperty("success", false);
                 result.addProperty("message", "Error: Associated Campaign not found.");
                 out.print(gson.toJson(result));
                 return;
            }

            submission.setFullName(fullName);
            submission.setEmail(email);
            submission.setPhone(phone);
            
            // Checking LeadSubmission.java from previous step... 
            // It has: id, landingPageId, source, fullName, email, phone. NO RAW DATA.
            
            submission.setIsProcessed(false);
            
            // Save to database
            LeadSubmission created = submissionDAO.create(submission);
            
            if (created != null) {
                result.addProperty("success", true);
                result.addProperty("message", "Thank you! We'll get back to you soon.");
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "Something went wrong. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            result.addProperty("success", false);
            result.addProperty("message", "Invalid landing page ID");
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "An error occurred. Please try again.");
        }
        
        out.print(gson.toJson(result));
    }
    private String toCamelCase(String snakeCase) {
        StringBuilder sb = new StringBuilder();
        boolean nextUpper = false;
        for (char c : snakeCase.toLowerCase().toCharArray()) {
            if (c == '_') {
                nextUpper = true;
            } else {
                if (nextUpper) {
                    sb.append(Character.toUpperCase(c));
                    nextUpper = false;
                } else {
                    sb.append(c);
                }
            }
        }
        return sb.toString();
    }
}
