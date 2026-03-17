package service;

import model.viewmodel.SalesDashboardVM;

public interface SalesDashboardService {
    SalesDashboardVM getSalesDashboardData(int salesId);
    SalesDashboardVM getGlobalSalesDashboardData();
}
