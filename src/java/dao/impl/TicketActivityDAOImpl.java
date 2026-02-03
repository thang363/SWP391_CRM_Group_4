package dao.impl;

import dao.TicketActivityDAO;
import model.entity.TicketActivity;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketActivityDAOImpl implements TicketActivityDAO {

    private final DatabaseUtil dbUtil;

    public TicketActivityDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<TicketActivity> getActivitiesByTicketId(int ticketId) {
        String sql = "SELECT ta.id, ta.ticket_id, ta.user_id, ta.message, ta.activity_type, ta.created_at, " +
                "u.full_name as user_name " +
                "FROM TicketActivities ta " +
                "LEFT JOIN Users u ON ta.user_id = u.id " +
                "WHERE ta.ticket_id = ? " +
                "ORDER BY ta.created_at ASC"; // Oldest first for chat history

        List<TicketActivity> activities = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ticketId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                TicketActivity activity = new TicketActivity();
                activity.setId(rs.getInt("id"));
                activity.setTicketId(rs.getInt("ticket_id"));
                activity.setUserId(rs.getInt("user_id"));
                activity.setMessage(rs.getString("message"));
                activity.setActivityType(rs.getString("activity_type"));
                activity.setCreatedAt(rs.getTimestamp("created_at"));
                activity.setUserName(rs.getString("user_name"));

                activities.add(activity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                dbUtil.closeConnection(conn);
            }
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException e) {
            }
            try {
                if (rs != null)
                    rs.close();
            } catch (SQLException e) {
            }
        }

        return activities;
    }

    @Override
    public boolean addActivity(TicketActivity activity) {
        String sql = "INSERT INTO TicketActivities (ticket_id, user_id, message, activity_type) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, activity.getTicketId());
            stmt.setInt(2, activity.getUserId());
            stmt.setString(3, activity.getMessage());
            stmt.setString(4, activity.getActivityType());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                dbUtil.closeConnection(conn);
            }
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException e) {
            }
        }
    }
}
