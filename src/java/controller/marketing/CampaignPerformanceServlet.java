package controller.marketing;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Role;
import model.viewmodel.CampaignPerformanceVM;
import service.CampaignService;
import service.impl.CampaignServiceImpl;
import util.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CampaignPerformanceServlet", urlPatterns = {"/marketing/performance"})
public class CampaignPerformanceServlet extends HttpServlet {

    private final CampaignService campaignService;

    public CampaignPerformanceServlet() {
        this.campaignService = new CampaignServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check role - Only MARKETING can access
        Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);
        if (!Role.MARKETING.equals(userRole) && !Role.MANAGER.equals(userRole)) {
            request.getRequestDispatcher(Constants.PAGE_403).forward(request, response);
            return;
        }

        // Get current user ID
        Integer marketingId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Get total summaries (KPIs) - still need all data for this
        // In a real high-scale app, we'd use a specific summary query
        List<CampaignPerformanceVM> allPerformance = campaignService.getMarketingPerformance(marketingId);
        
        int totalLeads = 0;
        int totalOpportunities = 0;
        int totalCustomers = 0;
        for (CampaignPerformanceVM vm : allPerformance) {
            totalLeads += vm.getTotalLeads();
            totalOpportunities += vm.getConvertedToOpportunity();
            totalCustomers += vm.getConvertedToCustomer();
        }

        // Get paged performance data for the table
        List<CampaignPerformanceVM> performanceList = campaignService.getMarketingPerformancePaged(marketingId, page, pageSize);
        int totalRecords = campaignService.countMarketingPerformance(marketingId);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Set attributes
        request.setAttribute("performanceList", performanceList);
        request.setAttribute("allPerformance", allPerformance);
        request.setAttribute("totalLeads", totalLeads);
        request.setAttribute("totalOpportunities", totalOpportunities);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("campaignCount", totalRecords);
        request.setAttribute("currentPageNum", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("currentPage", "marketing-performance");
        request.setAttribute("pageTitle", "Thành quả Chiến dịch");

        // Forward to JSP
        request.getRequestDispatcher(Constants.PAGE_MARKETING_PERFORMANCE).forward(request, response);
    }
}
