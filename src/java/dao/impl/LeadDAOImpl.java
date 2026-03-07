package dao.impl;

import dao.LeadDAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
                list.add(mapResultSetToLead(rs));
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
        // full_name, email, phone, campaign_id, source_id, status, is_converted, created_at, current_score
        String sql = "INSERT INTO Leads (full_name, email, phone, campaign_id, source_id, status, is_converted, created_at, current_score) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);

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

            stmt.setInt(9, lead.getCurrentScore() != null ? lead.getCurrentScore() : 0);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error inserting lead: " + e.getMessage());
            e.printStackTrace(); // For debugging schema mismatches
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
        String sql = "SELECT * FROM Leads WHERE campaign_id = ? AND email IS NOT NULL AND email != '' ORDER BY created_at DESC";
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
                list.add(mapResultSetToLead(rs));
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
        String sql = "SELECT * FROM Leads WHERE email IS NOT NULL AND email != '' ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToLead(rs));
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
        lead.setCurrentScore(rs.getInt("current_score"));
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

    @Override
    public boolean recordInteraction(int leadId, Integer campaignId, String activityType, String details, int scoreChange) {
        Connection conn = null;
        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Get or Create activity_type_id
            int activityTypeId = ensureActivityType(conn, activityType);
            
            // 2. Fallback for campaignId if null
            if (campaignId == null) {
                String sqlCampaign = "SELECT campaign_id FROM Leads WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlCampaign)) {
                    ps.setInt(1, leadId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            int cid = rs.getInt("campaign_id");
                            if (!rs.wasNull()) campaignId = cid;
                        }
                    }
                }
            }

            // 3. Check if points were already awarded for this lead/campaign/activityType
            boolean alreadyScored = false;
            String sqlCheck = "SELECT COUNT(*) FROM LeadInteractions " +
                             "WHERE lead_id = ? AND activity_type_id = ? AND score_change > 0 AND reference_url = ?";
            if (campaignId != null) sqlCheck += " AND campaign_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, leadId);
                ps.setInt(2, activityTypeId);
                ps.setString(3, details);
                if (campaignId != null) ps.setInt(4, campaignId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        alreadyScored = true;
                    }
                }
            }
            
            // If already scored, we exit early to avoid duplicate data in LeadInteractions
            if (alreadyScored) {
                conn.commit(); // Just in case, though we only did reads
                return true;
            }

            // 4. Insert into LeadInteractions
            String sqlInteraction = "INSERT INTO LeadInteractions (lead_id, campaign_id, activity_type_id, reference_url, score_change, created_at) " +
                                  "VALUES (?, ?, ?, ?, ?, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(sqlInteraction)) {
                ps.setInt(1, leadId);
                if (campaignId != null) ps.setInt(2, campaignId); else ps.setNull(2, Types.INTEGER);
                ps.setInt(3, activityTypeId);
                ps.setString(4, details);
                ps.setInt(5, scoreChange);
                ps.executeUpdate();
            }

            // 5. Only update history and total score if there's a real change
            if (scoreChange != 0) {
                // Insert into LeadScoreHistory
                String sqlHistory = "INSERT INTO LeadScoreHistory (lead_id, score_change, total_score, created_at) " +
                                   "VALUES (?, ?, (SELECT current_score + ? FROM Leads WHERE id = ?), GETDATE())";
                try (PreparedStatement ps = conn.prepareStatement(sqlHistory)) {
                    ps.setInt(1, leadId);
                    ps.setInt(2, scoreChange);
                    ps.setInt(3, scoreChange);
                    ps.setInt(4, leadId);
                    ps.executeUpdate();
                }

                // Update Leads.current_score
                String sqlUpdateLead = "UPDATE Leads SET current_score = current_score + ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdateLead)) {
                    ps.setInt(1, scoreChange);
                    ps.setInt(2, leadId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("Error recording interaction: " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ex) {}
                dbUtil.closeConnection(conn);
            }
        }
    }

    private int ensureActivityType(Connection conn, String name) throws SQLException {
        String sqlSelect = "SELECT id FROM ActivityTypes WHERE name = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }
        
        String sqlInsert = "INSERT INTO ActivityTypes (name, description, is_active) VALUES (?, ?, 1)";
        try (PreparedStatement ps = conn.prepareStatement(sqlInsert, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, "Automatic tracking type");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public void updateScore(int leadId, int newScore) {
        String sql = "UPDATE Leads SET current_score = ? WHERE id = ?";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newScore);
            ps.setInt(2, leadId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating lead score: " + e.getMessage());
        }
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
        model.viewmodel.MonitorKPIsViewModel kpi = new model.viewmodel.MonitorKPIsViewModel(0, 0, 0, 0.0);
        String sql = "SELECT COUNT(*) as total_leads, " +
                     "SUM(CASE WHEN current_score >= 50 THEN 1 ELSE 0 END) as hot_leads, " +
                     "SUM(CASE WHEN assigned_to IS NULL THEN 1 ELSE 0 END) as unassigned_leads, " +
                     "AVG(CAST(current_score AS FLOAT)) as avg_score " +
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
                kpi.setTotalLeads(rs.getInt("total_leads"));
                kpi.setHotLeads(rs.getInt("hot_leads"));
                kpi.setUnassignedLeads(rs.getInt("unassigned_leads"));
                kpi.setAvgScore(rs.getDouble("avg_score"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting monitor KPIs: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return kpi;
    }

    @Override
    public List<Lead> getHotUnassignedLeads(Integer campaignId, int limit) {
        List<Lead> list = new ArrayList<>();
        String sql = "SELECT * FROM Leads WHERE assigned_to IS NULL AND status = 'New'";
        if (campaignId != null) {
            sql += " AND campaign_id = ?";
        }
        sql += " ORDER BY current_score DESC";
        // MS SQL Server uses TOP instead of LIMIT, assuming SQL Server based on previous code.
        // Changing to support top n rows if limit is > 0
        if (limit > 0) {
            sql = sql.replaceFirst("SELECT \\*", "SELECT TOP " + limit + " *"); // Basic handling for TOP
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
                list.add(mapResultSetToLead(rs));
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
        String sql = "SELECT i.id, i.lead_id, l.full_name, l.email, a.name as activity_name, i.reference_url, i.score_change, i.created_at " +
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
                vm.setScoreChange(rs.getInt("score_change"));
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

            // 1. Update Leads table
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
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ex) {}
                dbUtil.closeConnection(conn);
            }
        }
    }
}
