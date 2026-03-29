package controller.marketing;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.LandingPage;
import model.entity.Role;
import model.entity.User;
import model.entity.Campaign;
import model.viewmodel.LandingPageViewModel;
import service.LandingPageService;
import service.UserService;
import service.CampaignService;
import service.impl.LandingPageServiceImpl;
import service.impl.UserServiceImpl;
import service.impl.CampaignServiceImpl;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "LandingPageServlet", urlPatterns = {"/landing-pages"})
public class LandingPageServlet extends HttpServlet {

    private final LandingPageService lpService;
    private final UserService userService;
    private final CampaignService campaignService;
    private final Gson gson;

    public LandingPageServlet() {
        this.lpService = new LandingPageServiceImpl();
        this.userService = new UserServiceImpl();
        this.campaignService = new CampaignServiceImpl();
        this.gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Handle action parameter
        String action = request.getParameter("action");
        
        // Handle preview action
        if ("preview".equals(action)) {
            handlePreview(request, response);
            return;
        } else if ("detail".equals(action)) {
            handleDetail(request, response);
            return;
        }

        // Get filter: campaignId (optional)
        String campaignIdStr = request.getParameter("campaignId");
        Integer campaignIdFilter = null;
        if (campaignIdStr != null && !campaignIdStr.trim().isEmpty()) {
            try {
                campaignIdFilter = Integer.parseInt(campaignIdStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        // Get all landing pages (or filtered by campaign)
        List<LandingPage> landingPages;
        if (campaignIdFilter != null) {
            landingPages = ((LandingPageServiceImpl) lpService).getLandingPageDAO().findAllByCampaignId(campaignIdFilter);
        } else {
            landingPages = ((LandingPageServiceImpl) lpService).getLandingPageDAO().findAll();
        }

        // Convert to ViewModels
        // Convert to ViewModels and Filter by Role
        List<LandingPageViewModel> viewModels = new ArrayList<>();
        Integer currentUserId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);
        boolean isManager = Role.MANAGER.equals(userRole);

        // Track visible campaigns for filter dropdown
        Set<Integer> visibleCampaignIds = new HashSet<>();

        for (LandingPage lp : landingPages) {
            // Get Campaign Info
            Campaign campaign = null;
            if (lp.getCampaignId() != null) {
                campaign = campaignService.getCampaignById(lp.getCampaignId());
            }
            
            // Visibility Filter
            if (isManager) {
                // Manager: Only see LPs from Campaigns they manage
                if (campaign == null || campaign.getManagerId() == null || !currentUserId.equals(campaign.getManagerId())) {
                    continue; 
                }
            } else {
                // Marketing: Only see LPs assigned to them
                if (lp.getCreatedBy() == null || !currentUserId.equals(lp.getCreatedBy())) {
                    continue;
                }
            }
            
            // Add to visible campaigns set
            if (lp.getCampaignId() != null) {
                visibleCampaignIds.add(lp.getCampaignId());
            }

            // Get Campaign Name
            String campaignName = (campaign != null) ? campaign.getName() : "Unknown";

            // Get Assignee Name
            String assigneeName = "-";
            if (lp.getCreatedBy() != null) {
                User assignee = userService.getUserById(lp.getCreatedBy());
                if (assignee != null) {
                    assigneeName = assignee.getFullName();
                }
            }

            viewModels.add(LandingPageViewModel.fromEntity(lp, campaignName, assigneeName));
        }

        // Get all campaigns for dropdown
        // Manager: All campaigns they manage (to allow creating new LPs for empty campaigns)
        // Marketing: Only campaigns related to LPs they are assigned to
        List<Campaign> campaigns = new ArrayList<>();
        List<Campaign> allCampaigns = campaignService.getAllCampaigns();
        
        if (isManager) {
            for (Campaign c : allCampaigns) {
                if (c.getManagerId() != null && c.getManagerId().equals(currentUserId)) {
                    campaigns.add(c);
                }
            }
        } else {
            // Marketing: Filter based on visible LPs
            for (Campaign c : allCampaigns) {
                if (visibleCampaignIds.contains(c.getId().intValue())) {
                   campaigns.add(c);
                }
            }
        }
        
        // Get all Marketing staff for assignment dropdown
        List<User> marketingStaffs = userService.getUsersByRole(Role.MARKETING);

        // --- Pagination Logic ---
        int page = 1;
        int pageSize = 10; // Items per page
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                // Default to 1
            }
        }

        int totalItems = viewModels.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<LandingPageViewModel> paginatedList = new ArrayList<>();
        if (totalItems > 0) {
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalItems);
            paginatedList = viewModels.subList(startIndex, endIndex);
        }

        // Set attributes
        request.setAttribute("landingPages", paginatedList); 
        request.setAttribute("currentPageNum", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("marketingStaffs", marketingStaffs);
        request.setAttribute("isManager", isManager);
        request.setAttribute("campaignIdFilter", campaignIdFilter);
        request.setAttribute("currentPage", "landing-pages");
        request.setAttribute("pageTitle", "Quản lý Landing Page");

        // Forward to JSP
        request.getRequestDispatcher("/views/marketing/landing-pages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session verification for POST actions
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            sendJsonResponse(response, false, "Session đã hết hạn. Vui lòng đăng nhập lại.", null);
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
            case "delete":
                handleDelete(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "change-status":
                handleStatusChange(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Action không hợp lệ", null);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isManager(request)) {
            sendJsonResponse(response, false, "Chỉ Manager mới có quyền tạo Landing Page", null);
            return;
        }
        try {
            String campaignIdStr = request.getParameter("campaignId");
            String marketingIdStr = request.getParameter("marketingId");
            String brief = request.getParameter("brief");

            if (campaignIdStr == null || marketingIdStr == null) {
                sendJsonResponse(response, false, "Thiếu thông tin bắt buộc", null);
                return;
            }

            Integer campaignId = Integer.parseInt(campaignIdStr);
            Integer marketingId = Integer.parseInt(marketingIdStr);
            
            // Centralized Security Check
            HttpSession session = request.getSession(false);
            Integer currentUserId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
            Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);

            if (!hasCampaignPermission(currentUserId, userRole, campaignId)) {
                sendJsonResponse(response, false, "Bạn không có quyền tạo Landing Page cho chiến dịch này", null);
                return;
            }

            boolean success = lpService.assignMarketing(campaignId, marketingId, brief);

            if (success) {
                sendJsonResponse(response, true, "Tạo Landing Page mới thành công", null);
            } else {
                sendJsonResponse(response, false, "Tạo Landing Page thất bại. Vui lòng thử lại.", null);
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Dữ liệu ID không hợp lệ", null);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isManager(request)) {
            sendJsonResponse(response, false, "Chỉ Manager mới có quyền xóa Landing Page", null);
            return;
        }
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID không được để trống", null);
                return;
            }

            Integer id = Integer.parseInt(idStr);
            LandingPage lp = ((LandingPageServiceImpl) lpService).getLandingPageById(id);
            
            if (lp == null) {
                sendJsonResponse(response, false, "Landing Page không tồn tại", null);
                return;
            }
            
            // Security check
            if (!hasAccessPermission(request, lp)) {
                sendJsonResponse(response, false, "Bạn không có quyền xóa Landing Page này", null);
                return;
            }

            boolean deleted = ((LandingPageServiceImpl) lpService).getLandingPageDAO().delete(id);

            if (deleted) {
                sendJsonResponse(response, true, "Xóa Landing Page thành công", null);
            } else {
                sendJsonResponse(response, false, "Không thể xóa Landing Page", null);
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Dữ liệu ID không hợp lệ", null);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID không được để trống", null);
                return;
            }

            Integer id = Integer.parseInt(idStr);
            LandingPage lp = ((LandingPageServiceImpl) lpService).getLandingPageById(id);
            
            if (lp == null) {
                sendJsonResponse(response, false, "Landing Page không tồn tại", null);
                return;
            }
            
            // Security check
            if (!hasAccessPermission(request, lp)) {
                sendJsonResponse(response, false, "Bạn không có quyền truy cập Landing Page này", null);
                return;
            }
            
            // Parse data config to extract hero fields
            Map<String, Object> data = new HashMap<>();
            data.put("id", lp.getId());
            data.put("name", lp.getName());
            data.put("brief", lp.getBrief());
            
            String heroTitle = "";
            String heroDesc = "";
            
            try {
                if (lp.getDataConfig() != null) {
                    com.google.gson.JsonObject json = gson.fromJson(lp.getDataConfig(), com.google.gson.JsonObject.class);
                   
                    for (java.util.Map.Entry<String, com.google.gson.JsonElement> entry : json.entrySet()) {
                        if (!entry.getValue().isJsonNull()) {
                            
                            String key = entry.getKey();
                            String value = entry.getValue().getAsString();
                            
                            if ("HERO_TITLE".equals(key)) data.put("heroTitle", value);
                            else if ("HERO_DESC".equals(key)) data.put("heroDesc", value);
                            else if ("ABOUT_TITLE".equals(key)) data.put("aboutTitle", value);
                            else if ("ABOUT_DESC".equals(key)) data.put("aboutDesc", value);
                            else if (key.startsWith("FEATURE_")) data.put(toCamelCase(key), value); 
                            else data.put(key, value);
                        }
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }
            data.put("status", lp.getStatus());

            sendJsonResponse(response, true, "Lấy dữ liệu thành công", data);

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống", null);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String brief = request.getParameter("brief");
            String heroTitle = request.getParameter("heroTitle");
            String heroDesc = request.getParameter("heroDesc");

            if (idStr == null || name == null || name.trim().isEmpty()) {
                sendJsonResponse(response, false, "Tên Landing Page không được để trống", null);
                return;
            }

            if (heroTitle == null || heroTitle.trim().isEmpty()) {
                sendJsonResponse(response, false, "Tiêu đề Hero không được để trống", null);
                return;
            }

            Integer id = Integer.parseInt(idStr);
            boolean isManager = isManager(request);
            
            LandingPage lp = ((LandingPageServiceImpl) lpService).getLandingPageById(id);
            if (lp == null) {
                sendJsonResponse(response, false, "Landing Page không tìm thấy", null);
                return;
            }
            
            if (isManager) {
                sendJsonResponse(response, false, "Manager không được phép chỉnh sửa nội dung Landing Page. Vui lòng sử dụng tính năng Góp ý khi duyệt bài.", null);
                return;
            }
            
            if (!hasAccessPermission(request, lp)) {
                sendJsonResponse(response, false, "Bạn không có quyền chỉnh sửa Landing Page này", null);
                return;
            }

            // Length validation
            if (name.length() > 200) {
                 sendJsonResponse(response, false, "Tên Landing Page quá dài (tối đa 200 ký tự)", null);
                 return;
            }
            if (heroTitle.length() > 200) {
                 sendJsonResponse(response, false, "Tiêu đề Hero quá dài (tối đa 200 ký tự)", null);
                 return;
            }
            if (heroDesc != null && heroDesc.length() > 1000) {
                 sendJsonResponse(response, false, "Mô tả Hero quá dài (tối đa 1000 ký tự)", null);
                 return;
            }
            if (brief != null && brief.length() > 500) {
                 sendJsonResponse(response, false, "Mô tả nội bộ quá dài (tối đa 500 ký tự)", null);
                 return;
            }

            java.util.Map<String, String> contentFields = new HashMap<>();
            contentFields.put("HERO_TITLE", heroTitle.trim());
            contentFields.put("HERO_DESC", heroDesc != null ? heroDesc.trim() : "");
            
            // Collect other fields safely with length limits
            addIfPresent(request, contentFields, "aboutTitle", "ABOUT_TITLE", 200);
            addIfPresent(request, contentFields, "aboutDesc", "ABOUT_DESC", 2000);
            
            addIfPresent(request, contentFields, "featureTitle1", "FEATURE_TITLE_1", 100);
            addIfPresent(request, contentFields, "featureDesc1", "FEATURE_DESC_1", 500);
            addIfPresent(request, contentFields, "featureTitle2", "FEATURE_TITLE_2", 100);
            addIfPresent(request, contentFields, "featureDesc2", "FEATURE_DESC_2", 500);
            addIfPresent(request, contentFields, "featureTitle3", "FEATURE_TITLE_3", 100);
            addIfPresent(request, contentFields, "featureDesc3", "FEATURE_DESC_3", 500);

            boolean success = lpService.updateLandingPage(id, name, brief, contentFields, isManager);

            if (success) {
                sendJsonResponse(response, true, "Cập nhật thành công", null);
            } else {
                sendJsonResponse(response, false, "Cập nhật thất bại", null);
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Dữ liệu không hợp lệ", null);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("status");
            
             
            if (newStatus == null || newStatus.isEmpty()) {
                sendJsonResponse(response, false, "Trạng thái không hợp lệ", null);
                return;
            }

            boolean isManager = isManager(request);
            
            LandingPage lp = lpService.getLandingPageById(id);
            if (lp == null) {
                sendJsonResponse(response, false, "Landing Page không tồn tại", null);
                return;
            }
            
            if (!hasAccessPermission(request, lp)) {
                sendJsonResponse(response, false, "Bạn không có quyền thực hiện thao tác này", null);
                return;
            }
            
            if (isManager) {
                sendJsonResponse(response, false, "Manager không được đổi trạng thái ", null);
                return;
            } else {
                if (!"Public".equals(newStatus) && !"Draft".equals(newStatus)) {
                     sendJsonResponse(response, false, "Staff chỉ có thể Công khai hoặc Lưu nháp", null);
                     return;
                }
                
                if ("Public".equals(newStatus)) {
                    if (lp.getCampaignId() == null) {
                        sendJsonResponse(response, false, "Không tìm thấy thông tin Chiến dịch", null);
                        return;
                    }
                    Campaign campaign = campaignService.getCampaignById(lp.getCampaignId());
                    if (campaign == null || !"Active".equals(campaign.getStatus())) {
                        sendJsonResponse(response, false, "Chỉ có thể Công khai Landing Page khi Chiến dịch đang Active", null);
                        return;
                    }
                }
            }
            
            String comment = request.getParameter("comment");
            boolean success = lpService.updateStatus(id, newStatus, comment);
            
            if (success) {
                sendJsonResponse(response, true, "Cập nhật trạng thái thành công: " + newStatus, null);
            } else {
                sendJsonResponse(response, false, "Cập nhật thất bại", null);
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống", null);
        }
    }

    private void handlePreview(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<h1>Error: Missing Landing Page ID</h1>");
                return;
            }

            Integer id = Integer.parseInt(idStr);
            LandingPage lp = lpService.getLandingPageById(id);
            
            if (lp == null) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<h1>Error: Landing Page not found</h1>");
                return;
            }
            
            if (!hasAccessPermission(request, lp)) {
                 response.setContentType("text/html;charset=UTF-8");
                 response.getWriter().println("<h1>Forbidden: You don't have access to this page</h1>");
                 return;
            }
            
            
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
            request.setAttribute("landingPageId", id);
            request.setAttribute("pageTitle", lp.getName());
            
            // Forward to JSP template
            request.getRequestDispatcher("/templates/standout/landing-page.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>Error: Invalid Landing Page ID</h1>");
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }

    private boolean isManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);
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
    private boolean hasAccessPermission(HttpServletRequest request, LandingPage lp) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        Integer currentUserId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);
        
        if (currentUserId == null || userRole == null) return false;
        
        // 1. Manager Check: Can only access LPs within Campaigns they manage
        if (Role.MANAGER.equals(userRole)) {
            return hasCampaignPermission(currentUserId, userRole, lp.getCampaignId());
        } 
        
        // 2. Marketing Check: Can only access LPs explicitly assigned to them
        if (Role.MARKETING.equals(userRole)) {
            return currentUserId.equals(lp.getCreatedBy());
        }
        
        return false;
    }

   
    private boolean hasCampaignPermission(Integer userId, Role role, Integer campaignId) {
        if (userId == null || role == null || campaignId == null) return false;
        
        if (Role.MANAGER.equals(role)) {
            Campaign campaign = campaignService.getCampaignById(campaignId);
            return campaign != null && userId.equals(campaign.getManagerId());
        }
        
       
        
        return false;
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

    private void addIfPresent(HttpServletRequest request, java.util.Map<String, String> map, String paramName, String keyName, int maxLength) {
        String value = request.getParameter(paramName);
        if (value != null) {
            String trimmed = value.trim();
            if (maxLength > 0 && trimmed.length() > maxLength) {
                trimmed = trimmed.substring(0, maxLength); // Soft truncate or handle as error? For JSON, we can truncate but Servlet check is better
            }
            map.put(keyName, trimmed);
        }
    }
}
