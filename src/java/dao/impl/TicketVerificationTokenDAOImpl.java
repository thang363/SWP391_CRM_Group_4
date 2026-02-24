package dao.impl;

import dao.TicketVerificationTokenDAO;
import model.entity.TicketVerificationToken;
import util.DatabaseUtil;

import java.sql.*;
import java.util.Date;

public class TicketVerificationTokenDAOImpl implements TicketVerificationTokenDAO {

    private final DatabaseUtil dbUtil;

    public TicketVerificationTokenDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public boolean saveToken(int ticketId, String token, Date expiresAt) {
        String sql = "INSERT INTO TicketVerificationTokens (ticket_id, token, is_used, expires_at, created_at) "
                + "VALUES (?, ?, 0, ?, GETDATE())";
        try (Connection conn = dbUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            stmt.setString(2, token);
            stmt.setTimestamp(3, new Timestamp(expiresAt.getTime()));
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public TicketVerificationToken findByToken(String token) {
        String sql = "SELECT id, ticket_id, token, is_used, expires_at, created_at "
                + "FROM TicketVerificationTokens WHERE token = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            rs = stmt.executeQuery();
            if (rs.next()) {
                TicketVerificationToken t = new TicketVerificationToken();
                t.setId(rs.getInt("id"));
                t.setTicketId(rs.getInt("ticket_id"));
                t.setToken(rs.getString("token"));
                t.setUsed(rs.getBoolean("is_used"));
                t.setExpiresAt(rs.getTimestamp("expires_at"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public boolean markAsUsed(String token) {
        String sql = "UPDATE TicketVerificationTokens SET is_used = 1 WHERE token = ?";
        try (Connection conn = dbUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null)
                rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (stmt != null)
                stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (conn != null)
            dbUtil.closeConnection(conn);
    }
}
