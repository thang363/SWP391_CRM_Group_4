package dao.impl;

import dao.LandingPageDAO;
import model.entity.LandingPage;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LandingPageDAOImpl implements LandingPageDAO {

    private final DatabaseUtil dbUtil;

    public LandingPageDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public LandingPage findById(Integer id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT * FROM LandingPages WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public LandingPage findByCampaignId(Integer campaignId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT * FROM LandingPages WHERE campaign_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<LandingPage> findAll() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LandingPage> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT * FROM LandingPages ORDER BY id DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public List<LandingPage> findByStatus(String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LandingPage> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT * FROM LandingPages WHERE status = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public LandingPage create(LandingPage lp) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "INSERT INTO LandingPages (campaign_id, data_config, status, " +
                    "manager_comment, approved_by, created_at, name, created_by, view_count, brief) " +
                    "VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setObject(1, lp.getCampaignId());
            // stmt.setString(2, lp.getHtmlTemplate()); -> NULL since column might be NOT NULL in DB
            stmt.setString(3, lp.getDataConfig());
            stmt.setString(4, lp.getStatus());
            stmt.setString(5, lp.getManagerComment());
            stmt.setObject(6, lp.getApprovedBy());
            stmt.setTimestamp(7, lp.getCreatedAt());
            stmt.setString(8, lp.getName());
            stmt.setObject(9, lp.getCreatedBy());
            stmt.setInt(10, lp.getViewCount() != null ? lp.getViewCount() : 0);
            stmt.setString(11, lp.getBrief());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    lp.setId(rs.getInt(1));
                    return lp;
                }
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean update(LandingPage lp) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "UPDATE LandingPages SET campaign_id=?, data_config=?, status=?, " +
                    "manager_comment=?, approved_by=?, name=?, created_by=?, view_count=?, brief=? WHERE id=?";
            
            stmt = conn.prepareStatement(sql);
            
            stmt.setObject(1, lp.getCampaignId());
            stmt.setString(2, lp.getDataConfig());
            stmt.setString(3, lp.getStatus());
            stmt.setString(4, lp.getManagerComment());
            stmt.setObject(5, lp.getApprovedBy());
            stmt.setString(6, lp.getName());
            stmt.setObject(7, lp.getCreatedBy());
            stmt.setInt(8, lp.getViewCount());
            stmt.setString(9, lp.getBrief());
            stmt.setInt(10, lp.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean delete(Integer id) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "DELETE FROM LandingPages WHERE id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateStatus(Integer id, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "UPDATE LandingPages SET status=? WHERE id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateContent(Integer id, String dataConfig) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "UPDATE LandingPages SET data_config=? WHERE id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, dataConfig);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public List<LandingPage> findAllByCampaignId(Integer campaignId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LandingPage> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT * FROM LandingPages WHERE campaign_id = ? ORDER BY id DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    private LandingPage mapRow(ResultSet rs) throws SQLException {
        LandingPage lp = new LandingPage();
        lp.setId(rs.getInt("id"));
        lp.setCampaignId((Integer) rs.getObject("campaign_id"));
        lp.setDataConfig(rs.getString("data_config"));
        lp.setStatus(rs.getString("status"));
        lp.setManagerComment(rs.getString("manager_comment"));
        lp.setApprovedBy((Integer) rs.getObject("approved_by"));
        lp.setCreatedAt(rs.getTimestamp("created_at"));
        lp.setName(rs.getString("name"));
        lp.setCreatedBy((Integer) rs.getObject("created_by"));
        lp.setViewCount(rs.getInt("view_count"));
        lp.setBrief(rs.getString("brief"));
        return lp;
    }

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
