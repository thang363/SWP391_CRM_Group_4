package controller;

import com.google.gson.Gson;
import dao.CampaignDAO;
import dao.LandingPageDAO;
import dao.LeadSubmissionDAO;
import dao.impl.CampaignDAOImpl;
import dao.impl.LandingPageDAOImpl;
import dao.impl.LeadSubmissionDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Campaign;
import model.entity.LandingPage;
import model.entity.LeadSubmission;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for managing Lead Submissions.
 * doGet: List submissions with filters + pagination.
 * doPost: AJAX actions (convert, delete, loadLandingPages).
 */
@WebServlet("/marketing/submissions")
public class SubmissionsServlet extends HttpServlet {

    private final LeadSubmissionDAO submissionDAO;
    private final CampaignDAO campaignDAO;
    private final LandingPageDAO landingPageDAO;
    private final dao.LeadDAO leadDAO;
    private final dao.LeadSourceDAO leadSourceDAO;
    private final Gson gson;

    public SubmissionsServlet() {
        this.submissionDAO = new LeadSubmissionDAOImpl();
        this.campaignDAO = new CampaignDAOImpl();
        this.landingPageDAO = new LandingPageDAOImpl();
        this.leadDAO = new dao.impl.LeadDAOImpl();
        this.leadSourceDAO = new dao.impl.LeadSourceDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // --- Parse filter parameters ---
        String keyword = request.getParameter("keyword");
        String campaignIdStr = request.getParameter("campaignId");
        String status = request.getParameter("status");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        Integer campaignId = null;
        if (campaignIdStr != null && !campaignIdStr.trim().isEmpty()) {
            try {
                campaignId = Integer.parseInt(campaignIdStr);
            } catch (NumberFormatException ignored) {}
        }

        Date fromDate = parseDate(fromDateStr);
        Date toDate = parseDate(toDateStr);

        // --- Pagination ---
        int page = 1;
        int pageSize = Constants.DEFAULT_PAGE_SIZE;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        if (page < 1) page = 1;

        int offset = (page - 1) * pageSize;

        // Source filter is not exposed in UI yet, pass null
        String source = null;

        // --- User Role check ---
        model.entity.User currentUser = (model.entity.User) request.getSession().getAttribute(Constants.SESSION_USER);
        Integer marketingId = null;
        boolean isManagerView = false;
        
        if (currentUser != null) {
            model.entity.Role role = currentUser.getRole();
            if (model.entity.Role.MARKETING.equals(role)) {
                marketingId = currentUser.getId();
            } else if (model.entity.Role.MANAGER.equals(role)) {
                isManagerView = true;
            }
        }

        // --- Fetch data ---
        int totalItems = submissionDAO.count(marketingId, keyword, campaignId, source, status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) {
            page = totalPages;
            offset = (page - 1) * pageSize;
        }

        List<LeadSubmission> submissions = new java.util.ArrayList<>();
        if (!isManagerView) {
            submissions = submissionDAO.findAll(marketingId, keyword, campaignId, source, status, fromDate, toDate, offset, pageSize);
        }

        // Campaigns for dropdown filter
        List<Campaign> campaigns = campaignDAO.findAll();

        // Stat cards
        int statTotal = totalItems;
        int statPending = submissionDAO.countPending(marketingId);
        int statToday = submissionDAO.countToday(marketingId);

        // --- Set attributes ---
        request.setAttribute("submissions", submissions);
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("currentPageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("statTotal", statTotal);
        request.setAttribute("statPending", statPending);
        request.setAttribute("statToday", statToday);
        request.setAttribute("isManagerView", isManagerView); // Pass flag to JSP

        // For sidebar active highlight
        request.setAttribute("currentPage", "submissions");

        // Forward to JSP
        request.getRequestDispatcher(Constants.PAGE_SUBMISSIONS).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            sendJsonResponse(response, false, "Action không được xác định", null);
            return;
        }

        switch (action) {
            case "convert":
                handleConvert(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "loadLandingPages":
                handleLoadLandingPages(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Action không hợp lệ", null);
        }
    }

    /**
     * Convert submission to Lead (mark as processed).
     */
    private void handleConvert(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String forceStr = request.getParameter("force");
        boolean force = "true".equals(forceStr);

        if (idStr == null || idStr.isEmpty()) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // Check if submission exists
            LeadSubmission submission = submissionDAO.findById(id);
            if (submission == null) {
                sendJsonResponse(response, false, "Không tìm thấy bản ghi", null);
                return;
            }

            // Check if already processed
            if (Boolean.TRUE.equals(submission.getIsProcessed())) {
                sendJsonResponse(response, false, "Bản ghi này đã được xử lý trước đó", null);
                return;
            }

            // --- Resolve Campaign ID ---
            Integer submitCampaignId = null;
            if (submission.getCampaignId() != null && submission.getCampaignId() > 0) {
                submitCampaignId = submission.getCampaignId();
            } else if (submission.getLandingPageId() != null) {
                LandingPage lp = landingPageDAO.findById(submission.getLandingPageId());
                if (lp != null && lp.getCampaignId() != null) {
                    submitCampaignId = lp.getCampaignId();
                }
            }

            // --- Check Duplicate ---
            if (!force) {
                boolean isDuplicate = leadDAO.checkDuplicate(submission.getEmail(), submission.getPhone(), submitCampaignId);
                if (isDuplicate) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("code", "DUPLICATE");
                    sendJsonResponse(response, false, "Email hoặc số điện thoại đã tồn tại trong chiến dịch này.", data);
                    return;
                }
            }

            // --- Create Lead ---
            model.entity.Lead lead = new model.entity.Lead();
            lead.setFullName(submission.getFullName());
            lead.setEmail(submission.getEmail());
            lead.setPhone(submission.getPhone());
            
            // Map resolved Campaign ID
            if (submitCampaignId != null) {
                lead.setCampaignId(submitCampaignId);
            }
            
            // Map Source ID
            String sourceName = submission.getSource();
            if (sourceName == null || sourceName.trim().isEmpty()) {
                 // Fallback if source is missing
                 if (submission.getLandingPageId() != null) {
                     sourceName = "Landing Page";
                 } else {
                     sourceName = "Unknown";
                 }
            }
            
            Integer sourceId = leadSourceDAO.getIdByName(sourceName);
            if (sourceId == null) {
                sourceId = leadSourceDAO.insert(sourceName);
            }
            if (sourceId != null) {
                lead.setSourceId(sourceId);
            }
            
            lead.setStatus("New"); // Default status

            // Insert Lead
            boolean insertSuccess = leadDAO.insert(lead);
            if (!insertSuccess) {
                sendJsonResponse(response, false, "Lỗi khi tạo Lead (Có thể lỗi Database constraints)", null);
                return;
            }

            // Mark submission as processed
            boolean updateSuccess = submissionDAO.markAsProcessed(id);
            if (updateSuccess) {
                sendJsonResponse(response, true, "Đã tạo Lead và cập nhật trạng thái thành công!", null);
            } else {
                sendJsonResponse(response, false, "Đã tạo Lead nhưng lỗi khi cập nhật trạng thái submission", null);
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }

    /**
     * Delete a submission (hard delete).
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            submissionDAO.delete(id);
            sendJsonResponse(response, true, "Đã xóa bản ghi thành công!", null);
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }

    /**
     * Load landing pages by campaign ID (for cascading dropdown).
     */
    private void handleLoadLandingPages(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String campaignIdStr = request.getParameter("campaignId");
        if (campaignIdStr == null || campaignIdStr.isEmpty()) {
            sendJsonResponse(response, false, "Campaign ID không hợp lệ", null);
            return;
        }

        try {
            int campaignId = Integer.parseInt(campaignIdStr);
            List<LandingPage> pages = landingPageDAO.findAllByCampaignId(campaignId);
            sendJsonResponse(response, true, "OK", pages);
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Campaign ID không hợp lệ", null);
        }
    }

    /**
     * Parse date string (yyyy-MM-dd) to java.sql.Date.
     */
    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            return Date.valueOf(dateStr.trim());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    /**
     * Send JSON response (same pattern as CampaignServlet).
     */
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
