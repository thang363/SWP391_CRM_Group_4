package dao.impl;

import dao.TicketDAO;
import model.entity.Ticket;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAOImpl implements TicketDAO {

    private final DatabaseUtil dbUtil;

    public TicketDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<Ticket> getAllTickets() {
        String sql = "SELECT t.id, t.customer_id, t.title, t.description, t.status, t.priority, " +
                "t.assigned_to, t.solution_note, t.created_at, t.updated_at, " +
                "c.company_name as customer_name, " +
                "u.full_name as assigned_to_name " +
                "FROM Tickets t " +
                "LEFT JOIN Customers c ON t.customer_id = c.id " +
                "LEFT JOIN Users u ON t.assigned_to = u.id " +
                "ORDER BY t.created_at DESC";

        List<Ticket> tickets = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                tickets.add(mapResultSetToTicket(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return tickets;
    }

    @Override
    public List<Ticket> searchTickets(String keyword, String status, String priority, Integer assignedTo,
            boolean isUnassigned) {
        StringBuilder sql = new StringBuilder(
                "SELECT t.id, t.customer_id, t.title, t.description, t.status, t.priority, " +
                        "t.assigned_to, t.solution_note, t.created_at, t.updated_at, " +
                        "c.company_name as customer_name, " +
                        "u.full_name as assigned_to_name " +
                        "FROM Tickets t " +
                        "LEFT JOIN Customers c ON t.customer_id = c.id " +
                        "LEFT JOIN Users u ON t.assigned_to = u.id " +
                        "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchPattern = "%" + keyword.trim() + "%";
            // Search in ID OR Company Name
            sql.append("AND (CAST(t.id AS VARCHAR(20)) LIKE ? OR c.company_name LIKE ?) ");
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND t.status = ? ");
            params.add(status);
        }

        if (priority != null && !priority.trim().isEmpty()) {
            sql.append("AND t.priority = ? ");
            params.add(priority);
        }

        if (isUnassigned) {
            sql.append("AND t.assigned_to IS NULL ");
        } else if (assignedTo != null) {
            sql.append("AND t.assigned_to = ? ");
            params.add(assignedTo);
        }

        sql.append("ORDER BY t.created_at DESC");

        List<Ticket> tickets = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    stmt.setString(paramIndex++, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(paramIndex++, (Integer) param);
                }
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                tickets.add(mapResultSetToTicket(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return tickets;
    }

    // Helper method to set params

    @Override
    public Ticket getTicketById(int id) {
        String sql = "SELECT t.id, t.customer_id, t.title, t.description, t.status, t.priority, " +
                "t.assigned_to, t.solution_note, t.created_at, t.updated_at, " +
                "c.company_name as customer_name, " +
                "u.full_name as assigned_to_name " +
                "FROM Tickets t " +
                "LEFT JOIN Customers c ON t.customer_id = c.id " +
                "LEFT JOIN Users u ON t.assigned_to = u.id " +
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
                return mapResultSetToTicket(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public boolean updateStatus(int ticketId, String status) {
        String sql = "UPDATE Tickets SET status = ?, updated_at = GETDATE() WHERE id = ?";
        try (Connection conn = dbUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatusAndNote(int ticketId, String status, String note) {
        String sql = "UPDATE Tickets SET status = ?, solution_note = ?, updated_at = GETDATE() WHERE id = ?";
        try (Connection conn = dbUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, note);
            stmt.setInt(3, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updatePriority(int ticketId, String priority) {
        String sql = "UPDATE Tickets SET priority = ?, updated_at = GETDATE() WHERE id = ?";
        try (Connection conn = dbUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, priority);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean assignTicket(int ticketId, Integer userId) {

        String statusToUpdate = (userId != null) ? "In Progress" : "Open";
        String sql = "UPDATE Tickets SET assigned_to = ?, status = ?, updated_at = GETDATE() WHERE id = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);

            if (userId != null) {
                stmt.setInt(1, userId);
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setString(2, statusToUpdate);
            stmt.setInt(3, ticketId);

            int rows = stmt.executeUpdate();
            return rows > 0;

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

    @Override
    public int createTicket(Ticket ticket) {
        String sql = "INSERT INTO Tickets (customer_id, title, description, status, priority, assigned_to, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, ticket.getCustomerId());
            stmt.setString(2, ticket.getTitle());
            stmt.setString(3, ticket.getDescription());
            stmt.setString(4, ticket.getStatus());
            stmt.setString(5, ticket.getPriority());

            if (ticket.getAssignedTo() != null) {
                stmt.setInt(6, ticket.getAssignedTo());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating ticket failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating ticket failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private Ticket mapResultSetToTicket(ResultSet rs) throws SQLException {
        Ticket ticket = new Ticket();
        ticket.setId(rs.getInt("id"));
        ticket.setCustomerId(rs.getInt("customer_id"));
        ticket.setCustomerName(rs.getString("customer_name"));
        ticket.setTitle(rs.getString("title"));
        ticket.setDescription(rs.getString("description"));
        ticket.setStatus(rs.getString("status"));
        ticket.setPriority(rs.getString("priority"));
        ticket.setSolutionNote(rs.getString("solution_note"));

        int assignedTo = rs.getInt("assigned_to");
        if (rs.wasNull()) {
            ticket.setAssignedTo(null);
        } else {
            ticket.setAssignedTo(assignedTo);
        }

        ticket.setAssignedToName(rs.getString("assigned_to_name"));
        ticket.setCreatedAt(rs.getTimestamp("created_at"));
        ticket.setUpdatedAt(rs.getTimestamp("updated_at"));
        return ticket;
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
