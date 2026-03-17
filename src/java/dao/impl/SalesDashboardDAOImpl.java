package dao.impl;

import dao.SalesDashboardDAO;
import model.viewmodel.SalesDashboardVM;
import util.DatabaseUtil;

import java.sql.*;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

public class SalesDashboardDAOImpl implements SalesDashboardDAO {

    private final DatabaseUtil dbUtil;

    public SalesDashboardDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public SalesDashboardVM getSalesDashboardStats(int salesId) {
        return getStats(salesId);
    }

    @Override
    public SalesDashboardVM getGlobalSalesDashboardStats() {
        return getStats(null);
    }

    private SalesDashboardVM getStats(Integer salesId) {
        SalesDashboardVM vm = new SalesDashboardVM();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();

            // 1. Revenue Today
            String revenueTodaySql = "SELECT SUM(q.grand_total) FROM Quotes q " +
                    "JOIN Opportunities o ON q.opportunity_id = o.id " +
                    "WHERE q.status = 'Accepted' AND CAST(q.created_at AS DATE) = CAST(GETDATE() AS DATE)" +
                    (salesId != null ? " AND o.sales_id = ?" : "");
            stmt = conn.prepareStatement(revenueTodaySql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal val = rs.getBigDecimal(1);
                vm.setRevenueToday(val != null ? val : BigDecimal.ZERO);
            }
            rs.close();
            stmt.close();

            // 2. Total Revenue
            String totalRevenueSql = "SELECT SUM(q.grand_total) FROM Quotes q " +
                    "JOIN Opportunities o ON q.opportunity_id = o.id " +
                    "WHERE q.status = 'Accepted'" +
                    (salesId != null ? " AND o.sales_id = ?" : "");
            stmt = conn.prepareStatement(totalRevenueSql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal val = rs.getBigDecimal(1);
                vm.setTotalRevenue(val != null ? val : BigDecimal.ZERO);
            }
            rs.close();
            stmt.close();

            // 3. New Customers Count (This Month)
            String newCustomersSql = "SELECT COUNT(*) FROM Customers " +
                    "WHERE MONTH(created_at) = MONTH(GETDATE()) AND YEAR(created_at) = YEAR(GETDATE())" +
                    (salesId != null ? " AND assigned_to = ?" : "");
            stmt = conn.prepareStatement(newCustomersSql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setNewCustomersCount(rs.getInt(1));
            rs.close();
            stmt.close();

            // 4. Open Deals Count
            String openDealsSql = "SELECT COUNT(*) FROM Opportunities " +
                    "WHERE stage NOT IN ('Won', 'Lost')" +
                    (salesId != null ? " AND sales_id = ?" : "");
            stmt = conn.prepareStatement(openDealsSql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setOpenDealsCount(rs.getInt(1));
            rs.close();
            stmt.close();

            // 5. Monthly Sales (Last 6 months)
            Map<String, BigDecimal> monthlySales = new LinkedHashMap<>();
            String monthlySql = "SELECT FORMAT(q.created_at, 'MMM') as month_name, SUM(q.grand_total) as total " +
                    "FROM Quotes q JOIN Opportunities o ON q.opportunity_id = o.id " +
                    "WHERE q.status = 'Accepted'" +
                    (salesId != null ? " AND o.sales_id = ?" : "") +
                    " GROUP BY FORMAT(q.created_at, 'MMM'), MONTH(q.created_at) " +
                    "ORDER BY MONTH(q.created_at)";
            stmt = conn.prepareStatement(monthlySql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                monthlySales.put(rs.getString("month_name"), rs.getBigDecimal("total"));
            }
            vm.setMonthlySales(monthlySales);
            rs.close();
            stmt.close();

            // 6. Leads by Source
            Map<String, Integer> leadsBySource = new LinkedHashMap<>();
            String sourceSql = "SELECT ls.name, COUNT(*) as count " +
                    "FROM Leads l JOIN LeadSources ls ON l.source_id = ls.id " +
                    (salesId != null ? " WHERE l.assigned_to = ?" : "") +
                    " GROUP BY ls.name";
            stmt = conn.prepareStatement(sourceSql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                leadsBySource.put(rs.getString("name"), rs.getInt("count"));
            }
            vm.setLeadsBySource(leadsBySource);
            rs.close();
            stmt.close();

            // 7. Recent Opportunities
            java.util.List<model.entity.Opportunity> recentOps = new java.util.ArrayList<>();
            String recentOpsSql = "SELECT TOP 5 * FROM Opportunities " +
                    (salesId != null ? " WHERE sales_id = ?" : "") +
                    " ORDER BY created_at DESC";
            stmt = conn.prepareStatement(recentOpsSql);
            if (salesId != null) stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                model.entity.Opportunity op = new model.entity.Opportunity();
                op.setId(rs.getInt("id"));
                op.setName(rs.getString("name"));
                op.setStage(rs.getString("stage"));
                op.setExpectedValue(rs.getBigDecimal("expected_value"));
                op.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                recentOps.add(op);
            }
            vm.setRecentOpportunities(recentOps);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) dbUtil.closeConnection(conn);
        }

        return vm;
    }
}
