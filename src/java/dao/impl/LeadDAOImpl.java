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

    @Override
    public List<Lead> findBySaleId(long saleId) {
        String sql = "SELECT * FROM Leads WHERE assigned_to = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, saleId);
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
    public boolean checkDuplicate(String email, String phone) {
        if ((email == null || email.isEmpty()) && (phone == null || phone.isEmpty())) {
            return false;
        }

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Leads WHERE 1=0");
        List<Object> params = new ArrayList<>();

        if (email != null && !email.isEmpty()) {
            sql.append(" OR email = ?");
            params.add(email);
        }
        if (phone != null && !phone.isEmpty()) {
            sql.append(" OR phone = ?");
            params.add(phone);
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
        String sql = "INSERT INTO Leads (full_name, email, phone, campaign_id, source_id, status, is_converted, created_at, current_score) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, lead.getFullName());
            stmt.setString(2, lead.getEmail());
            stmt.setString(3, lead.getPhone());
            
            if (lead.getCampaignId() != null) stmt.setLong(4, lead.getCampaignId());
            else stmt.setNull(4, Types.INTEGER);
            
            if (lead.getSourceId() != null) stmt.setLong(5, lead.getSourceId());
            else stmt.setNull(5, Types.INTEGER);
            
            stmt.setString(6, lead.getStatus() != null ? lead.getStatus() : "New");
            stmt.setBoolean(7, lead.getIsConverted() != null ? lead.getIsConverted() : false);
            
            // created_at default getdate() in DB, but we can set it if needed. 
            // Lead entity uses LocalDateTime.
            if (lead.getCreatedAt() != null) stmt.setTimestamp(8, Timestamp.valueOf(lead.getCreatedAt()));
            else stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));

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
    public Lead findById(long id) {
        String sql = "SELECT * FROM Leads WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, id);
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
    public List<Lead> findByCampaignIdWithEmail(long campaignId) {
        String sql = "SELECT * FROM Leads WHERE campaign_id = ? AND email IS NOT NULL AND email != '' ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, campaignId);
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
        lead.setId(rs.getLong("id"));
        lead.setFullName(rs.getString("full_name"));
        lead.setEmail(rs.getString("email"));
        lead.setPhone(rs.getString("phone"));
        lead.setStatus(rs.getString("status"));
        lead.setCurrentScore(rs.getInt("current_score"));
        lead.setIsConverted(rs.getBoolean("is_converted"));
        
        // Handling potential null for campaign/source if they exist
        try {
            long cId = rs.getLong("campaign_id");
            if (!rs.wasNull()) lead.setCampaignId(cId);
            
            long sId = rs.getLong("source_id");
            if (!rs.wasNull()) lead.setSourceId(sId);
            
            long aId = rs.getLong("assigned_to");
            if (!rs.wasNull()) lead.setAssignedTo(aId);
        } catch (SQLException ignored) {
            // Columns might not exist in old schema, ignore or handle
        }

        Timestamp ts = rs.getTimestamp("created_at");
        lead.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return lead;
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        dbUtil.closeConnection(conn);
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
    }
}
