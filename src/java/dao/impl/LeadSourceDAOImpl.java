package dao.impl;

import dao.LeadSourceDAO;
import model.entity.LeadSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseUtil;

public class LeadSourceDAOImpl implements LeadSourceDAO {

    private final DatabaseUtil dbUtil;

    public LeadSourceDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<LeadSource> findAll() {
        String sql = "SELECT * FROM LeadSources ORDER BY name";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LeadSource> list = new ArrayList<>();
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new LeadSource(rs.getInt("id"), rs.getString("name")));
            }
        } catch (SQLException e) {
            System.err.println("Error finding all sources: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public Integer getIdByName(String name) {
        String sql = "SELECT id FROM LeadSources WHERE name = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            System.err.println("Error getting LeadSource by name: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public Integer insert(String name) {
        String sql = "INSERT INTO LeadSources (name) VALUES (?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, name);
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error inserting LeadSource: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }
    
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        dbUtil.closeConnection(conn);
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
    }
}
