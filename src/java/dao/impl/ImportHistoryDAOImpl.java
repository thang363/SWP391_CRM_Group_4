package dao.impl;

import dao.ImportHistoryDAO;
import model.entity.ImportHistory;
import util.DatabaseUtil;
import java.sql.*;

public class ImportHistoryDAOImpl implements ImportHistoryDAO {

    private final DatabaseUtil dbUtil;

    public ImportHistoryDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public boolean existsChecksum(String checksum) {
        String sql = "SELECT COUNT(*) FROM ImportHistory WHERE checksum = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, checksum);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking checksum: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return false;
    }

    @Override
    public int countImportToday(int userId) {
        String sql = "SELECT COUNT(*) FROM ImportHistory WHERE user_id = ? AND CAST(imported_at AS DATE) = CAST(GETDATE() AS DATE)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting imports today: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return 0;
    }

    @Override
    public boolean insert(ImportHistory history) {
        String sql = "INSERT INTO ImportHistory (user_id, file_name, checksum, imported_at, total_rows, success_rows, error_rows) " +
                     "VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, history.getUserId());
            stmt.setString(2, history.getFileName());
            stmt.setString(3, history.getChecksum());
            stmt.setInt(4, history.getTotalRows());
            stmt.setInt(5, history.getSuccessRows());
            stmt.setInt(6, history.getErrorRows());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting import history: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        dbUtil.closeConnection(conn);
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
    }
}
