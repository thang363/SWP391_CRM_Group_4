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
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();

            // 1. Global Total Campaigns
            String globalSql = "SELECT COUNT(*) FROM Campaigns";
            stmt = conn.prepareStatement(globalSql);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setGlobalTotalCampaigns(rs.getInt(1));
            rs.close();
            stmt.close();

            // 2. Personal Campaign Stats
            String personalSql = "SELECT " +
                    "COUNT(*) as total, " +
                    "SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active, " +
                    "SUM(CASE WHEN status = 'Paused' THEN 1 ELSE 0 END) as paused, " +
                    "SUM(CASE WHEN status = 'Finished' THEN 1 ELSE 0 END) as finished, " +
                    "SUM(CASE WHEN status = 'Draft' THEN 1 ELSE 0 END) as draft, " +
                    "SUM(budget) as budget " +
                    "FROM Campaigns WHERE manager_id = ?";
            stmt = conn.prepareStatement(personalSql);
            stmt.setInt(1, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                vm.setPersonalTotalCampaigns(rs.getInt("total"));
                vm.setPersonalActiveCampaigns(rs.getInt("active"));
                vm.setPersonalPausedCampaigns(rs.getInt("paused"));
                vm.setPersonalFinishedCampaigns(rs.getInt("finished"));
                vm.setPersonalDraftCampaigns(rs.getInt("draft"));
                BigDecimal budget = rs.getBigDecimal("budget");
                vm.setTotalBudget(budget != null ? budget : BigDecimal.ZERO);
            }
            rs.close();
            stmt.close();

            // 3. Landing Page Stats
            String lpSql = "SELECT " +
                    "SUM(CASE WHEN lp.status IN ('Draft', 'Pending') THEN 1 ELSE 0 END) as pending, " +
                    "SUM(CASE WHEN lp.status = 'Public' THEN 1 ELSE 0 END) as approved " +
                    "FROM LandingPages lp " +
                    "LEFT JOIN Campaigns c ON lp.campaign_id = c.id " +
                    "WHERE lp.created_by = ? OR c.manager_id = ?";
            stmt = conn.prepareStatement(lpSql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                vm.setPendingLandingPages(rs.getInt("pending"));
                vm.setApprovedLandingPages(rs.getInt("approved"));
            }
            rs.close();
            stmt.close();

            // 4. Lead & Conversion Stats
            String leadSql = "SELECT " +
                    "COUNT(l.id) as totalLeads, " +
                    "SUM(CASE WHEN l.potential_status = 'Hot' THEN 1 ELSE 0 END) as hotLeads, " +
                    "SUM(CASE WHEN l.assigned_to IS NOT NULL THEN 1 ELSE 0 END) as assignedLeads " +
                    "FROM Leads l " +
                    "LEFT JOIN Campaigns c ON l.campaign_id = c.id " +
                    "LEFT JOIN LeadSubmissions ls ON l.source_id = ls.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE c.manager_id = ? OR lp.created_by = ?";
            stmt = conn.prepareStatement(leadSql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                vm.setTotalLeads(rs.getInt("totalLeads"));
                vm.setHotLeads(rs.getInt("hotLeads"));
                vm.setAssignedLeads(rs.getInt("assignedLeads"));
            }
            rs.close();
            stmt.close();

            // 5. Opportunity Stats
            String oppSql = "SELECT COUNT(DISTINCT o.lead_id) " +
                    "FROM Opportunities o " +
                    "INNER JOIN Leads l ON o.lead_id = l.id " +
                    "LEFT JOIN Campaigns c ON l.campaign_id = c.id " +
                    "LEFT JOIN LeadSubmissions ls ON l.source_id = ls.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE c.manager_id = ? OR lp.created_by = ?";
            stmt = conn.prepareStatement(oppSql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setTotalOpportunities(rs.getInt(1));
            rs.close();
            stmt.close();

            // 6. Customer Stats
            String custSql = "SELECT COUNT(DISTINCT cu.lead_id) " +
                    "FROM Customers cu " +
                    "INNER JOIN Leads l ON cu.lead_id = l.id " +
                    "LEFT JOIN Campaigns c ON l.campaign_id = c.id " +
                    "LEFT JOIN LeadSubmissions ls ON l.source_id = ls.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE c.manager_id = ? OR lp.created_by = ?";
            stmt = conn.prepareStatement(custSql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setTotalCustomers(rs.getInt(1));
            rs.close();
            stmt.close();

            // 7. Submissions Today
            String subTodaySql = "SELECT COUNT(*) FROM LeadSubmissions ls " +
                    "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE (lp.created_by = ? OR c.manager_id = ?) AND CAST(ls.submitted_at AS DATE) = CAST(GETDATE() AS DATE)";
            stmt = conn.prepareStatement(subTodaySql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setSubmissionsToday(rs.getInt(1));
            rs.close();
            stmt.close();

            // 8. Pending Submissions
            String pendingSubSql = "SELECT COUNT(*) FROM LeadSubmissions ls " +
                    "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE (lp.created_by = ? OR c.manager_id = ?) AND ls.is_processed = 0";
            stmt = conn.prepareStatement(pendingSubSql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            if (rs.next()) vm.setPendingSubmissions(rs.getInt(1));
            rs.close();
            stmt.close();

            // 9. Recent Submissions (Unprocessed)
            String recentSubSql = "SELECT TOP 5 ls.*, c.name as campaign_name, lp.name as lp_name " +
                    "FROM LeadSubmissions ls " +
                    "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                    "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                    "WHERE (lp.created_by = ? OR c.manager_id = ?) AND ls.is_processed = 0 " +
                    "ORDER BY ls.submitted_at DESC";
            stmt = conn.prepareStatement(recentSubSql);
            stmt.setInt(1, managerId);
            stmt.setInt(2, managerId);
            rs = stmt.executeQuery();
            java.util.List<model.entity.LeadSubmission> recentList = new java.util.ArrayList<>();
            while (rs.next()) {
                model.entity.LeadSubmission sub = new model.entity.LeadSubmission();
                sub.setId(rs.getInt("id"));
                sub.setFullName(rs.getString("full_name"));
                sub.setEmail(rs.getString("email"));
                sub.setPhone(rs.getString("phone"));
                sub.setCampaignName(rs.getString("campaign_name"));
                sub.setLandingPageName(rs.getString("lp_name"));
                sub.setIsProcessed(rs.getBoolean("is_processed"));
                sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                recentList.add(sub);
            }
            vm.setRecentSubmissions(recentList);

        } catch (SQLException e) {
            System.err.println("Error fetching dashboard stats: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) dbUtil.closeConnection(conn);
        }

        return vm;
    }
}
