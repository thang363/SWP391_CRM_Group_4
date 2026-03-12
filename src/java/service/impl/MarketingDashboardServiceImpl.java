package service.impl;

import dao.MarketingDashboardDAO;
import dao.impl.MarketingDashboardDAOImpl;
import model.viewmodel.MarketingDashboardVM;
import service.MarketingDashboardService;

/**
 * Implementation of MarketingDashboardService.
 */
public class MarketingDashboardServiceImpl implements MarketingDashboardService {

    private final MarketingDashboardDAO dashboardDAO;

    public MarketingDashboardServiceImpl() {
        this.dashboardDAO = new MarketingDashboardDAOImpl();
    }

    @Override
    public MarketingDashboardVM getDashboardData(Integer managerId) {
        if (managerId == null) {
            return null;
        }
        return dashboardDAO.getDashboardStats(managerId);
    }
}
