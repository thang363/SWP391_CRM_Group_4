package dao.impl;

import dao.MarketingDashboardDAO;
import model.viewmodel.MarketingDashboardVM;
import util.DatabaseUtil;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.entity.LeadSubmission;


/**
 * Implementation of MarketingDashboardDAO.
 */
public class MarketingDashboardDAOImpl implements MarketingDashboardDAO {

    private final DatabaseUtil dbUtil;

    public MarketingDashboardDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public MarketingDashboardVM getDashboardStats(Integer managerId) {
        MarketingDashboardVM vm = new MarketingDashboardVM();
        try (Connection conn = dbUtil.getConnection()) {
            // 1. Campaign Stats (Active)
            String cSql = "SELECT COUNT(*), SUM(CASE WHEN status='Active' THEN 1 ELSE 0 END) FROM Campaigns WHERE manager_id=?";
            try (PreparedStatement ps = conn.prepareStatement(cSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        vm.setPersonalTotalCampaigns(rs.getInt(1));
                        vm.setPersonalActiveCampaigns(rs.getInt(2));
                    }
                }
            }

            // 2. Lead Stats (Total, Hot, Unassigned Hot)
            String lSql = "SELECT COUNT(l.id), " +
                         "SUM(CASE WHEN l.potential_status='Hot' THEN 1 ELSE 0 END), " +
                         "SUM(CASE WHEN l.assigned_to IS NULL AND l.potential_status='Hot' THEN 1 ELSE 0 END) " +
                         "FROM Leads l JOIN Campaigns c ON l.campaign_id = c.id WHERE c.manager_id=?";
            try (PreparedStatement ps = conn.prepareStatement(lSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        vm.setTotalLeads(rs.getInt(1));
                        vm.setHotLeads(rs.getInt(2));
                        vm.setUnassignedHotLeads(rs.getInt(3));
                    }
                }
            }

            // 3. Opportunity Stats
            String oSql = "SELECT COUNT(DISTINCT o.lead_id) FROM Opportunities o " +
                         "JOIN Leads l ON o.lead_id = l.id JOIN Campaigns c ON l.campaign_id = c.id WHERE c.manager_id=?";
            try (PreparedStatement ps = conn.prepareStatement(oSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setTotalOpportunities(rs.getInt(1));
                }
            }

            // 4. Customer Stats
            String cuSql = "SELECT COUNT(DISTINCT cu.lead_id) FROM Customers cu " +
                          "JOIN Leads l ON cu.lead_id = l.id JOIN Campaigns c ON l.campaign_id = c.id WHERE c.manager_id=?";
            try (PreparedStatement ps = conn.prepareStatement(cuSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setTotalCustomers(rs.getInt(1));
                }
            }

            // 5. Marketing Specific: Landing Pages
            String lpSql = "SELECT COUNT(*) FROM LandingPages WHERE created_by=? AND status='Public'";
            try (PreparedStatement ps = conn.prepareStatement(lpSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setApprovedLandingPages(rs.getInt(1));
                }
            }

            // 6. Marketing Specific: Submissions Today
            String subTodaySql = "SELECT COUNT(*) FROM LeadSubmissions ls " +
                    "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE (lp.created_by = ? OR c.manager_id = ?) AND CAST(ls.submitted_at AS DATE) = CAST(GETDATE() AS DATE)";
            try (PreparedStatement ps = conn.prepareStatement(subTodaySql)) {
                ps.setInt(1, managerId);
                ps.setInt(2, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setSubmissionsToday(rs.getInt(1));
                }
            }

            // 7. Marketing Specific: Pending Submissions
            String pendSubSql = "SELECT COUNT(*) FROM LeadSubmissions ls " +
                    "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE (lp.created_by = ? OR c.manager_id = ?) AND ls.is_processed = 0";
            try (PreparedStatement ps = conn.prepareStatement(pendSubSql)) {
                ps.setInt(1, managerId);
                ps.setInt(2, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setPendingSubmissions(rs.getInt(1));
                }
            }

            // 8. Financial: Total Budget (Manager's campaigns)
            String budgetSql = "SELECT SUM(budget) FROM Campaigns WHERE manager_id=?";
            try (PreparedStatement ps = conn.prepareStatement(budgetSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setTotalBudget(rs.getDouble(1));
                }
            }

            // 9. Financial: Pipeline Value (Expected Value from Opportunities)
            String pipelineSql = "SELECT SUM(o.expected_value) FROM Opportunities o " +
                                "JOIN Leads l ON o.lead_id = l.id " +
                                "JOIN Campaigns c ON l.campaign_id = c.id WHERE c.manager_id=?";
            try (PreparedStatement ps = conn.prepareStatement(pipelineSql)) {
                ps.setInt(1, managerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) vm.setPersonalPipelineValue(rs.getDouble(1));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vm;
    }
}
