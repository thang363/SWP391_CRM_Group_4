package dao.impl;

import dao.LeadDAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.Campaign;
import model.entity.Lead;
import util.DatabaseUtil;

/**
 * Implementation of LeadDAO.
 */
public class LeadDAOImpl implements LeadDAO {

    private final DatabaseUtil dbUtil;

    public LeadDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }
    //AND is_converted = 0
    @Override
    public List<Lead> findBySaleId(int saleId) {
        String sql = "SELECT * FROM Leads WHERE assigned_to = ? ";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, saleId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Lead lead = mapResultSetToLead(rs);
                if (rs.getString("campaign_name") != null) {
                    Campaign campaign = new Campaign();
                    campaign.setId(lead.getCampaignId());
                    campaign.setName(rs.getString("campaign_name"));
                    lead.setCampaign(campaign);
                }
                list.add(lead);
            }
        } catch (SQLException e) {
            System.err.println("Error finding leads by sale ID: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public void updateLeadStatus(int leadId, String status) {
        String sql = "UPDATE Leads SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = dbUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, leadId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    @Override
    public void markAsConverted(int leadId) {
        String sql = "UPDATE Leads SET is_converted = 1 WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = dbUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, leadId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    @Override
    public boolean checkDuplicate(String email, String phone, Integer campaignId) {
        if ((email == null || email.isEmpty()) && (phone == null || phone.isEmpty())) {
            return false;
        }

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Leads WHERE (1=0");
        List<Object> params = new ArrayList<>();

        if (email != null && !email.isEmpty()) {
            sql.append(" OR email = ?");
            params.add(email);
        }
        if (phone != null && !phone.isEmpty()) {
            sql.append(" OR phone = ?");
            params.add(phone);
        }
        sql.append(")");

        if (campaignId != null) {
            sql.append(" AND campaign_id = ?");
            params.add(campaignId);
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking duplicate lead: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return false;
    }

    @Override
    public boolean insert(Lead lead) {
        // Note: Assuming 'Leads' table has columns: 
        // full_name, email, phone, campaign_id, source_id, status, is_converted, created_at, potential_status
        String sql = "INSERT INTO Leads (full_name, email, phone, campaign_id, source_id, status, is_converted, created_at, potential_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, lead.getFullName());
            stmt.setString(2, lead.getEmail());
            stmt.setString(3, lead.getPhone());

            if (lead.getCampaignId() != null) {
                stmt.setInt(4, lead.getCampaignId());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }

            if (lead.getSourceId() != null) {
                stmt.setInt(5, lead.getSourceId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            stmt.setString(6, lead.getStatus() != null ? lead.getStatus() : "New");
            stmt.setBoolean(7, lead.getIsConverted() != null ? lead.getIsConverted() : false);

            // created_at default getdate() in DB, but we can set it if needed. 
            // Lead entity uses LocalDateTime.
            if (lead.getCreatedAt() != null) {
                stmt.setTimestamp(8, Timestamp.valueOf(lead.getCreatedAt()));
            } else {
                stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            }

            stmt.setString(9, lead.getPotentialStatus() != null ? lead.getPotentialStatus() : "Cool");

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        lead.setId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;

        } catch (SQLException e) {
            System.err.println("Error inserting lead: " + e.getMessage());
            e.printStackTrace(); 
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public Lead findById(int id) {
        String sql = "SELECT * FROM Leads WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToLead(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error finding lead by ID: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public List<Lead> findByCampaignIdWithEmail(int campaignId) {
        String sql = "SELECT l.*, c.name as campaign_name FROM Leads l LEFT JOIN Campaigns c ON l.campaign_id = c.id WHERE l.campaign_id = ? AND l.email IS NOT NULL AND l.email != '' ORDER BY l.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Lead lead = mapResultSetToLead(rs);
                if (rs.getString("campaign_name") != null) {
                    Campaign campaign = new Campaign();
                    campaign.setId(lead.getCampaignId());
                    campaign.setName(rs.getString("campaign_name"));
                    lead.setCampaign(campaign);
                }
                list.add(lead);
            }
        } catch (SQLException e) {
            System.err.println("Error finding leads by campaign ID with email: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public List<Lead> findAllWithEmail() {
        String sql = "SELECT l.*, c.name as campaign_name FROM Leads l LEFT JOIN Campaigns c ON l.campaign_id = c.id WHERE l.email IS NOT NULL AND l.email != '' ORDER BY l.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Lead lead = mapResultSetToLead(rs);
                if (rs.getString("campaign_name") != null) {
                    Campaign campaign = new Campaign();
                    campaign.setId(lead.getCampaignId());
                    campaign.setName(rs.getString("campaign_name"));
                    lead.setCampaign(campaign);
                }
                list.add(lead);
            }
        } catch (SQLException e) {
            System.err.println("Error finding all leads with email: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }


    private Lead mapResultSetToLead(ResultSet rs) throws SQLException {
        Lead lead = new Lead();
        lead.setId(rs.getInt("id"));
        lead.setFullName(rs.getString("full_name"));
        lead.setEmail(rs.getString("email"));
        lead.setPhone(rs.getString("phone"));
        lead.setStatus(rs.getString("status"));
        lead.setPotentialStatus(rs.getString("potential_status"));
        lead.setIsConverted(rs.getBoolean("is_converted"));

        // Handling potential null for campaign/source if they exist
        try {
            int cId = rs.getInt("campaign_id");
            if (!rs.wasNull()) {
                lead.setCampaignId(cId);
            }

            int sId = rs.getInt("source_id");
            if (!rs.wasNull()) {
                lead.setSourceId(sId);
            }

            int aId = rs.getInt("assigned_to");
            if (!rs.wasNull()) {
                lead.setAssignedTo(aId);
            }
        } catch (SQLException ignored) {
            // Columns might not exist in old schema, ignore or handle
        }

        Timestamp ts = rs.getTimestamp("created_at");
        lead.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return lead;
    }

    @Override
    public void updateLeadInfo(int id, String name, String phone) {
        String sql = "UPDATE Leads SET full_name = ?, phone = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = dbUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    @Override
    public List<Lead> searchLeads(int saleId, String query, String status) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Leads WHERE assigned_to = ?");
        List<Object> params = new ArrayList<>();
        params.add(saleId);

        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String pattern = "%" + query.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY created_at DESC");

        List<Lead> list = new ArrayList<>();
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = (conn != null) ? conn.prepareStatement(sql.toString()) : null) {
            
            if (stmt == null) return list;
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    
                list.add(mapResultSetToLead(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching leads: " + e.getMessage());
        }
        return list;
    }




    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
        }
        try {
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException e) {
        }
        dbUtil.closeConnection(conn);
    }
    
    @Override
    public model.viewmodel.MonitorKPIsViewModel getMonitorKPIs(Integer campaignId) {
        model.viewmodel.MonitorKPIsViewModel kpi = new model.viewmodel.MonitorKPIsViewModel(0, 0);
        String sql = "SELECT " +
                     "SUM(CASE WHEN potential_status = 'Hot' THEN 1 ELSE 0 END) as hot_leads, " +
                     "SUM(CASE WHEN assigned_to IS NULL AND potential_status = 'Hot' THEN 1 ELSE 0 END) as unassigned_leads " +
                     "FROM Leads";
        if (campaignId != null) {
            sql += " WHERE campaign_id = ?";
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            if (campaignId != null) {
                stmt.setInt(1, campaignId);
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                kpi.setHotLeads(rs.getInt("hot_leads"));
                kpi.setUnassignedLeads(rs.getInt("unassigned_leads"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting monitor KPIs: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return kpi;
    }

    @Override
    public List<Lead> getHotUnassignedLeads(Integer campaignId, String searchQuery, String dateFilter, int limit) {
        List<Lead> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT l.*, c.name as campaign_name FROM Leads l " +
            "LEFT JOIN Campaigns c ON l.campaign_id = c.id " +
            "WHERE l.assigned_to IS NULL AND l.status = 'New' AND l.potential_status = 'Hot'"
        );
        
        if (campaignId != null) {
            sql.append(" AND l.campaign_id = ?");
        }
        
        boolean hasSearch = (searchQuery != null && !searchQuery.trim().isEmpty());
        if (hasSearch) {
            sql.append(" AND (l.full_name LIKE ? OR l.email LIKE ? OR l.phone LIKE ?)");
        }
        
        if (dateFilter != null && !dateFilter.isEmpty() && !dateFilter.equals("all")) {
            switch (dateFilter) {
                case "today":
                    sql.append(" AND CAST(l.created_at AS DATE) = CAST(GETDATE() AS DATE)");
                    break;
                case "this_week":
                    sql.append(" AND l.created_at >= DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 0)");
                    break;
                case "this_month":
                    sql.append(" AND l.created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)");
                    break;
            }
        }
        
        sql.append(" ORDER BY l.created_at DESC");
        
        String finalSql = sql.toString();
        if (limit > 0) {
            finalSql = finalSql.replaceFirst("SELECT l\\.\\*", "SELECT TOP " + limit + " l.*");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(finalSql);
            
            int paramIndex = 1;
            if (campaignId != null) {
                stmt.setInt(paramIndex++, campaignId);
            }
            if (hasSearch) {
                String likeQuery = "%" + searchQuery.trim() + "%";
                stmt.setString(paramIndex++, likeQuery);
                stmt.setString(paramIndex++, likeQuery);
                stmt.setString(paramIndex++, likeQuery);
            }
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                Lead lead = mapResultSetToLead(rs);
                if (rs.getString("campaign_name") != null) {
                    Campaign campaign = new Campaign();
                    campaign.setId(lead.getCampaignId());
                    campaign.setName(rs.getString("campaign_name"));
                    lead.setCampaign(campaign);
                }
                list.add(lead);
            }
        } catch (SQLException e) {
            System.err.println("Error getting hot unassigned leads: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public List<model.viewmodel.LeadInteractionViewModel> getRecentInteractions(Integer campaignId, int limit) {
        List<model.viewmodel.LeadInteractionViewModel> list = new ArrayList<>();
        String sql = "SELECT i.id, i.lead_id, l.full_name, l.email, a.name as activity_name, i.reference_url, i.created_at " +
                     "FROM LeadInteractions i " +
                     "JOIN Leads l ON i.lead_id = l.id " +
                     "JOIN ActivityTypes a ON i.activity_type_id = a.id";
        
        if (campaignId != null) {
            sql += " WHERE i.campaign_id = ?";
        }
        sql += " ORDER BY i.created_at DESC";
        
        if (limit > 0) {
            sql = sql.replaceFirst("SELECT i.id", "SELECT TOP " + limit + " i.id");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            if (campaignId != null) {
                stmt.setInt(1, campaignId);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                model.viewmodel.LeadInteractionViewModel vm = new model.viewmodel.LeadInteractionViewModel();
                vm.setInteractionId(rs.getInt("id"));
                vm.setLeadId(rs.getInt("lead_id"));
                vm.setLeadName(rs.getString("full_name"));
                vm.setLeadEmail(rs.getString("email"));
                vm.setActivityName(rs.getString("activity_name"));
                vm.setDetails(rs.getString("reference_url")); // reference_url acts as details
                Timestamp ts = rs.getTimestamp("created_at");
                vm.setCreatedAt(ts);
                list.add(vm);
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent interactions: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public boolean assignLeadToSales(int leadId, int salesId, int managerId) {
        Connection conn = null;
        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false);

            // Kiểm tra xem Lead đã là Customer chưa
            String leadEmail = null;
            String leadName = null;
            String sqlGetLead = "SELECT email, full_name FROM Leads WHERE id = ?";
            try (PreparedStatement psGet = conn.prepareStatement(sqlGetLead)) {
                psGet.setInt(1, leadId);
                try (ResultSet rsGet = psGet.executeQuery()) {
                    if (rsGet.next()) {
                        leadEmail = rsGet.getString("email");
                        leadName = rsGet.getString("full_name");
                    }
                }
            }

            Integer existingCustomerId = null;
            if (leadEmail != null && !leadEmail.trim().isEmpty()) {
                String sqlGetCustomer = "SELECT id FROM Customers WHERE email = ?";
                try (PreparedStatement psCus = conn.prepareStatement(sqlGetCustomer)) {
                    psCus.setString(1, leadEmail.trim());
                    try (ResultSet rsCus = psCus.executeQuery()) {
                        if (rsCus.next()) {
                            existingCustomerId = rsCus.getInt("id");
                        }
                    }
                }
            }

            if (existingCustomerId != null) {
                // Đã là Customer -> Tạo Opportunity
                String sqlOpp = "INSERT INTO Opportunities (lead_id, customer_id, name, stage, expected_value, sales_id, created_at) VALUES (?, ?, ?, 'Prospecting', 0, ?, GETDATE())";
                try (PreparedStatement psOpp = conn.prepareStatement(sqlOpp)) {
                    psOpp.setInt(1, leadId);
                    psOpp.setInt(2, existingCustomerId);
                    psOpp.setString(3, "Opportunity - " + leadName);
                    psOpp.setInt(4, salesId);
                    psOpp.executeUpdate();
                }

                // Update Lead -> Assigned & Converted
                String sqlUpdateLeadC = "UPDATE Leads SET assigned_to = ?, status = 'Assigned', is_converted = 0 WHERE id = ? AND assigned_to IS NULL";
                int affectedC = 0;
                try (PreparedStatement psUpdC = conn.prepareStatement(sqlUpdateLeadC)) {
                    psUpdC.setInt(1, salesId);
                    psUpdC.setInt(2, leadId);
                    affectedC = psUpdC.executeUpdate();
                }

                if (affectedC == 0) {
                    conn.rollback();
                    return false;
                }

                // Insert Assignments
                String sqlInsertC = "INSERT INTO LeadAssignments (lead_id, manager_id, sales_id, assigned_at) VALUES (?, ?, ?, GETDATE())";
                try (PreparedStatement psInsertC = conn.prepareStatement(sqlInsertC)) {
                    psInsertC.setInt(1, leadId);
                    psInsertC.setInt(2, managerId);
                    psInsertC.setInt(3, salesId);
                    psInsertC.executeUpdate();
                }

                conn.commit();
                return true;
            }

            // 1. Update Leads table (luồng bình thường cho Lead mới)
            String sqlUpdate = "UPDATE Leads SET assigned_to = ?, status = 'Assigned' WHERE id = ? AND assigned_to IS NULL";
            int affected = 0;
            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                psUpdate.setInt(1, salesId);
                psUpdate.setInt(2, leadId);
                affected = psUpdate.executeUpdate();
            }

            // Prevent assigning if already assigned concurrently
            if (affected == 0) {
                conn.rollback();
                return false; 
            }

            // 2. Insert into LeadAssignments table
            String sqlInsert = "INSERT INTO LeadAssignments (lead_id, manager_id, sales_id, assigned_at) VALUES (?, ?, ?, GETDATE())";
            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                psInsert.setInt(1, leadId);
                psInsert.setInt(2, managerId);
                psInsert.setInt(3, salesId);
                psInsert.executeUpdate();
            }
            
            // 3. Optional Insert status history
            String sqlHistory = "INSERT INTO LeadStatusHistory (lead_id, old_status, new_status, changed_by, changed_at) VALUES (?, 'New', 'Assigned', ?, GETDATE())";
            try (PreparedStatement psHist = conn.prepareStatement(sqlHistory)) {
                psHist.setInt(1, leadId);
                psHist.setInt(2, managerId);
                psHist.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("Error assigning lead: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                }
            }
            closeResources(null, null, conn);
        }
    }

    @Override
    public boolean delete(int leadId) {
        Connection conn = null;
        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Delete from LeadInteractions
            String sqlInteractions = "DELETE FROM LeadInteractions WHERE lead_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlInteractions)) {
                ps.setInt(1, leadId);
                ps.executeUpdate();
            }

            // 2. Delete from LeadStatusHistory 
            String sqlHistory = "DELETE FROM LeadStatusHistory WHERE lead_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlHistory)) {
                ps.setInt(1, leadId);
                ps.executeUpdate();
            }

            // 3. Delete from Leads - only if NOT assigned
            String sqlLead = "DELETE FROM Leads WHERE id = ? AND assigned_to IS NULL";
            int affected = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlLead)) {
                ps.setInt(1, leadId);
                affected = ps.executeUpdate();
            }

            if (affected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            System.err.println("Error deleting lead: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                }
            }
            closeResources(null, null, conn);
        }
    }
}

