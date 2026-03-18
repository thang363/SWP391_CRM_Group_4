package dao;

import model.viewmodel.SalesDashboardVM;

public interface SalesDashboardDAO {
    SalesDashboardVM getSalesDashboardStats(int salesId);
    SalesDashboardVM getGlobalSalesDashboardStats();
}
