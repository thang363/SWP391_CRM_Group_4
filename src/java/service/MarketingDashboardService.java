package service;

import model.viewmodel.MarketingDashboardVM;

/**
 * Service interface for Marketing Dashboard.
 */
public interface MarketingDashboardService {
    
    /**
     * Get the marketing dashboard data for a manager.
     * @param managerId ID of the manager
     * @return MarketingDashboardVM
     */
    MarketingDashboardVM getDashboardData(Integer managerId);
}
