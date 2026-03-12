package dao;

import model.viewmodel.MarketingDashboardVM;

/**
 * Interface for Marketing Dashboard data access.
 */
public interface MarketingDashboardDAO {
    
    /**
     * Get statistics for the marketing dashboard.
     * @param managerId ID of the manager (null for all)
     * @return MarketingDashboardVM containing aggregated stats
     */
    MarketingDashboardVM getDashboardStats(Integer managerId);
}
