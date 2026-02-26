package dao.impl;

import dao.AutomationRuleDAO;
import model.entity.AutomationRule;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutomationRuleDAOImpl implements AutomationRuleDAO {

    private final DatabaseUtil dbUtil;

    public AutomationRuleDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<AutomationRule> findAll() {
        String sql = "SELECT r.id, r.rule_name, r.target_type, r.conditions_json, " +
                "r.action_type, r.assign_strategy, r.assign_to_user, r.status, " +
                "r.created_by, r.created_at, r.updated_at, " +
                "u.full_name AS assign_to_user_name " +
                "FROM AutomationRules r " +
                "LEFT JOIN Users u ON r.assign_to_user = u.id " +
                "ORDER BY r.created_at DESC";

        List<AutomationRule> rules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                rules.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return rules;
    }

    @Override
    public AutomationRule findById(int id) {
        String sql = "SELECT r.id, r.rule_name, r.target_type, r.conditions_json, " +
                "r.action_type, r.assign_strategy, r.assign_to_user, r.status, " +
                "r.created_by, r.created_at, r.updated_at, " +
                "u.full_name AS assign_to_user_name " +
                "FROM AutomationRules r " +
                "LEFT JOIN Users u ON r.assign_to_user = u.id " +
                "WHERE r.id = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public boolean create(AutomationRule rule) {
        String sql = "INSERT INTO AutomationRules (rule_name, target_type, conditions_json, " +
                "action_type, assign_strategy, assign_to_user, status, created_by, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, rule.getRuleName());
            stmt.setString(2, rule.getTargetType());
            stmt.setString(3, rule.getConditionsJson());
            stmt.setString(4, rule.getActionType());
            stmt.setString(5, rule.getAssignStrategy());
            if (rule.getAssignToUser() != null) {
                stmt.setInt(6, rule.getAssignToUser());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            stmt.setString(7, rule.getStatus());
            if (rule.getCreatedBy() != null) {
                stmt.setInt(8, rule.getCreatedBy());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean update(AutomationRule rule) {
        String sql = "UPDATE AutomationRules SET rule_name = ?, target_type = ?, conditions_json = ?, " +
                "action_type = ?, assign_strategy = ?, assign_to_user = ?, status = ?, " +
                "updated_at = GETDATE() WHERE id = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, rule.getRuleName());
            stmt.setString(2, rule.getTargetType());
            stmt.setString(3, rule.getConditionsJson());
            stmt.setString(4, rule.getActionType());
            stmt.setString(5, rule.getAssignStrategy());
            if (rule.getAssignToUser() != null) {
                stmt.setInt(6, rule.getAssignToUser());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            stmt.setString(7, rule.getStatus());
            stmt.setInt(8, rule.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean delete(int id) {
        String deleteLogsSql = "DELETE FROM SystemJobLogs WHERE rule_id = ?";
        String deleteRuleSql = "DELETE FROM AutomationRules WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmtLogs = null;
        PreparedStatement stmtRule = null;

        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Xóa các log liên quan
            stmtLogs = conn.prepareStatement(deleteLogsSql);
            stmtLogs.setInt(1, id);
            stmtLogs.executeUpdate();

            // 2. Xóa rule
            stmtRule = conn.prepareStatement(deleteRuleSql);
            stmtRule.setInt(1, id);
            int affectedRows = stmtRule.executeUpdate();

            conn.commit(); // Hoàn tất transaction
            return affectedRows > 0;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Hoàn tác nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            // Đóng tài nguyên thủ công vì không dùng try-with-resources cho Statement riêng
            // lẻ ở đây để dễ rollback
            try {
                if (stmtLogs != null)
                    stmtLogs.close();
                if (stmtRule != null)
                    stmtRule.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            dbUtil.closeConnection(conn);
        }
    }

    @Override
    public boolean toggleStatus(int id, String status) {
        String sql = "UPDATE AutomationRules SET status = ?, updated_at = GETDATE() WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
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

    private AutomationRule mapRow(ResultSet rs) throws SQLException {
        AutomationRule rule = new AutomationRule();
        rule.setId(rs.getInt("id"));
        rule.setRuleName(rs.getString("rule_name"));
        rule.setTargetType(rs.getString("target_type"));
        rule.setConditionsJson(rs.getString("conditions_json"));
        rule.setActionType(rs.getString("action_type"));
        rule.setAssignStrategy(rs.getString("assign_strategy"));

        int assignTo = rs.getInt("assign_to_user");
        if (rs.wasNull()) {
            rule.setAssignToUser(null);
        } else {
            rule.setAssignToUser(assignTo);
        }

        rule.setAssignToUserName(rs.getString("assign_to_user_name"));
        rule.setStatus(rs.getString("status"));

        int createdBy = rs.getInt("created_by");
        if (rs.wasNull()) {
            rule.setCreatedBy(null);
        } else {
            rule.setCreatedBy(createdBy);
        }

        rule.setCreatedAt(rs.getTimestamp("created_at"));
        rule.setUpdatedAt(rs.getTimestamp("updated_at"));
        return rule;
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
