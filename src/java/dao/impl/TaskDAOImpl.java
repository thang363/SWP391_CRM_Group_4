package dao.impl;

import dao.TaskDAO;
import model.entity.Task;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAOImpl implements TaskDAO {

    private final DatabaseUtil dbUtil;

    public TaskDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<Task> findByUser(int userId) {
        String sql = "SELECT t.id, t.title, t.description, t.due_date, t.status, " +
                "t.assigned_to, t.related_to_entity, t.related_record_id, " +
                "t.task_type, t.created_at, " +
                "u.full_name AS assigned_to_name, " +
                "c.company_name AS customer_name " +
                "FROM Tasks t " +
                "LEFT JOIN Users u ON t.assigned_to = u.id " +
                "LEFT JOIN Customers c ON t.related_to_entity = 'Customer' AND t.related_record_id = c.id " +
                "WHERE t.assigned_to = ? " +
                "ORDER BY CASE t.status WHEN 'Pending' THEN 1 WHEN 'Overdue' THEN 2 ELSE 3 END, t.created_at DESC";

        List<Task> tasks = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                tasks.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return tasks;
    }

    @Override
    public List<Task> findAll() {
        String sql = "SELECT t.id, t.title, t.description, t.due_date, t.status, " +
                "t.assigned_to, t.related_to_entity, t.related_record_id, " +
                "t.task_type, t.created_at, " +
                "u.full_name AS assigned_to_name, " +
                "c.company_name AS customer_name " +
                "FROM Tasks t " +
                "LEFT JOIN Users u ON t.assigned_to = u.id " +
                "LEFT JOIN Customers c ON t.related_to_entity = 'Customer' AND t.related_record_id = c.id " +
                "ORDER BY t.created_at DESC";

        List<Task> tasks = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                tasks.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return tasks;
    }

    @Override
    public Task findById(int id) {
        String sql = "SELECT t.id, t.title, t.description, t.due_date, t.status, " +
                "t.assigned_to, t.related_to_entity, t.related_record_id, " +
                "t.task_type, t.created_at, " +
                "u.full_name AS assigned_to_name, " +
                "c.company_name AS customer_name " +
                "FROM Tasks t " +
                "LEFT JOIN Users u ON t.assigned_to = u.id " +
                "LEFT JOIN Customers c ON t.related_to_entity = 'Customer' AND t.related_record_id = c.id " +
                "WHERE t.id = ?";

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
    public int create(Task task) {
        String sql = "INSERT INTO Tasks (title, description, due_date, status, assigned_to, " +
                "related_to_entity, related_record_id, task_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());

            if (task.getDueDate() != null) {
                stmt.setTimestamp(3, task.getDueDate());
            } else {
                stmt.setNull(3, Types.TIMESTAMP);
            }

            stmt.setString(4, task.getStatus() != null ? task.getStatus() : "Pending");

            if (task.getAssignedTo() != null) {
                stmt.setInt(5, task.getAssignedTo());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            stmt.setString(6, task.getRelatedToEntity());

            if (task.getRelatedRecordId() != null) {
                stmt.setInt(7, task.getRelatedRecordId());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }

            stmt.setString(8, task.getTaskType());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return -1;
    }

    @Override
    public boolean updateStatus(int taskId, String status) {
        String sql = "UPDATE Tasks SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, taskId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    private Task mapRow(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setId(rs.getInt("id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setDueDate(rs.getTimestamp("due_date"));
        task.setStatus(rs.getString("status"));

        int assignedTo = rs.getInt("assigned_to");
        task.setAssignedTo(rs.wasNull() ? null : assignedTo);
        task.setAssignedToName(rs.getString("assigned_to_name"));

        task.setRelatedToEntity(rs.getString("related_to_entity"));

        int relatedId = rs.getInt("related_record_id");
        task.setRelatedRecordId(rs.wasNull() ? null : relatedId);
        task.setCustomerName(rs.getString("customer_name"));


        task.setTaskType(rs.getString("task_type"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        return task;
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
