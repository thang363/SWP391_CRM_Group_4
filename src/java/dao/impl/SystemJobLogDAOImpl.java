package dao.impl;

import dao.SystemJobLogDAO;
import model.entity.SystemJobLog;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SystemJobLogDAOImpl implements SystemJobLogDAO {

    private final DatabaseUtil dbUtil;

    public SystemJobLogDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<SystemJobLog> findAll() {
        String sql = "SELECT j.id, j.rule_id, r.rule_name, j.execution_time, j.status, " +
                "j.records_created, j.error_message, j.created_at " +
                "FROM SystemJobLogs j " +
                "LEFT JOIN AutomationRules r ON j.rule_id = r.id " +
                "ORDER BY j.execution_time DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<SystemJobLog> logs = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                logs.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return logs;
    }

    @Override
    public SystemJobLog findById(int id) {
        String sql = "SELECT j.id, j.rule_id, r.rule_name, j.execution_time, j.status, " +
                "j.records_created, j.error_message, j.created_at " +
                "FROM SystemJobLogs j " +
                "LEFT JOIN AutomationRules r ON j.rule_id = r.id " +
                "WHERE j.id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public boolean create(SystemJobLog log) {
        String sql = "INSERT INTO SystemJobLogs (rule_id, execution_time, status, records_created, error_message) " +
                "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, log.getRuleId());
            stmt.setTimestamp(2, log.getExecutionTime() != null ? log.getExecutionTime()
                    : new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, log.getStatus());
            stmt.setInt(4, log.getRecordsCreated());
            stmt.setString(5, log.getErrorMessage());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    private SystemJobLog mapResultSet(ResultSet rs) throws SQLException {
        SystemJobLog log = new SystemJobLog();
        log.setId(rs.getInt("id"));
        log.setRuleId(rs.getInt("rule_id"));
        log.setRuleName(rs.getString("rule_name"));
        log.setExecutionTime(rs.getTimestamp("execution_time"));
        log.setStatus(rs.getString("status"));
        log.setRecordsCreated(rs.getInt("records_created"));
        log.setErrorMessage(rs.getString("error_message"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
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
        if (conn != null) {
            dbUtil.closeConnection(conn);
        }
    }
}
