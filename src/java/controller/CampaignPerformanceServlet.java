package controller;

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
        if (!Role.MARKETING.equals(userRole)) {
            request.getRequestDispatcher(Constants.PAGE_403).forward(request, response);
            return;
        }

        // Get current user ID
        Integer marketingId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);

        // Get performance data
        List<CampaignPerformanceVM> performanceList = campaignService.getMarketingPerformance(marketingId);

        // Calculate summary KPIs
        int totalLeads = 0;
        int totalOpportunities = 0;
        int totalCustomers = 0;
        for (CampaignPerformanceVM vm : performanceList) {
            totalLeads += vm.getTotalLeads();
            totalOpportunities += vm.getConvertedToOpportunity();
            totalCustomers += vm.getConvertedToCustomer();
        }

        // Set attributes
        request.setAttribute("performanceList", performanceList);
        request.setAttribute("totalLeads", totalLeads);
        request.setAttribute("totalOpportunities", totalOpportunities);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("campaignCount", performanceList.size());
        request.setAttribute("currentPage", "marketing-performance");
        request.setAttribute("pageTitle", "Thành quả Chiến dịch");

        // Forward to JSP
        request.getRequestDispatcher(Constants.PAGE_MARKETING_PERFORMANCE).forward(request, response);
    }
}
