package controller;

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
import java.util.List;
import java.util.Map;

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
        List<LandingPageViewModel> viewModels = new ArrayList<>();
        for (LandingPage lp : landingPages) {
            // Get Campaign Name
            String campaignName = "Unknown";
            if (lp.getCampaignId() != null) {
                Campaign campaign = campaignService.getCampaignById(lp.getCampaignId().longValue());
                if (campaign != null) {
                    campaignName = campaign.getName();
                }
            }

            // Get Assignee Name
            String assigneeName = "-";
            if (lp.getCreatedBy() != null) {
                User assignee = userService.getUserById(lp.getCreatedBy().longValue());
                if (assignee != null) {
                    assigneeName = assignee.getFullName();
                }
            }

            viewModels.add(LandingPageViewModel.fromEntity(lp, campaignName, assigneeName));
        }

        // Get all campaigns for dropdown
        List<Campaign> campaigns = campaignService.getAllCampaigns();
        
        // Get all Marketing staff for assignment dropdown
        List<User> marketingStaffs = userService.getUsersByRole(Role.MARKETING);

        // Set attributes
        request.setAttribute("landingPages", viewModels);
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("marketingStaffs", marketingStaffs);
        request.setAttribute("campaignIdFilter", campaignIdFilter);
        request.setAttribute("currentPage", "landing-pages");
        request.setAttribute("pageTitle", "Quản lý Landing Page");

        // Forward to JSP
        request.getRequestDispatcher("/views/marketing/landing-pages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is Manager (Only Manager can assign)
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
            case "delete":
                handleDelete(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Action không hợp lệ", null);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
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
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "ID không được để trống", null);
                return;
            }

            Integer id = Integer.parseInt(idStr);
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
}
