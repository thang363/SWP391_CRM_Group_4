package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Campaign;
import model.entity.Role;
import model.entity.User;
import service.CampaignService;
import service.UserService;
import service.impl.CampaignServiceImpl;
import service.impl.UserServiceImpl;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CampaignServlet", urlPatterns = {"/campaigns"})
public class CampaignServlet extends HttpServlet {

    private final CampaignService campaignService;
    private final UserService userService;
    private final Gson gson;

    public CampaignServlet() {
        this.campaignService = new CampaignServiceImpl();
        this.userService = new UserServiceImpl();
        this.gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {



        // Handle AJAX GET requests (e.g., fetch particular campaign for edit)
        String action = request.getParameter("action");
        if ("get".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            handleGet(request, response);
            return;
        }

        // Get filter parameters
        String nameFilter = request.getParameter("name");
        String statusFilter = request.getParameter("status");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // Parse dates
        Timestamp startDate = parseDate(startDateStr);
        Timestamp endDate = parseDate(endDateStr);

        // Get campaigns
        List<Campaign> campaigns;
        if (hasFilters(nameFilter, statusFilter, startDate, endDate)) {
            campaigns = campaignService.searchCampaigns(nameFilter, statusFilter, startDate, endDate);
        } else {
            campaigns = campaignService.getAllCampaigns();
        }

        // Get all managers for dropdown
        List<User> managers = userService.getUsersByRole(Role.MANAGER);

        // Set attributes
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("managers", managers);
        request.setAttribute("currentPage", "campaigns");
        request.setAttribute("pageTitle", "Quản lý Chiến dịch");

        // Forward to JSP
        request.getRequestDispatcher(Constants.PAGE_CAMPAIGNS).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is Manager (Only Manager can CUD)
        if (!isManager(request)) {
            sendJsonResponse(response, false, "Bạn không có quyền thực hiện thao tác này", null);
            return;
        }



        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            sendJsonResponse(response, false, "Action không được xác định", null);
            return;
        }

        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "get":
                handleGet(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Action không hợp lệ", null);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Campaign campaign = extractCampaignFromRequest(request);

            // Validate
            String validationError = campaignService.validateCampaign(campaign);
            if (validationError != null) {
                sendJsonResponse(response, false, validationError, null);
                return;
            }

            // Create
            Campaign created = campaignService.createCampaign(campaign);
            if (created != null) {
                sendJsonResponse(response, true, Constants.SUCCESS_CAMPAIGN_CREATED, created);
            } else {
                sendJsonResponse(response, false, "Không thể tạo chiến dịch", null);
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage(), null);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Campaign campaign = extractCampaignFromRequest(request);

            // Get ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID chiến dịch không được để trống", null);
                return;
            }

            campaign.setId(Long.parseLong(idStr));

            // Validate
            String validationError = campaignService.validateCampaign(campaign);
            if (validationError != null) {
                sendJsonResponse(response, false, validationError, null);
                return;
            }

            // Update
            boolean updated = campaignService.updateCampaign(campaign);
            if (updated) {
                sendJsonResponse(response, true, Constants.SUCCESS_CAMPAIGN_UPDATED, campaign);
            } else {
                sendJsonResponse(response, false, "Không thể cập nhật chiến dịch", null);
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage(), null);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID chiến dịch không được để trống", null);
                return;
            }

            Long id = Long.parseLong(idStr);
            boolean deleted = campaignService.deleteCampaign(id);

            if (deleted) {
                sendJsonResponse(response, true, Constants.SUCCESS_CAMPAIGN_DELETED, null);
            } else {
                sendJsonResponse(response, false, "Không thể xóa chiến dịch", null);
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage(), null);
        }
    }

    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID chiến dịch không được để trống", null);
                return;
            }

            Long id = Long.parseLong(idStr);
            Campaign campaign = campaignService.getCampaignById(id);

            if (campaign != null) {
                sendJsonResponse(response, true, "Thành công", campaign);
            } else {
                sendJsonResponse(response, false, Constants.ERROR_CAMPAIGN_NOT_FOUND, null);
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage(), null);
        }
    }

    private Campaign extractCampaignFromRequest(HttpServletRequest request) throws ParseException {
        Campaign campaign = new Campaign();

        campaign.setName(request.getParameter("name"));

        String budgetStr = request.getParameter("budget");
        if (budgetStr != null && !budgetStr.trim().isEmpty()) {
            campaign.setBudget(new BigDecimal(budgetStr));
        } else {
            campaign.setBudget(BigDecimal.ZERO);
        }

        String startDateStr = request.getParameter("startDate");
        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
            campaign.setStartDate(parseDate(startDateStr));
        }

        String endDateStr = request.getParameter("endDate");
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            campaign.setEndDate(parseDate(endDateStr));
        }

        String managerIdStr = request.getParameter("managerId");
        if (managerIdStr != null && !managerIdStr.trim().isEmpty()) {
            campaign.setManagerId(Long.parseLong(managerIdStr));
        }

        String status = request.getParameter("status");
        if (status != null && !status.trim().isEmpty()) {
            campaign.setStatus(status);
        } else {
            campaign.setStatus("Draft");
        }

        campaign.setDescription(request.getParameter("description"));

        return campaign;
    }

    private Timestamp parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date date = sdf.parse(dateStr);
            return new Timestamp(date.getTime());
        } catch (ParseException e) {
            System.err.println("Error parsing date: " + dateStr);
            return null;
        }
    }

    private boolean hasFilters(String name, String status, Timestamp startDate, Timestamp endDate) {
        return (name != null && !name.trim().isEmpty())
                || (status != null && !status.trim().isEmpty())
                || startDate != null
                || endDate != null;
    }

    private boolean isManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        // Sửa dòng 301 trong CampaignServlet.java:
        Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);

// So sánh trực tiếp với hằng số Enum
        return Role.MANAGER.equals(userRole);
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
