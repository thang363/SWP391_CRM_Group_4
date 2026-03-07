package dao.impl;

import dao.AuditDAO;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Implementation of AuditDAO
 */
public class AuditDAOImpl implements AuditDAO {

    private final DatabaseUtil dbUtil;

    public AuditDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public void log(Integer userId, String action, String entity, Integer entityId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "INSERT INTO AuditLogs (user_id, action, entity, entity_id, created_at) " +
                    "VALUES (?, ?, ?, ?, GETDATE())";

            stmt = conn.prepareStatement(sql);
            if (userId != null) {
                stmt.setInt(1, userId);
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, action);
            stmt.setString(3, entity);
            if (entityId != null) {
                stmt.setInt(4, entityId);
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }

            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error logging audit: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(stmt, conn);
        }
    }

    private void closeResources(PreparedStatement stmt, Connection conn) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
            }
        }
        if (conn != null) {
            dbUtil.closeConnection(conn);
        }
    }
}
