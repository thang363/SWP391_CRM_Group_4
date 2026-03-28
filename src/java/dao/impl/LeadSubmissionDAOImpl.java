package dao.impl;

import dao.LeadSubmissionDAO;
import model.entity.LeadSubmission;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of LeadSubmissionDAO interface
 */
public class LeadSubmissionDAOImpl implements LeadSubmissionDAO {
    
    private final DatabaseUtil dbUtil;
    
    public LeadSubmissionDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }
    
    @Override
    public LeadSubmission create(LeadSubmission submission) {
        String sql = "INSERT INTO LeadSubmissions (landing_page_id, campaign_id, source, full_name, email, phone, is_processed, submitted_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setObject(1, submission.getLandingPageId());
            stmt.setInt(2, submission.getCampaignId()); // NOT NULL
            stmt.setString(3, submission.getSource());
            stmt.setString(4, submission.getFullName());
            stmt.setString(5, submission.getEmail());
            stmt.setString(6, submission.getPhone());
            stmt.setBoolean(7, submission.getIsProcessed());
            stmt.setTimestamp(8, submission.getSubmittedAt());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    submission.setId(rs.getInt(1));
                    return submission;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }
    
    @Override
    public LeadSubmission findById(Integer id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT s.*, c.name as campaign_name, lp.name as landing_page_name " +
                         "FROM LeadSubmissions s " +
                         "LEFT JOIN Campaigns c ON s.campaign_id = c.id " +
                         "LEFT JOIN LandingPages lp ON s.landing_page_id = lp.id " +
                         "WHERE s.id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSubmission(rs);
            }
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error finding lead submission by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public List<LeadSubmission> findByLandingPageId(Integer landingPageId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LeadSubmission> submissions = new ArrayList<>();
        
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT * FROM LeadSubmissions WHERE landing_page_id = ? ORDER BY submitted_at DESC";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, landingPageId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                submissions.add(mapResultSetToSubmission(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding submissions by landing page ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return submissions;
    }

    @Override
    public List<LeadSubmission> findAll(Integer marketingId, String keyword, Integer campaignId, String source, String status, Date fromDate, Date toDate, int offset, int limit) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LeadSubmission> submissions = new ArrayList<>();
        
        try {
            conn = dbUtil.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT ls.*, c.name AS campaign_name, lp.name AS landing_page_name " +
                "FROM LeadSubmissions ls " +
                "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                "WHERE 1=1 "
            );

            List<Object> params = new ArrayList<>();
            
            // --- Role-based Filtering ---
            if (marketingId != null) {
                sql.append(" AND (lp.created_by = ? OR c.manager_id = ?) ");
                params.add(marketingId);
                params.add(marketingId);
            }
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("AND (ls.full_name LIKE ? OR ls.email LIKE ? OR ls.phone LIKE ?) ");
                String likeKey = "%" + keyword + "%";
                params.add(likeKey);
                params.add(likeKey);
                params.add(likeKey);
            }
            
            if (campaignId != null && campaignId > 0) {
                sql.append("AND ls.campaign_id = ? "); // Changed from lp.campaign_id to ls.campaign_id
                params.add(campaignId);
            }
            
            if (source != null && !source.isEmpty()) {
                if ("LP".equals(source)) {
                    sql.append("AND ls.landing_page_id IS NOT NULL ");
                } else if ("IMPORT".equals(source)) {
                     sql.append("AND ls.landing_page_id IS NULL ");
                }
            }
            
            if (status != null && !status.isEmpty()) {
                if ("PENDING".equals(status)) {
                    sql.append("AND ls.is_processed = 0 ");
                } else if ("PROCESSED".equals(status)) {
                    sql.append("AND ls.is_processed = 1 ");
                }
            }

             if (fromDate != null) {
                sql.append("AND CAST(ls.submitted_at AS DATE) >= ? ");
                params.add(fromDate);
            }
            
            if (toDate != null) {
                sql.append("AND CAST(ls.submitted_at AS DATE) <= ? ");
                params.add(toDate);
            }
            
            sql.append("ORDER BY ls.submitted_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            params.add(offset);
            params.add(limit);
            
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                submissions.add(mapResultSetToSubmission(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding all submissions: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return submissions;
    }

    @Override
    public int count(Integer marketingId, String keyword, Integer campaignId, String source, String status, Date fromDate, Date toDate) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM LeadSubmissions ls " +
                "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
                "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
                "WHERE 1=1 "
            );
            
            List<Object> params = new ArrayList<>();
            
            // --- Role-based Filtering ---
            if (marketingId != null) {
                sql.append(" AND (lp.created_by = ? OR c.manager_id = ?) ");
                params.add(marketingId);
                params.add(marketingId);
            }

             if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("AND (ls.full_name LIKE ? OR ls.email LIKE ? OR ls.phone LIKE ?) ");
                String likeKey = "%" + keyword + "%";
                params.add(likeKey);
                params.add(likeKey);
                params.add(likeKey);
            }
            
            if (campaignId != null && campaignId > 0) {
                sql.append("AND ls.campaign_id = ? "); // Changed from lp.campaign_id to ls.campaign_id
                params.add(campaignId);
            }
            
            if (source != null && !source.isEmpty()) {
                if ("LP".equals(source)) {
                    sql.append("AND ls.landing_page_id IS NOT NULL ");
                } else if ("IMPORT".equals(source)) {
                     sql.append("AND ls.landing_page_id IS NULL ");
                }
            }
            
            if (status != null && !status.isEmpty()) {
                 if ("PENDING".equals(status)) {
                    sql.append("AND ls.is_processed = 0 ");
                } else if ("PROCESSED".equals(status)) {
                    sql.append("AND ls.is_processed = 1 ");
                }
            }

             if (fromDate != null) {
                sql.append("AND CAST(ls.submitted_at AS DATE) >= ? ");
                params.add(fromDate);
            }
            
            if (toDate != null) {
                sql.append("AND CAST(ls.submitted_at AS DATE) <= ? ");
                params.add(toDate);
            }
            
            stmt = conn.prepareStatement(sql.toString());
             for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error counting submissions: " + e.getMessage());
            e.printStackTrace();
        } finally {
             closeResources(rs, stmt, conn);
        }
        return 0;
    }

    @Override
    public void delete(Integer id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "DELETE FROM LeadSubmissions WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error deleting submission: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    @Override
    public boolean markAsProcessed(Integer id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            // Optimistic Locking: Only update if it is currently NOT processed (0)
            // This prevents race condition where 2 users convert the same submission at the same time.
            String sql = "UPDATE LeadSubmissions SET is_processed = 1 WHERE id = ? AND is_processed = 0";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0; // If 0, it means it was already processed (or id not found)
            
        } catch (SQLException e) {
            System.err.println("Error marking submission as processed: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public int countPending(Integer marketingId) {
        int count = 0;
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM LeadSubmissions ls " +
            "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
            "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
            "WHERE ls.is_processed = 0"
        );
        
        List<Object> params = new ArrayList<>();
        if (marketingId != null) {
            sql.append(" AND (lp.created_by = ? OR c.manager_id = ?) ");
            params.add(marketingId);
            params.add(marketingId);
        }

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error counting pending submissions: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public int countToday(Integer marketingId) {
        int count = 0;
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM LeadSubmissions ls " +
            "LEFT JOIN Campaigns c ON ls.campaign_id = c.id " +
            "LEFT JOIN LandingPages lp ON ls.landing_page_id = lp.id " +
            "WHERE CAST(ls.submitted_at AS DATE) = CAST(GETDATE() AS DATE)"
        );
        
        List<Object> params = new ArrayList<>();
        if (marketingId != null) {
            sql.append(" AND (lp.created_by = ? OR c.manager_id = ?) ");
            params.add(marketingId);
            params.add(marketingId);
        }

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error counting today submissions: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public boolean exists(String email, String phone) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM LeadSubmissions WHERE email = ? OR phone = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, phone);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking existence: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return false;
    }

    /**
     * Map ResultSet to LeadSubmission object
     */
    private LeadSubmission mapResultSetToSubmission(ResultSet rs) throws SQLException {
        LeadSubmission submission = new LeadSubmission();
        submission.setId(rs.getInt("id"));
        int lpId = rs.getInt("landing_page_id");
        if (!rs.wasNull()) {
             submission.setLandingPageId(lpId);
        }
        submission.setCampaignId(rs.getInt("campaign_id"));
        
        // Map Transient Fields (Check if columns exist to avoid error if reuse mapRow in simple queries)
        try {
            submission.setCampaignName(rs.getString("campaign_name"));
            submission.setLandingPageName(rs.getString("landing_page_name"));
        } catch (SQLException e) {
            // Column might not exist in some queries (e.g. findByLandingPageId if not updated)
            // Ignore or log
        }

        submission.setSource(rs.getString("source"));
        submission.setFullName(rs.getString("full_name"));
        submission.setEmail(rs.getString("email"));
        submission.setPhone(rs.getString("phone"));
        submission.setIsProcessed(rs.getBoolean("is_processed"));
        submission.setSubmittedAt(rs.getTimestamp("submitted_at"));
        return submission;
    }
    
    /**
     * Close database resources
     */
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }
        
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
        
        if (conn != null) {
            dbUtil.closeConnection(conn);
        }
    }
}
