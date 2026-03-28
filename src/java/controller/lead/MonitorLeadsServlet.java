package controller.lead;

import dao.CampaignDAO;
import dao.LeadDAO;
import dao.UserDAO;
import dao.impl.CampaignDAOImpl;
import dao.impl.LeadDAOImpl;
import dao.impl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.entity.Campaign;
import model.entity.Lead;
import model.entity.Role;
import model.entity.User;
import model.viewmodel.MonitorKPIsViewModel;
import util.Constants;

@WebServlet(name = "MonitorLeadsServlet", urlPatterns = {"/marketing/monitor-leads"})
public class MonitorLeadsServlet extends HttpServlet {

    private LeadDAO leadDAO;
    private CampaignDAO campaignDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        leadDAO = new LeadDAOImpl();
        campaignDAO = new CampaignDAOImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Authentication Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // 2. Fetch parameters for filtering
        String campaignIdStr = request.getParameter("campaignId");
        Integer campaignId = null;
        if (campaignIdStr != null && !campaignIdStr.isEmpty()) {
            try {
                campaignId = Integer.valueOf(campaignIdStr);
            } catch (NumberFormatException e) {
                // Ignore invalid ID formats
            }
        }
        
        String searchQuery = request.getParameter("searchQuery");
        String dateFilter = request.getParameter("dateFilter");
        if (dateFilter == null) {
            dateFilter = "all"; // Default
        }

        // 3. Fetch data for the screen
        try {
            // Dropdown list
            List<Campaign> campaigns = campaignDAO.findAll();
            request.setAttribute("campaigns", campaigns);
            
            // Sales Users for assignment dropdown
            List<User> salesUsers = userDAO.findByRole(Role.SALE);
            request.setAttribute("salesUsers", salesUsers);

            // KPIs
            MonitorKPIsViewModel kpis = leadDAO.getMonitorKPIs(campaignId);
            request.setAttribute("kpis", kpis);

            // Hot Unassigned Leads (limit 50 for performance)
            List<Lead> hotLeads = leadDAO.getHotUnassignedLeads(campaignId, searchQuery, dateFilter, 50);
            request.setAttribute("hotLeads", hotLeads);


            // Keep selected filter in view
            request.setAttribute("selectedCampaignId", campaignId);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("dateFilter", dateFilter);
            request.setAttribute("currentPage", "monitor-leads");

            request.getRequestDispatcher("/views/manager/monitor-leads.jsp").forward(request, response);

        } catch (SQLException ex) {
            System.err.println("Error fetching Monitor Leads data: " + ex.getMessage());
            request.setAttribute("errorMsg", "Lỗi tải dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/manager/monitor-leads.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getParameter("action");
        if ("assign".equals(action)) {
            processAssignment(request, response, session);
        } else if ("massAssign".equals(action)) {
            processMassAssignment(request, response, session);
        } else if ("delete".equals(action)) {
            processDeletion(request, response, session);
        } else {
            doGet(request, response);
        }
    }

    private void processAssignment(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        Integer managerId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        String leadIdStr = request.getParameter("leadId");
        String salesIdStr = request.getParameter("salesId");
        String campaignIdStr = request.getParameter("listCampaignId"); // to keep filter active
        String searchQuery = request.getParameter("searchQuery");
        String dateFilter = request.getParameter("dateFilter");

        if (leadIdStr == null || salesIdStr == null || salesIdStr.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng chọn nhân viên Sales.");
        } else {
            try {
                int leadId = Integer.parseInt(leadIdStr);
                int salesId = Integer.parseInt(salesIdStr);

                boolean success = leadDAO.assignLeadToSales(leadId, salesId, managerId);
                
                if (success) {
                    session.setAttribute("successMsg", "Đã phân công Lead thành công.");
                } else {
                    session.setAttribute("errorMsg", "Phân công thất bại. Có thể Lead đã được phân công hoặc bị xóa.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Lỗi định dạng dữ liệu.");
            }
        }
        
        // Redirect back to GET to refresh data
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/marketing/monitor-leads?");
        if (campaignIdStr != null && !campaignIdStr.isEmpty()) {
            redirectUrl.append("campaignId=").append(campaignIdStr).append("&");
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            redirectUrl.append("searchQuery=").append(searchQuery).append("&");
        }
        if (dateFilter != null && !dateFilter.isEmpty()) {
            redirectUrl.append("dateFilter=").append(dateFilter);
        }
        response.sendRedirect(redirectUrl.toString());
    }

    private void processMassAssignment(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        Integer managerId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        String[] leadIdsStr = request.getParameterValues("selectedLeadIds");
        String salesIdStr = request.getParameter("massSalesId");
        String campaignIdStr = request.getParameter("listCampaignId");
        String searchQuery = request.getParameter("searchQuery");
        String dateFilter = request.getParameter("dateFilter");

        if (leadIdsStr == null || leadIdsStr.length == 0) {
            session.setAttribute("errorMsg", "Vui lòng chọn ít nhất một Lead để phân công.");
        } else if (salesIdStr == null || salesIdStr.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng chọn nhân viên Sales.");
        } else {
            try {
                int salesId = Integer.parseInt(salesIdStr);
                int successCount = 0;
                
                for (String leadIdStr : leadIdsStr) {
                    try {
                        int leadId = Integer.parseInt(leadIdStr);
                        if (leadDAO.assignLeadToSales(leadId, salesId, managerId)) {
                            successCount++;
                        }
                    } catch (NumberFormatException ignored) {
                        // Ignore malformed individual inputs but continue loops
                    }
                }
                
                if (successCount > 0) {
                    session.setAttribute("successMsg", "Đã phân công thành công " + successCount + " Lead(s).");
                } else {
                    session.setAttribute("errorMsg", "Phân công thất bại. Các Lead có thể đã được phân công trước đó.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Lỗi định dạng dữ liệu nhân viên Sales.");
            }
        }
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/marketing/monitor-leads?");
        if (campaignIdStr != null && !campaignIdStr.isEmpty()) {
            redirectUrl.append("campaignId=").append(campaignIdStr).append("&");
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            redirectUrl.append("searchQuery=").append(searchQuery).append("&");
        }
        if (dateFilter != null && !dateFilter.isEmpty()) {
            redirectUrl.append("dateFilter=").append(dateFilter);
        }
        response.sendRedirect(redirectUrl.toString());
    }
    private void processDeletion(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        String leadIdStr = request.getParameter("leadId");
        String campaignIdStr = request.getParameter("listCampaignId");
        String searchQuery = request.getParameter("searchQuery");
        String dateFilter = request.getParameter("dateFilter");

        if (leadIdStr != null) {
            try {
                int leadId = Integer.parseInt(leadIdStr);
                if (leadDAO.delete(leadId)) {
                    session.setAttribute("successMsg", "Đã xóa Lead thành công.");
                } else {
                    session.setAttribute("errorMsg", "Xóa thất bại. Lead có thể đã được phân công hoặc không tồn tại.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "Lỗi định dạng ID Lead.");
            }
        }

        // Redirect back with filters
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/marketing/monitor-leads?");
        if (campaignIdStr != null && !campaignIdStr.isEmpty()) {
            redirectUrl.append("campaignId=").append(campaignIdStr).append("&");
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            redirectUrl.append("searchQuery=").append(searchQuery).append("&");
        }
        if (dateFilter != null && !dateFilter.isEmpty()) {
            redirectUrl.append("dateFilter=").append(dateFilter);
        }
        response.sendRedirect(redirectUrl.toString());
    }
}
