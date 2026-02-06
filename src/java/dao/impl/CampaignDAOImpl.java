package dao.impl;

import dao.CampaignDAO;
import model.entity.Campaign;
import util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of CampaignDAO interface
 */
public class CampaignDAOImpl implements CampaignDAO {
    
    private final DatabaseUtil dbUtil;
    
    public CampaignDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }
    
    @Override
    public Campaign findById(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT c.* " +
                        "FROM Campaigns c " +
                        "WHERE c.id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCampaign(rs);
            }
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error finding campaign by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public List<Campaign> findAll() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Campaign> campaigns = new ArrayList<>();
        
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT c.* " +
                        "FROM Campaigns c " +
                        "ORDER BY c.created_at DESC";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                campaigns.add(mapResultSetToCampaign(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding all campaigns: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return campaigns;
    }
    
    @Override
    public List<Campaign> findByFilters(String name, String status, Timestamp startDate, Timestamp endDate, Long managerId, int offset, int limit) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Campaign> campaigns = new ArrayList<>();
        
        try {
            conn = dbUtil.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT c.* " +
                "FROM Campaigns c " +
                "WHERE 1=1"
            );
            
            List<Object> params = new ArrayList<>();
            
            // Filter by name (partial match)
            if (name != null && !name.trim().isEmpty()) {
                sql.append(" AND c.name LIKE ?");
                params.add("%" + name.trim() + "%");
            }
            
            // Filter by status
            if (status != null && !status.trim().isEmpty()) {
                sql.append(" AND c.status = ?");
                params.add(status);
            }
            
            // Filter by date range
            if (startDate != null) {
                sql.append(" AND c.start_date >= ?");
                params.add(startDate);
            }
            
            if (endDate != null) {
                sql.append(" AND c.end_date <= ?");
                params.add(endDate);
            }
            
            // Filter by manager ID (for manager-level access control)
            if (managerId != null) {
                sql.append(" AND c.manager_id = ?");
                params.add(managerId);
            }
            
            sql.append(" ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            params.add(offset);
            params.add(limit);
            
            stmt = conn.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Timestamp) {
                    stmt.setTimestamp(i + 1, (Timestamp) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof Long) {
                    stmt.setLong(i + 1, (Long) param);
                }
            }
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                campaigns.add(mapResultSetToCampaign(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding campaigns by filters: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return campaigns;
    }

    @Override
    public int countByFilters(String name, String status, Timestamp startDate, Timestamp endDate, Long managerId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Campaigns c WHERE 1=1"
            );
            
            List<Object> params = new ArrayList<>();
            
            if (name != null && !name.trim().isEmpty()) {
                sql.append(" AND c.name LIKE ?");
                params.add("%" + name.trim() + "%");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                sql.append(" AND c.status = ?");
                params.add(status);
            }
            
            if (startDate != null) {
                sql.append(" AND c.start_date >= ?");
                params.add(startDate);
            }
            
            if (endDate != null) {
                sql.append(" AND c.end_date <= ?");
                params.add(endDate);
            }
            
            // Filter by manager ID (for manager-level access control)
            if (managerId != null) {
                sql.append(" AND c.manager_id = ?");
                params.add(managerId);
            }
            
            stmt = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Timestamp) {
                    stmt.setTimestamp(i + 1, (Timestamp) param);
                } else if (param instanceof Long) {
                    stmt.setLong(i + 1, (Long) param);
                }
            }
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error counting filtered campaigns: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public Campaign create(Campaign campaign) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "INSERT INTO Campaigns (name, budget, start_date, end_date, manager_id, status, description) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, campaign.getName());
            stmt.setBigDecimal(2, campaign.getBudget());
            stmt.setTimestamp(3, campaign.getStartDate());
            stmt.setTimestamp(4, campaign.getEndDate());
            
            if (campaign.getManagerId() != null) {
                stmt.setLong(5, campaign.getManagerId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            
            stmt.setString(6, campaign.getStatus());
            stmt.setString(7, campaign.getDescription());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    campaign.setId(rs.getLong(1));
                    return campaign;
                }
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error creating campaign: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public boolean update(Campaign campaign) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "UPDATE Campaigns SET name = ?, budget = ?, start_date = ?, end_date = ?, " +
                        "manager_id = ?, status = ?, description = ? WHERE id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, campaign.getName());
            stmt.setBigDecimal(2, campaign.getBudget());
            stmt.setTimestamp(3, campaign.getStartDate());
            stmt.setTimestamp(4, campaign.getEndDate());
            
            if (campaign.getManagerId() != null) {
                stmt.setLong(5, campaign.getManagerId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            
            stmt.setString(6, campaign.getStatus());
            stmt.setString(7, campaign.getDescription());
            stmt.setLong(8, campaign.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating campaign: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    @Override
    public boolean delete(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "DELETE FROM Campaigns WHERE id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting campaign: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    @Override
    public int countAll() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM Campaigns";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error counting campaigns: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public int countByStatus(String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM Campaigns WHERE status = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error counting campaigns by status: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    /**
     * Map ResultSet to Campaign object
     */
    private Campaign mapResultSetToCampaign(ResultSet rs) throws SQLException {
        Campaign campaign = new Campaign();
        campaign.setId(rs.getLong("id"));
        campaign.setName(rs.getString("name"));
        campaign.setBudget(rs.getBigDecimal("budget"));
        campaign.setStartDate(rs.getTimestamp("start_date"));
        campaign.setEndDate(rs.getTimestamp("end_date"));
        
        Long managerId = rs.getLong("manager_id");
        if (!rs.wasNull()) {
            campaign.setManagerId(managerId);
        }
        
        campaign.setStatus(rs.getString("status"));
        campaign.setDescription(rs.getString("description"));
        campaign.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Set manager name if available
        // Manager name is now handled by Service/ViewModel, not DAO
        
        return campaign;
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
