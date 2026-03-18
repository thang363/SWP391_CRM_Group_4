package model.viewmodel;

import java.math.BigDecimal;
import java.util.Map;

public class SalesDashboardVM {
    private BigDecimal revenueToday;
    private BigDecimal totalRevenue;
    private int newCustomersCount;
    private int openDealsCount;
    
    // Dữ liệu cho biểu đồ (Tháng -> Doanh số)
    private Map<String, BigDecimal> monthlySales;
    // Dữ liệu cho biểu đồ (Nguồn -> Số lượng Lead)
    private Map<String, Integer> leadsBySource;
    // Danh sách deal gần đây
    private java.util.List<model.entity.Opportunity> recentOpportunities;

    public SalesDashboardVM() {
        this.revenueToday = BigDecimal.ZERO;
        this.totalRevenue = BigDecimal.ZERO;
    }

    public BigDecimal getRevenueToday() { return revenueToday; }
    public void setRevenueToday(BigDecimal revenueToday) { this.revenueToday = revenueToday; }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

    public int getNewCustomersCount() { return newCustomersCount; }
    public void setNewCustomersCount(int newCustomersCount) { this.newCustomersCount = newCustomersCount; }

    public int getOpenDealsCount() { return openDealsCount; }
    public void setOpenDealsCount(int openDealsCount) { this.openDealsCount = openDealsCount; }

    public Map<String, BigDecimal> getMonthlySales() { return monthlySales; }
    public void setMonthlySales(Map<String, BigDecimal> monthlySales) { this.monthlySales = monthlySales; }

    public Map<String, Integer> getLeadsBySource() { return leadsBySource; }
    public void setLeadsBySource(Map<String, Integer> leadsBySource) { this.leadsBySource = leadsBySource; }

    public java.util.List<model.entity.Opportunity> getRecentOpportunities() { return recentOpportunities; }
    public void setRecentOpportunities(java.util.List<model.entity.Opportunity> recentOpportunities) { this.recentOpportunities = recentOpportunities; }
}
