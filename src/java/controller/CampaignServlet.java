package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.CampaignTransferDAO;
import dao.impl.CampaignTransferDAOImpl;
import model.entity.Campaign;
import model.entity.Role;
import model.entity.User;
import model.viewmodel.CampaignViewModel;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CampaignServlet", urlPatterns = {"/campaigns"})
public class CampaignServlet extends HttpServlet {

    private final CampaignService campaignService;
    private final UserService userService;
    private final CampaignTransferDAO transferDAO;
    private final service.LandingPageService lpService;
    private final Gson gson;

    public CampaignServlet() {
        this.campaignService = new CampaignServiceImpl();
        this.userService = new UserServiceImpl();
        this.transferDAO = new CampaignTransferDAOImpl();
        this.lpService = new service.impl.LandingPageServiceImpl();
        this.gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user from session
        HttpSession session = request.getSession(false);
        Long currentUserId = (Long) session.getAttribute(Constants.SESSION_USER_ID);
        Role currentUserRole = (Role) session.getAttribute(Constants.SESSION_ROLE);

        // Handle AJAX GET requests (e.g., fetch particular campaign for edit)
        String action = request.getParameter("action");
        if ("get".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            handleGet(request, response);
            return;
        }

        // Get filter parameters
        // Get filter parameters
        String nameFilter = request.getParameter("name");
        String statusFilter = request.getParameter("status");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // Parse dates
        Timestamp startDate = parseDate(startDateStr);
        Timestamp endDate = parseDate(endDateStr);

        // Pagination
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

        // Manager-level access control: filter by managerId unless Admin
        Long managerIdFilter = null;
        if (Role.MANAGER.equals(currentUserRole)) {
            managerIdFilter = currentUserId; // Only show campaigns managed by this user
        }
        // If Admin, managerIdFilter stays null = see all campaigns

        // Get total items and calculate pages
        int totalItems = campaignService.countCampaigns(nameFilter, statusFilter, startDate, endDate, managerIdFilter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) {
            page = totalPages;
            offset = (page - 1) * pageSize;
        }

        // Get campaigns
        // Get campaigns
        List<Campaign> campaigns;
        String idFilterStr = request.getParameter("id");
        if (idFilterStr != null && !idFilterStr.trim().isEmpty()) {
            // Filter by specific ID (from LP list link)
            try {
                Long idFilter = Long.parseLong(idFilterStr);
                Campaign specificCampaign = campaignService.getCampaignById(idFilter);
                if (specificCampaign != null) {
                    // Check manager permission
                    if (!Role.MANAGER.equals(currentUserRole) || 
                        specificCampaign.getManagerId() != null && specificCampaign.getManagerId().equals(currentUserId)) {
                         campaigns = new ArrayList<>();
                         campaigns.add(specificCampaign);
                    } else {
                        campaigns = new ArrayList<>(); // Found but no permission
                    }
                } else {
                    campaigns = new ArrayList<>(); // Not found
                }
                totalItems = campaigns.size(); // Reset totals
            } catch (NumberFormatException e) {
                 campaigns = new ArrayList<>();
            }
        } else {
            // Normal search
             campaigns = campaignService.searchCampaigns(nameFilter, statusFilter, startDate, endDate, managerIdFilter, offset, pageSize);
        }

        // Convert to ViewModels
        List<CampaignViewModel> viewModels = new ArrayList<>();

        for (Campaign c : campaigns) {
            // Get manager name
            String managerName = "Unknown";
            User manager = userService.getUserById(c.getManagerId());
            if (manager != null) {
                managerName = manager.getFullName();
            }
            
            // Check pending transfer
            boolean hasPending = transferDAO.hasPendingTransfer(c.getId());
            
            // Get Landing Page info
            String lpStatus = "null";
            Long assigneeId = null;
            String assigneeName = "-";
            
            model.entity.LandingPage lp = lpService.getLandingPageByCampaignId(c.getId().intValue());
            if (lp != null) {
                lpStatus = lp.getStatus();
                if (lp.getCreatedBy() != null) {
                    assigneeId = Long.valueOf(lp.getCreatedBy());
                    User assignee = userService.getUserById(assigneeId);
                    assigneeName = (assignee != null) ? assignee.getFullName() : "Unknown ID: " + assigneeId;
                }
            }
            
            // Create ViewModel
            viewModels.add(CampaignViewModel.fromEntity(c, managerName, hasPending, lpStatus, assigneeId, assigneeName));
        }

        // Get all managers for Transfer dropdown
        List<User> managers = userService.getUsersByRole(Role.MANAGER);
        
        // Get all Marketing staff for Assignment dropdown
        List<User> marketingStaffs = userService.getUsersByRole(Role.MARKETING);

        // Set attributes
        request.setAttribute("campaigns", viewModels);
        request.setAttribute("managers", managers);
        request.setAttribute("marketingStaffs", marketingStaffs);
        request.setAttribute("currentPageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
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
            // LP Assignment moved to /landing-pages
            default:
                sendJsonResponse(response, false, "Action không hợp lệ", null);
        }
    }

    // handleAssign moved to LandingPageServlet

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Campaign campaign = extractCampaignFromRequest(request);
            
            // Force status to Draft for newly created campaigns
            campaign.setStatus("Draft");

            // Auto-assign current user as campaign manager
            HttpSession session = request.getSession(false);
            Long currentUserId = (Long) session.getAttribute(Constants.SESSION_USER_ID);
            campaign.setManagerId(currentUserId);

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

            // Authorization check: Manager can only update their own campaigns
            HttpSession session = request.getSession(false);
            Long currentUserId = (Long) session.getAttribute(Constants.SESSION_USER_ID);
            Role currentUserRole = (Role) session.getAttribute(Constants.SESSION_ROLE);

            Campaign existingCampaign = campaignService.getCampaignById(campaign.getId());
            if (existingCampaign == null) {
                sendJsonResponse(response, false, "Chiến dịch không tồn tại", null);
                return;
            }

            if (Role.MANAGER.equals(currentUserRole)) {
                if (existingCampaign.getManagerId() == null || !existingCampaign.getManagerId().equals(currentUserId)) {
                    sendJsonResponse(response, false, "Bạn không có quyền chỉnh sửa chiến dịch này", null);
                    return;
                }
            }

            // Check if campaign has pending transfer - prevent editing during handover
            if (transferDAO.hasPendingTransfer(campaign.getId())) {
                sendJsonResponse(response, false, "Chiến dịch đang trong quá trình chuyển giao, không thể chỉnh sửa", null);
                return;
            }

            // Preserve managerId - it should only change via Transfer, not direct edit
            campaign.setManagerId(existingCampaign.getManagerId());

            // Check status transition validity
            String oldStatus = existingCampaign.getStatus();
            String newStatus = campaign.getStatus();

            if (oldStatus != null && newStatus != null && !oldStatus.equals(newStatus)) {
                boolean validTransition = false;
                switch (oldStatus) {
                    case "Draft":
                        if (newStatus.equals("Active") || newStatus.equals("Finished")) validTransition = true;
                        break;
                    case "Active":
                        if (newStatus.equals("Paused") || newStatus.equals("Finished")) validTransition = true;
                        break;
                    case "Paused":
                        if (newStatus.equals("Active") || newStatus.equals("Finished")) validTransition = true;
                        break;
                    case "Finished":
                        // No transitions allowed from Finished
                        break;
                }
                
                if (!validTransition) {
                    sendJsonResponse(response, false, "Chuyển đổi trạng thái từ " + oldStatus + " sang " + newStatus + " không hợp lệ", null);
                    return;
                }
            }

            // Validate
            String validationError = campaignService.validateCampaign(campaign);
            if (validationError != null) {
                System.out.println("Update failed validation: " + validationError);
                sendJsonResponse(response, false, validationError, null);
                return;
            }

            System.out.println("Updating campaign: " + campaign.toString());

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

            // Check if campaign has pending transfer - prevent deletion during handover
            if (transferDAO.hasPendingTransfer(id)) {
                sendJsonResponse(response, false, "Chiến dịch đang trong quá trình chuyển giao, không thể xóa", null);
                return;
            }

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

            if (campaign == null) {
                sendJsonResponse(response, false, Constants.ERROR_CAMPAIGN_NOT_FOUND, null);
                return;
            }

            // Authorization: Manager can only view their own campaigns
            HttpSession session = request.getSession(false);
            Long currentUserId = (Long) session.getAttribute(Constants.SESSION_USER_ID);
            Role currentUserRole = (Role) session.getAttribute(Constants.SESSION_ROLE);

            if (Role.MANAGER.equals(currentUserRole)) {
                if (campaign.getManagerId() == null || !campaign.getManagerId().equals(currentUserId)) {
                    sendJsonResponse(response, false, "Bạn không có quyền xem chiến dịch này", null);
                    return;
                }
            }

            sendJsonResponse(response, true, "Thành công", campaign);

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
            campaign.setStatus(status.trim());
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
