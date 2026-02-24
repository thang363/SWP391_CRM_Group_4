package controller;

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
    
    @Override
    public void init() {
        lpDAO = new LandingPageDAOImpl();
        submissionDAO = new LeadSubmissionDAOImpl();
        campaignDAO = new dao.impl.CampaignDAOImpl();
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
            model.entity.Campaign campaign = campaignDAO.findById(Long.valueOf(lp.getCampaignId()));
            String campaignStatus = (campaign != null) ? campaign.getStatus() : "";

            // Check Visibility Logic
            // Campaign MUST be Active
            // LP can be Active OR Approved (as per user request)
            boolean isCampaignActive = "Active".equalsIgnoreCase(campaignStatus);
            boolean isLPPublic = "active".equalsIgnoreCase(lp.getStatus()) || "Approved".equalsIgnoreCase(lp.getStatus());
            
            boolean isPubliclyVisible = isCampaignActive && isLPPublic;
            
            // Access Control:
            // 1. Public Client: Only if isPubliclyVisible
            // 2. Internal User (Logged in): ALWAYS ALLOW (View as Manager/Marketing)
            
            boolean isLoggedIn = request.getSession(false) != null && 
                                 request.getSession(false).getAttribute(util.Constants.SESSION_USER) != null;

            if (!isPubliclyVisible && !isLoggedIn) {
                // Not visible public and user not logged in -> Block
                 response.sendError(HttpServletResponse.SC_FORBIDDEN, "This landing page is not currently active.");
                 return;
            }
            
            // Allow view...

            // Parse data_config JSON to get hero title and description
            String dataConfig = lp.getDataConfig();
            String heroTitle = "Standout App";
            String heroDesc = "An Amazing App That Does It All.";
            
            if (dataConfig != null && !dataConfig.trim().isEmpty()) {
                try {
                    Gson gson = new Gson();
                    JsonObject json = gson.fromJson(dataConfig, JsonObject.class);
                    if (json.has("heroTitle")) {
                        heroTitle = json.get("heroTitle").getAsString();
                    }
                    if (json.has("heroDesc")) {
                        heroDesc = json.get("heroDesc").getAsString();
                    }
                } catch (JsonSyntaxException e) {
                    // Use defaults if JSON parsing fails
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("landingPageId", lpId);
            request.setAttribute("pageTitle", lp.getName());
            request.setAttribute("heroTitle", heroTitle);
            request.setAttribute("heroDesc", heroDesc);
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
            
            // Create JSON object for rawData
            JsonObject rawData = new JsonObject();
            rawData.addProperty("fullName", fullName);
            rawData.addProperty("email", email);
            rawData.addProperty("phone", phone != null ? phone : "");
            rawData.addProperty("message", message != null ? message : "");
            rawData.addProperty("userAgent", request.getHeader("User-Agent"));
            rawData.addProperty("ipAddress", request.getRemoteAddr());
            
            // Create submission entity
            LeadSubmission submission = new LeadSubmission();
            submission.setLandingPageId(lpId);
            
            // Retrieve Campaign ID from Landing Page (Already loaded in doGet, need to load it here or query DAO)
            // Since this is doPost, we don't have the lp object from doGet. Load it again.
            LandingPage lp = lpDAO.findById(lpId);
            if(lp != null && lp.getCampaignId() != null) {
                submission.setCampaignId(lp.getCampaignId());
                
                // --- Campaign Status Validation ---
                model.entity.Campaign campaign = campaignDAO.findById(Long.valueOf(lp.getCampaignId()));
                if (campaign != null) {
                    String status = campaign.getStatus();
                    if ("Paused".equalsIgnoreCase(status) || "Finished".equalsIgnoreCase(status)) {
                         result.addProperty("success", false);
                         result.addProperty("message", "Chiến dịch này hiện không nhận đăng ký do đã tạm dừng hoặc kết thúc.");
                         out.print(gson.toJson(result));
                         return;
                    }
                    
                    boolean isLPPublic = "active".equalsIgnoreCase(lp.getStatus()) || "Approved".equalsIgnoreCase(lp.getStatus());
                    
                    if ("Draft".equalsIgnoreCase(status)) {
                        submission.setSource("Internal Test (Draft Campaign)");
                    } else if (!isLPPublic) {
                        submission.setSource("Internal Test (Draft LP)");
                    } else {
                        submission.setSource("Landing Page"); // Default source for Web Form
                    }
                } else {
                    submission.setSource("Landing Page");
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
            submission.setRawData(gson.toJson(rawData)); // Create rawData JSON string
            
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
}
