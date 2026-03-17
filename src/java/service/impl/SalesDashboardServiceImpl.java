package service.impl;

import dao.SalesDashboardDAO;
import dao.impl.SalesDashboardDAOImpl;
import model.viewmodel.SalesDashboardVM;
import service.SalesDashboardService;

public class SalesDashboardServiceImpl implements SalesDashboardService {
    private final SalesDashboardDAO salesDashboardDAO = new SalesDashboardDAOImpl();

    @Override
    public SalesDashboardVM getSalesDashboardData(int salesId) {
        return salesDashboardDAO.getSalesDashboardStats(salesId);
    }

    @Override
    public SalesDashboardVM getGlobalSalesDashboardData() {
        return salesDashboardDAO.getGlobalSalesDashboardStats();
    }
}
